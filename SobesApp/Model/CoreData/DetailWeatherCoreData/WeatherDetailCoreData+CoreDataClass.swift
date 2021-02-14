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

    class func addNew (saved: WeatherDetailClass) {
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let entity = WeatherDetailCoreData(context: CoreDataManager.shared.persistentContainer.viewContext)
        let weathers = NSEntityDescription.insertNewObject(forEntityName: "Weathers", into: context)
        
        
        let currents = saved.current
         
        
        entity.current?.dt = Double(currents.dt)
        let current = NSEntityDescription.insertNewObject(forEntityName: "CurrentCD", into: context)
        current.setValue(currents.feelsLike, forKey: "feelsLike")
        current.setValue(currents.dewPoint, forKey: "dewPoint")
        current.setValue(Double(currents.clouds), forKey: "clouds")
        current.setValue(Double(currents.humidity), forKey: "humidity")
        current.setValue(Double(currents.pressure), forKey: "pressure")
        current.setValue(Double(currents.sunrise), forKey: "sunrise")
        current.setValue(Double(currents.sunset), forKey: "sunset")
        current.setValue(currents.temp, forKey: "temp")
        current.setValue(currents.uvi, forKey: "uvi")
        current.setValue(Double(currents.visibility), forKey: "visibility")
        weathers.setValue(currents.weather[0].icon, forKey: "icon")
        weathers.setValue(currents.weather[0].weatherDescription, forKey: "descriptions")
        current.setValue(weathers, forKey: "weather")
        
        let hourly = saved.hourly //arr
        for hour in hourly {
            let current = NSEntityDescription.insertNewObject(forEntityName: "HourlyCD", into: context)
            let weathers = NSEntityDescription.insertNewObject(forEntityName: "Weathers", into: context)
            current.setValue(hour.dt, forKey: "dt")
            current.setValue(hour.temp, forKey: "temp")
            weathers.setValue(hour.weather[0].icon, forKey: "icon")
            current.setValue(weathers, forKey: "weather")
            //entity.addToHourly(weathers)
        }
        
        
        let daily = saved.daily //arr
        for day in daily {
            let current = NSEntityDescription.insertNewObject(forEntityName: "DailyCD", into: context)
            let weathers = NSEntityDescription.insertNewObject(forEntityName: "Weathers", into: context)
            let temp = NSEntityDescription.insertNewObject(forEntityName: "TempCD", into: context)
            
            current.setValue(day.dt, forKey: "dt")
            temp.setValue(day.temp.day, forKey: "day")
            temp.setValue(day.temp.night, forKey: "night")
            weathers.setValue(day.weather[0].icon, forKey: "icon")
            temp.setValue(weathers, forKey: "weather")
            
            current.setValue(temp, forKey: "temp")
        }
        
        
        entity.timeZoneOffSet = Int64(saved.timezoneOffset)
        
    }
    
}
