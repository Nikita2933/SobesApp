//
//  WeatherCoreData+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 03.02.2021.
//
//

import Foundation
import CoreData


extension WeatherCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherCoreData> {
        return NSFetchRequest<WeatherCoreData>(entityName: "WeatherCoreData")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var feels: Double
    @NSManaged public var imageLabel: String?
    @NSManaged public var imageWeather: String?
    @NSManaged public var pressure: Int64
    @NSManaged public var temp: Double
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

}

extension WeatherCoreData : Identifiable {

}
