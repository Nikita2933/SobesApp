
import Foundation

class Network {
    
    static let shared: Network = Network()
    
    var weatherData = WeatherData()
    
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
            result(decodWeather)
            
        }.resume()
    }
}
