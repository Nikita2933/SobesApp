
// Weather struct Json


struct Main: Codable {
    var temp: Double = 0
    var feels_like: Double = 0
    var pressure: Int = 0
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
 
protocol WeatherVCDelegate: class {
    func TabSearchBar(s: String)
}
