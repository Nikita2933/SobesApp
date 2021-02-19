//
//  CurrencyUserData+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
//
//

import Foundation
import CoreData


extension CurrencyUserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyUserData> {
        return NSFetchRequest<CurrencyUserData>(entityName: "CurrencyUserData")
    }

    @NSManaged public var classField: String?
    @NSManaged public var count: Int64
    @NSManaged public var currentValue: String?
    @NSManaged public var curse: Double
    @NSManaged public var labelName: String?
    @NSManaged public var tag: Int16

}

extension CurrencyUserData : Identifiable {

}
