
//MARK: Weather struct Json

struct WeatherData: Codable {
    var main: Main = Main()
    let weather: [Weather]
    var name: String = ""
    let coord: Coord
}

struct Main: Codable {
    var temp: Double = 0
    var feels_like: Double = 0
    var pressure: Int = 0
}

struct Weather: Codable {
    var main: String = ""
    var icon: String = ""
}

struct Coord: Codable {
    let lon: Double?
    let lat: Double?
}
enum units: String {
    case st = "standard"
    case met = "metric"
    case imp = "imperial"
}


