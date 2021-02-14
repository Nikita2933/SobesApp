//
//  WeatherDetailCoreData+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 14.02.2021.
//
//

import Foundation
import CoreData


extension WeatherDetailCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDetailCoreData> {
        return NSFetchRequest<WeatherDetailCoreData>(entityName: "WeatherDetailCoreData")
    }

    @NSManaged public var timeZoneOffSet: Int64
    @NSManaged public var current: CurrentCD?
    @NSManaged public var daily: NSSet?
    @NSManaged public var hourly: NSSet?

}

// MARK: Generated accessors for daily
extension WeatherDetailCoreData {

    @objc(addDailyObject:)
    @NSManaged public func addToDaily(_ value: HourlyCD)

    @objc(removeDailyObject:)
    @NSManaged public func removeFromDaily(_ value: HourlyCD)

    @objc(addDaily:)
    @NSManaged public func addToDaily(_ values: NSSet)

    @objc(removeDaily:)
    @NSManaged public func removeFromDaily(_ values: NSSet)

}

// MARK: Generated accessors for hourly
extension WeatherDetailCoreData {

    @objc(addHourlyObject:)
    @NSManaged public func addToHourly(_ value: HourlyCD)

    @objc(removeHourlyObject:)
    @NSManaged public func removeFromHourly(_ value: HourlyCD)

    @objc(addHourly:)
    @NSManaged public func addToHourly(_ values: NSSet)

    @objc(removeHourly:)
    @NSManaged public func removeFromHourly(_ values: NSSet)

}

extension WeatherDetailCoreData : Identifiable {

}
