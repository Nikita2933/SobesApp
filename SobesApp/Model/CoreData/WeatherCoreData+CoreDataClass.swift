//
//  WeatherCoreData+CoreDataClass.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
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
            entity.imageWeather = save.weather.first!.icon
            entity.imageLabel = save.weather.first!.main
            
            entity.lat = save.coord.lat!
            entity.lon = save.coord.lon!
            return entity
        }

        class func reloadData(result: () -> ()) {
           let context = CoreDataManager.shared.persistentContainer.viewContext
           let request: NSFetchRequest<WeatherCoreData> = WeatherCoreData.fetchRequest()
           let curWeather = try? context.fetch(request)
           if curWeather != nil {
               for oneWeather in curWeather! {
                    context.delete(oneWeather)
                    Network.shared.getWeather(city: oneWeather.cityName!, units: .met) { (_) in
                    }
               }
           }
        }
    
}
