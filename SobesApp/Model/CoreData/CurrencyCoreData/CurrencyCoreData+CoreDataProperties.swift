//
//  CurrencyCoreData+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
//
//

import Foundation
import CoreData


extension CurrencyCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyCoreData> {
        return NSFetchRequest<CurrencyCoreData>(entityName: "CurrencyCoreData")
    }

    @NSManaged public var charCode: String
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var nominal: Int64
    @NSManaged public var numCode: String
    @NSManaged public var previous: Double
    @NSManaged public var value: Double
    @NSManaged public var previosTime: String

}

extension CurrencyCoreData : Identifiable {

}
