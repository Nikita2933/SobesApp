//
//  CurrencyUserData+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 29.01.2021.
//
//

import Foundation
import CoreData


extension CurrencyUserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyUserData> {
        return NSFetchRequest<CurrencyUserData>(entityName: "CurrencyUserData")
    }

    @NSManaged public var labelName: String?
    @NSManaged public var currentValue: String?
    @NSManaged public var classField: String?
    @NSManaged public var curse: Double
    @NSManaged public var count: Int64

}

extension CurrencyUserData : Identifiable {

}
