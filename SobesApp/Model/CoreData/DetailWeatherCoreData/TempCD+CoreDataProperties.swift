//
//  TempCD+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 14.02.2021.
//
//

import Foundation
import CoreData


extension TempCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TempCD> {
        return NSFetchRequest<TempCD>(entityName: "TempCD")
    }

    @NSManaged public var day: Double
    @NSManaged public var night: Double
    @NSManaged public var weather: Weathers?

}

extension TempCD : Identifiable {

}
