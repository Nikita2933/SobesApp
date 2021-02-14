//
//  CurrentCD+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 14.02.2021.
//
//

import Foundation
import CoreData


extension CurrentCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentCD> {
        return NSFetchRequest<CurrentCD>(entityName: "CurrentCD")
    }

    @NSManaged public var clouds: Double
    @NSManaged public var dewPoint: Double
    @NSManaged public var dt: Double
    @NSManaged public var feelsLike: Double
    @NSManaged public var humidity: Double
    @NSManaged public var pressure: Double
    @NSManaged public var sunrise: Double
    @NSManaged public var sunset: Double
    @NSManaged public var temp: Double
    @NSManaged public var uvi: Double
    @NSManaged public var visibility: Double
    @NSManaged public var windDeg: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var weather: Weathers?

}

extension CurrentCD : Identifiable {

}
