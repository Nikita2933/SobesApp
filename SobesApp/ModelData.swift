

struct Main: Codable {
    var temp: Double?
    var feels_like: Double?
    var pressure: Int?
}

struct WeatherData: Codable {
    var main: Main = Main()
    var name: String = ""
}

enum units: String {
    case st = "standard"
    case met = "metric"
    case imp = "imperial"
}

