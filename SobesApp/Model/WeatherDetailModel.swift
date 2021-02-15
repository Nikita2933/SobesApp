//
//  WeatherDetail.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
//

import Foundation
    

class WeatherDetailClass: NSObject, Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    var daily: [Daily]
    let alerts: [Alert]?
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case timezone
        case timezoneOffset
        case current
        case hourly
        case daily
        case alerts
    }

    init(lat: Double, lon: Double, timezone: String, timezoneOffset: Int, current: Current, hourly: [Hourly], daily: [Daily], alerts: [Alert]?) {
        self.lat = lat
        self.lon = lon
        self.timezone = timezone
        self.timezoneOffset = timezoneOffset
        self.current = current
        self.hourly = hourly
        self.daily = daily
        self.alerts = alerts
    }
}

// MARK: - Alert
class Alert: NSObject, Codable {
    let senderName, event: String?
    let start, end: Int?
    let alertDescription: String?

    enum CodingKeys: String, CodingKey {
        case senderName
        case event, start, end
        case alertDescription
    }

    init(senderName: String?, event: String?, start: Int?, end: Int?, alertDescription: String?) {
        self.senderName = senderName
        self.event = event
        self.start = start
        self.end = end
        self.alertDescription = alertDescription
    }
}

// MARK: - Current
public class Current: NSObject, Codable {
    var dt, sunrise, sunset: Int
    var temp, feelsLike: Double
    var pressure, humidity: Int
    var dewPoint, uvi: Double
    var clouds, visibility: Int
    var windSpeed, windDeg: Double
    var weather: [WeatherModel]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike
        case pressure
        case humidity
        case dewPoint
        case uvi
        case clouds
        case visibility
        case windSpeed
        case windDeg
        case weather
    }

    init(dt: Int, sunrise: Int, sunset: Int, temp: Double, feelsLike: Double, pressure: Int, humidity: Int, dewPoint: Double, uvi: Double, clouds: Int, visibility: Int, windSpeed: Double, windDeg: Double, weather: [WeatherModel]) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.uvi = uvi
        self.clouds = clouds
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.weather = weather
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dt =        try container.decode(Int.self, forKey: .dt)
        sunrise =   try container.decode(Int.self, forKey: .sunrise)
        sunset =    try container.decode(Int.self, forKey: .sunset)
        temp =      try container.decode(Double.self, forKey: .temp)
        feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        pressure =  try container.decode(Int.self, forKey: .pressure)
        humidity =  try container.decode(Int.self, forKey: .humidity)
        dewPoint =  try container.decode(Double.self, forKey: .dewPoint)
        uvi =       try container.decode(Double.self, forKey: .uvi)
        clouds =    try container.decode(Int.self, forKey: .clouds)
        visibility = try container.decode(Int.self, forKey: .visibility)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        windDeg =   try container.decode(Double.self, forKey: .windDeg)
        weather =   try container.decode([WeatherModel].self, forKey: .weather)
        
    }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(dt, forKey: .dt)
//        try container.encode(sunrise, forKey: .sunrise)
//        try container.encode(sunset, forKey: .sunset)
//        try container.encode(temp, forKey: .temp)
//        try container.encode(feelsLike, forKey: .feelsLike)
//        try container.encode(pressure, forKey: .pressure)
//        try container.encode(humidity, forKey: .humidity)
//        try container.encode(dewPoint, forKey: .dewPoint)
//        try container.encode(uvi, forKey: .uvi)
//        try container.encode(clouds, forKey: .clouds)
//        try container.encode(visibility, forKey: .visibility)
//        try container.encode(windSpeed, forKey: .windSpeed)
//        try container.encode(windDeg, forKey: .windDeg)
//        try container.encode(weather, forKey: .weather)
//    }
    
}

// MARK: - Weather
class WeatherModel: NSObject, Codable {
    let id: Int
    let main, icon: String
    let descriptions: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case descriptions = "description"
        case icon
    }

    init(id: Int, main: String, descriptions: String, icon: String) {
        self.id = id
        self.main = main
        self.descriptions = descriptions
        self.icon = icon
    }
}

// MARK: - Daily
class Daily: NSObject, Codable {
    let dt, sunrise, sunset: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let weather: [WeatherModel]
    let clouds: Int
    let pop, uvi: Double
    let snow: Double?

    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike
        case pressure
        case humidity
        case dewPoint
        case windSpeed
        case windDeg
        case weather
        case clouds
        case pop
        case uvi
        case snow
    }

    init(dt: Int, sunrise: Int, sunset: Int, temp: Temp, feelsLike: FeelsLike, pressure: Int, humidity: Int, dewPoint: Double, windSpeed: Double, windDeg: Int, weather: [WeatherModel], clouds: Int, pop: Double, uvi: Double, snow: Double?) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.weather = weather
        self.clouds = clouds
        self.pop = pop
        self.uvi = uvi
        self.snow = snow
    }
}

// MARK: - FeelsLike
class FeelsLike: NSObject, Codable {
    let day, night, eve, morn: Double

    init(day: Double, night: Double, eve: Double, morn: Double) {
        self.day = day
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}

// MARK: - Temp
class Temp: NSObject, Codable {
    let day, min, max, night: Double
    let eve, morn: Double

    init(day: Double, min: Double, max: Double, night: Double, eve: Double, morn: Double) {
        self.day = day
        self.min = min
        self.max = max
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}

// MARK: - Hourly
class Hourly: NSObject, Codable {
    let dt: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherModel]
    let pop: Double
    let snow: Snow?
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case feelsLike
        case pressure
        case humidity
        case dewPoint
        case uvi
        case clouds
        case visibility
        case windSpeed
        case windDeg
        case weather
        case pop
        case snow
    }

    init(dt: Int, temp: Double, feelsLike: Double, pressure: Int, humidity: Int, dewPoint: Double, uvi: Double, clouds: Int, visibility: Int, windSpeed: Double, windDeg: Int, weather: [WeatherModel], pop: Double, snow: Snow?) {
        self.dt = dt
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.uvi = uvi
        self.clouds = clouds
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.weather = weather
        self.pop = pop
        self.snow = snow
    }
}

// MARK: - Snow
class Snow: NSObject, Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H
    }

    init(the1H: Double?) {
        self.the1H = the1H
    }
}
