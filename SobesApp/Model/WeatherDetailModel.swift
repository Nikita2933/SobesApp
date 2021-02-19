//
//  WeatherDetail.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
//

import Foundation
    

class WeatherDetailClass: Codable {
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
class Alert: Codable {
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
struct Current: Codable {
    let dt, sunrise, sunset: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed, windDeg: Double
    let weather: [WeatherModel]
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
class Daily: Codable {
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
class FeelsLike: Codable {
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
class Hourly: Codable {
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
class Snow: Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H
    }

    init(the1H: Double?) {
        self.the1H = the1H
    }
}
