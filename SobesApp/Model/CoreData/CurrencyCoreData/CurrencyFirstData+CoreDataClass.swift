//
//  CurrencyFirstData+CoreDataClass.swift
//  SobesApp
//
//  Created by Никита on 02.03.2021.
//
//

import Foundation
import CoreData

@objc(CurrencyFirstData)
public class CurrencyFirstData: NSManagedObject {
    
    class func newCurrency(save: Currency) -> CurrencyFirstData {
        CurrencyCoreData.deleteAllData()
        deleteAllCurrency()
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let currencyFirst = CurrencyFirstData(context: context)
        
        let df = DateFormatter()
        df.dateFormat = "MM-dd HH:mm"
        let time = df.string(from: Date())
        currencyFirst.date = time
        
        let currencyArr = CurrencyCoreData.addNew(saved: save)
        currencyFirst.addToArrValue(currencyArr)
        
        return currencyFirst
    }

    class func getCurrency () -> CurrencyFirstData? {
        let request: NSFetchRequest<CurrencyFirstData> = CurrencyFirstData.fetchRequest()
        let currency = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
        
        if let result = currency?.first {
            return result
        } else {
            return nil
        }
    }
    
    class func deleteAllCurrency() {
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyFirstData")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let currentCDArr = try context.fetch(fetchRequest)
            for current in currentCDArr
            {
                let managedObjectData:NSManagedObject = current as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print(error)
        }
    }
}

