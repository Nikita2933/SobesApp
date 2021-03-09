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
        entity.temp = save.main.temp
        entity.imageWeather = save.weather.first!.icon
        entity.imageLabel = save.weather.first!.main
        entity.time = Int64(save.timezone)
        
        entity.lat = save.coord.lat!
        entity.lon = save.coord.lon!
        
        entity.date = Date()
        return entity
    }
    
    class func addNewDetailWeather(detailWeather: WeatherDetailCoreData, cityName: String){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<WeatherCoreData> = WeatherCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "cityName = %@", cityName)
        let currentWeather = try? context.fetch(request)
        
        currentWeather!.first!.weatherDetail = detailWeather
    }
    
    class func updateData( result: @escaping (Result<(), Error>) -> ()) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<WeatherCoreData> = WeatherCoreData.fetchRequest()
        for weathers in weatherData {
            request.predicate = NSPredicate(format: "cityName = %@", weathers.cityName!)
            let curWeather = try? context.fetch(request)
            if curWeather != nil {
                for weather in curWeather! {
                    Network.shared.getWeather(city: weather.cityName!, units: .met) { (results) in
                        switch results {
                        case .success(let secondWeather):
                            weather.imageLabel = secondWeather.weather.first!.main
                            weather.temp = secondWeather.main.temp
                            weather.imageWeather = secondWeather.weather.first!.icon
                            CoreDataManager.shared.saveContext()
                            result(.success(()))
                        case .failure(let error):
                            result(.failure(error))
                        }
                    }
                }
            }
        }
    }
}
