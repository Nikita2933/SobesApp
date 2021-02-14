//
//  DailyCD+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 14.02.2021.
//
//

import Foundation
import CoreData


extension DailyCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyCD> {
        return NSFetchRequest<DailyCD>(entityName: "DailyCD")
    }

    @NSManaged public var dt: Double
    @NSManaged public var temp: TempCD?

}

extension DailyCD : Identifiable {

}
