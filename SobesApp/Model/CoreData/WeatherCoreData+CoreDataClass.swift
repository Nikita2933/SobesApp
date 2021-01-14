//
//  WeatherCoreData+CoreDataClass.swift
//  SobesApp
//
//  Created by Никита on 12.01.2021.
//
//

import Foundation
import CoreData

@objc(WeatherCoreData)
public class WeatherCoreData: NSManagedObject {
    
    class func addNew (save: WeatherData) -> WeatherCoreData {
        let entity = WeatherCoreData(context: CoreDataManager.shared.persistentContainer.viewContext)
        entity.cityName = save.name
        entity.feels = save.main.feels_like
        entity.pressure = Int64(save.main.pressure)
        entity.temp = save.main.temp
        return entity
    }
    
}

