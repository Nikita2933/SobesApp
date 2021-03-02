//
//  CurrencyFirstData+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 02.03.2021.
//
//

import Foundation
import CoreData


extension CurrencyFirstData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyFirstData> {
        return NSFetchRequest<CurrencyFirstData>(entityName: "CurrencyFirstData")
    }

    @NSManaged public var date: String?
    @NSManaged public var arrValue: NSSet?

}

// MARK: Generated accessors for arrValue
extension CurrencyFirstData {

    @objc(addArrValueObject:)
    @NSManaged public func addToArrValue(_ value: CurrencyCoreData)

    @objc(removeArrValueObject:)
    @NSManaged public func removeFromArrValue(_ value: CurrencyCoreData)

    @objc(addArrValue:)
    @NSManaged public func addToArrValue(_ values: NSSet)

    @objc(removeArrValue:)
    @NSManaged public func removeFromArrValue(_ values: NSSet)

}

extension CurrencyFirstData : Identifiable {

}
