//
//  CurrencyCoreData+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 26.01.2021.
//
//

import Foundation
import CoreData


extension CurrencyCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyCoreData> {
        return NSFetchRequest<CurrencyCoreData>(entityName: "CurrencyCoreData")
    }

    @NSManaged public var charCode: String?
    @NSManaged public var currency: CurrencyTest?

}

extension CurrencyCoreData : Identifiable {

}
