//
//  CurrencyCoreData+CoreDataClass.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
//
//

import Foundation
import CoreData

@objc(CurrencyCoreData)
public class CurrencyCoreData: NSManagedObject {
    
    class func addNew (saved: Currency) -> CurrencyCoreData {
        
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let entity = CurrencyCoreData(context: context)
        
        let valute = valuteArrConvert(sort: saved)
        
        for value in valute {
            let currency = NSEntityDescription.insertNewObject(forEntityName: "CurrencyCoreData", into: context)
            currency.setValue(value.Name, forKey: "name")
            currency.setValue(value.CharCode, forKey: "charCode")
            currency.setValue(value.ID, forKey: "id")
            currency.setValue(value.Nominal, forKey: "nominal")
            currency.setValue(value.NumCode, forKey: "numCode")
            currency.setValue(value.Previous, forKey: "previous")
            currency.setValue(value.Value, forKey: "value")
        }
        entity.name = "Российский Рубль"
        entity.charCode = "RUB"
        entity.id = "00"
        entity.nominal = 0
        entity.numCode = "643"
        entity.value = 1
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
        return entity
    }
    
    class func deleteAllData() { //MARK Update вместо delete
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyCoreData")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
}
