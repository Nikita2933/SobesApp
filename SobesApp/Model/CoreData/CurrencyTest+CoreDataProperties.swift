//
//  CurrencyTest+CoreDataProperties.swift
//  SobesApp
//
//  Created by Никита on 18.01.2021.
//
//

import Foundation
import CoreData


extension CurrencyTest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyTest> {
        return NSFetchRequest<CurrencyTest>(entityName: "CurrencyTest")
    }

    @NSManaged public var charCode: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var nominal: Int64
    @NSManaged public var numCode: String?
    @NSManaged public var previous: Double
    @NSManaged public var value: Double

}

extension CurrencyTest : Identifiable {

}
