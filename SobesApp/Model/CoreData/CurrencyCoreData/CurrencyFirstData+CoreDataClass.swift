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
    
    class func refreshCurrency(save: Currency, reload: () -> ()) {
        
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let currencyFirst = CurrencyFirstData(context: context)
        CurrencyCoreData.deleteAllData()
        
        var valute: [Valute] = []
        let keys = save.Valute.keys.sorted()
        for key in keys {
            if let val = save.Valute[key] {
                valute.append(val)
            }
        }
        
        currencyFirst.date = save.Date
        
        let currencyArr = CurrencyCoreData.addNew(saved: valute)
        currencyFirst.addToArrValue(currencyArr)
        reload()
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
}
