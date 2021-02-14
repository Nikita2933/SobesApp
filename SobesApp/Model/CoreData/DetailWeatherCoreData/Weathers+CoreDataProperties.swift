//
//  Weathers+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 14.02.2021.
//
//

import Foundation
import CoreData


extension Weathers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weathers> {
        return NSFetchRequest<Weathers>(entityName: "Weathers")
    }

    @NSManaged public var descriptions: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: Double

}

extension Weathers : Identifiable {

}
