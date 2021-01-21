
import Foundation

class Network {
    
    static let shared: Network = Network()
    
    func getWeather(city: String, units: units, result: @escaping ((WeatherData?) -> () )){
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.openweathermap.org"
        urlComponent.path = "/data/2.5/weather"
        urlComponent.queryItems = [URLQueryItem(name: "q", value: city),
                                   URLQueryItem(name: "units", value: units.rawValue),
                                   URLQueryItem(name: "appid", value: "be152b4fa203269e3d03e5b8f69a4422"),
                                   URLQueryItem(name: "lang", value: "ru")]
        
        URLSession.shared.dataTask(with: urlComponent.url!) { (data, response, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            let decoder = JSONDecoder()
            var decodWeather: WeatherData?
                do {
                    decodWeather = try decoder.decode(WeatherData.self, from: data!)
                } catch  {
                    print(error.localizedDescription)
                }
            if decodWeather != nil {
                WeatherCoreData.addNew(save: decodWeather!)
                CoreDataManager.shared.saveContext()
            }
            result(decodWeather)
        }.resume()
    }
    
    
    func getCurrency(reload:() -> ()){
        
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
                    print(error.localizedDescription)
                }
            if decodCurrency != nil {
                var value: [Valute] = []
                let keys = decodCurrency!.Valute.keys.sorted()
                for key in keys {
                    value.append((decodCurrency?.Valute[key])!)
                }
                if !value.isEmpty {
                    CurrencyTest.addNew(saved: value)
                }
            }
        }.resume()
    }
}
