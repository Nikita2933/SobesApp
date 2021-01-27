//
//  CurrencyCoreData+CoreDataClass.swift
//  SobesApp
//
//  Created by Никита on 26.01.2021.
//
//

import Foundation
import CoreData

@objc(CurrencyCoreData)
public class CurrencyCoreData: NSManagedObject {

    class func addNew (charCode: String, class: CurrencyTest){
        let entity = CurrencyCoreData(context: CoreDataManager.shared.persistentContainer.viewContext)
       
    }
    
}
