
import Foundation

class Network {
    
    static let shared: Network = Network()
    var apiKey: String?
    
    private func getApiKeyFromPlist() throws -> String {
        var dictionary: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            dictionary = NSDictionary(contentsOfFile: path)
        }
        
        guard let key = dictionary?.value(forKey: "WeatherAPIKey") as? String else {
            throw NSError(domain: "Dadata API key missing in Info.plist", code: 1, userInfo: nil )
        }
        return key
    }
    
    init() {
        if let key = try? getApiKeyFromPlist() {
            apiKey = key
        }
    }
    
    func getWeather(city: String, units: units, result: @escaping ((WeatherData) -> () )){
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.openweathermap.org"
        urlComponent.path = "/data/2.5/weather"
        urlComponent.queryItems = [URLQueryItem(name: "q", value: city),
                                   URLQueryItem(name: "units", value: units.rawValue),
                                   URLQueryItem(name: "appid", value: apiKey),
                                   URLQueryItem(name: "lang", value: "ru")]
        
        URLSession.shared.dataTask(with: urlComponent.url!) { (data, response, error) in
            guard error == nil else {
                print(error as Any)
                return
            }
            let decoder = JSONDecoder()
            var decodWeather: WeatherData?
            do {
                decodWeather = try decoder.decode(WeatherData.self, from: data!)
            } catch  {
                print(error)
            }
            if decodWeather != nil {
                result(decodWeather!)
            }
        }.resume()
    }
    
    
    func getCurrency(reload: @escaping () -> ()){
        
        var request = URLRequest(url: URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let decoder = JSONDecoder()
            var decodCurrency: Currency?
            do {
                decodCurrency = try decoder.decode(Currency.self, from: data)
            } catch  {
                print(error)
            }
            if decodCurrency != nil {
                var valute: [Valute] = []
                let keys = decodCurrency!.Valute.keys.sorted()
                for key in keys {
                    valute.append((decodCurrency?.Valute[key])!)
                }
                if !valute.isEmpty {
                    CurrencyCoreData.addNew(saved: valute, time: decodCurrency!.PreviousDate)
                    reload()
                }
            }
        }.resume()
    }
    
    func getWeatherDetail(lon: Double, lat: Double, result: @escaping ((WeatherDetailClass) -> () )) {

        var urlComponent = URLComponents()
        
        urlComponent.scheme = "https"
        urlComponent.host = "api.openweathermap.org"
        urlComponent.path = "/data/2.5/onecall"
        urlComponent.queryItems = [URLQueryItem(name: "lat", value: String(lat)),
                                   URLQueryItem(name: "lon", value: String(lon)),
                                   URLQueryItem(name: "appid", value: apiKey),
                                   URLQueryItem(name: "units", value: "metric")]
        
        URLSession.shared.dataTask(with: urlComponent.url!) { (data, response, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            var decodWeather: WeatherDetailClass?
            do {
                decodWeather = try decoder.decode(WeatherDetailClass.self, from: data!)
            } catch  {
                print(error)
            }
            if decodWeather != nil {
                result(decodWeather!)
                
                //MARK: надо бы сохранять в кор дату
            }
            
        }.resume()
    }
}
