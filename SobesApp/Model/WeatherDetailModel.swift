//
//  WeatherDetail.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
//

import Foundation

struct WeatherDetailStruct: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    let alerts: [Alert]?
}

struct Alert: Codable {
    let senderName, event: String?
    let start, end: Int?
    let alertDescription: String?
}

struct Current: Codable {
    let dt, sunrise, sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds, visibility: Int
    let windSpeed, windDeg: Double
    let weather: [WeatherModel]
}

struct WeatherModel: Codable {
    let id: Int
    let main: String
    let weatherDescription: String?
    let icon: String
}

struct Daily: Codable {
    let dt, sunrise, sunset: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let weather: [WeatherModel]
    let clouds: Int
    let snow, rain: Double?
    let pop, uvi: Double
        
}

struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

struct Hourly: Codable {
    let dt: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherModel]
    let pop: Double
    let rain, snow: Rain?
}

struct Rain: Codable {
    let the1H: Double?
}
