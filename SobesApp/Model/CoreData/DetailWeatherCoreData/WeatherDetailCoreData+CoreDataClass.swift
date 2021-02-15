//
//  WeatherDetailCoreData+CoreDataClass.swift
//  SobesApp
//
//  Created by Никита on 14.02.2021.
//
//

import Foundation
import CoreData

@objc(WeatherDetailCoreData)
public class WeatherDetailCoreData: NSManagedObject {

    class func addNew (saved: WeatherDetailClass) -> WeatherDetailCoreData {
        
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let entity = WeatherDetailCoreData(context: context)
        let entityCurrentCD = CurrentCD(context: context)
        let entityWeatherCD = Weathers(context: context)
        
        let currents = saved.current
        
        entityCurrentCD.dt = Double(currents.dt)
        entityCurrentCD.feelsLike = currents.feelsLike
        entityCurrentCD.dewPoint = currents.dewPoint
        entityCurrentCD.clouds = Double(currents.clouds)
        entityCurrentCD.humidity = Double(currents.humidity)
        entityCurrentCD.pressure = Double(currents.pressure)
        entityCurrentCD.sunrise = Double(currents.sunrise)
        entityCurrentCD.sunset = Double(currents.sunset)
        entityCurrentCD.temp = currents.temp
        entityCurrentCD.uvi = currents.uvi
        entityCurrentCD.visibility = Double(currents.visibility)
        entityCurrentCD.windDeg = Double(currents.windDeg)
        entityCurrentCD.windSpeed = Double(currents.windSpeed)
        entityWeatherCD.icon = currents.weather[0].icon
        entityWeatherCD.descriptions = currents.weather[0].descriptions
        
        entityCurrentCD.weather = entityWeatherCD
        
        entity.current = entityCurrentCD
        
        let hourly = saved.hourly //arr
        for hour in hourly {
            let current = NSEntityDescription.insertNewObject(forEntityName: "HourlyCD", into: context)
            let weathers = NSEntityDescription.insertNewObject(forEntityName: "Weathers", into: context)
            current.setValue(hour.dt, forKey: "dt")
            current.setValue(hour.temp, forKey: "temp")
            weathers.setValue(hour.weather[0].icon, forKey: "icon")
            
            current.setValue(weathers, forKey: "weather")
            entity.addToHourly(current as! HourlyCD)
        }
        
        let daily = saved.daily //arr
        for day in daily {
            let current = NSEntityDescription.insertNewObject(forEntityName: "DailyCD", into: context)
            let weathers = NSEntityDescription.insertNewObject(forEntityName: "Weathers", into: context)
            let temp = NSEntityDescription.insertNewObject(forEntityName: "TempCD", into: context)
            
            current.setValue(day.dt, forKey: "dt")
            temp.setValue(day.temp.day, forKey: "day")
            temp.setValue(day.temp.night, forKey: "night")
            temp.setValue(day.temp.max, forKey: "max")
            temp.setValue(day.temp.min, forKey: "min")
            weathers.setValue(day.weather[0].icon, forKey: "icon")
            
            temp.setValue(weathers, forKey: "weather")
            
            current.setValue(temp, forKey: "temp")
            entity.addToDaily(current as! DailyCD)
        }
        
        entity.timeZoneOffSet = Int64(saved.timezoneOffset)
        
        return entity
    }
    
}
