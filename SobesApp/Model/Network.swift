
import Foundation

class Network {
    
    enum APIServiceError: Error {
        case badGateway
        case decodeError
        case invalidResponse
        case noData
    }
    
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
    
    func getWeather(city: String, units: units, result: @escaping (Result<WeatherData, APIServiceError>) -> () ){
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.openweathermap.org"
        urlComponent.path = "/data/2.5/weather"
        urlComponent.queryItems = [URLQueryItem(name: "q", value: city),
                                   URLQueryItem(name: "units", value: units.rawValue),
                                   URLQueryItem(name: "appid", value: apiKey),
                                   URLQueryItem(name: "lang", value: "ru")]
        
        URLSession.shared.dataTask(with: urlComponent.url!) { (data, response, error) in
            if error != nil {
                result(.failure(.badGateway))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                result(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                result(.failure(.noData))
                return
            }
            do {
                let decodWeather = try JSONDecoder().decode(WeatherData.self, from: data)
                result(.success(decodWeather))
            } catch  {
                print(error)
                result(.failure(.decodeError))
            }

        }.resume()
    }
    
    
    func getCurrency(result: @escaping (Result<Currency, APIServiceError>)->() ) {
        
        var request = URLRequest(url: URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        
        let urlConfig = URLSessionConfiguration.default
        urlConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        urlConfig.urlCache = nil
        
        let session = URLSession(configuration: urlConfig)
        
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                result(.failure(.badGateway))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                result(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                result(.failure(.noData))
                return
            }

            do {
                let decodCurrency = try JSONDecoder().decode(Currency.self, from: data)
                result(.success(decodCurrency))
            } catch  {
                result(.failure(.decodeError))
            }
        }.resume()
    }
    
    func getWeatherDetail(lon: Double, lat: Double, result: @escaping (Result<WeatherDetailClass, APIServiceError>) -> () ) {

        var urlComponent = URLComponents()
        
        urlComponent.scheme = "https"
        urlComponent.host = "api.openweathermap.org"
        urlComponent.path = "/data/2.5/onecall"
        urlComponent.queryItems = [URLQueryItem(name: "lat", value: String(lat)),
                                   URLQueryItem(name: "lon", value: String(lon)),
                                   URLQueryItem(name: "appid", value: apiKey),
                                   URLQueryItem(name: "units", value: "metric")]
        
        URLSession.shared.dataTask(with: urlComponent.url!) { (data, response, error) in
            if error != nil  {
                result(.failure(.badGateway))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                result(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                result(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodWeather = try decoder.decode(WeatherDetailClass.self, from: data)
                result(.success(decodWeather))
            } catch  {
                result(.failure(.decodeError))
            }
            
        }.resume()
    }
}
