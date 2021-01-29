//
//  CurrencyTest+CoreDataClass.swift
//  SobesApp
//
//  Created by Никита on 18.01.2021.
//
//

import Foundation
import CoreData

@objc(CurrencyTest)
public class CurrencyTest: NSManagedObject {
    
    class func addNew (saved: [Valute]){
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let entity = CurrencyTest(context: CoreDataManager.shared.persistentContainer.viewContext)
        for save in saved {
            let currency = NSEntityDescription.insertNewObject(forEntityName: "CurrencyTest", into: context)
            currency.setValue(save.Name, forKey: "name")
            currency.setValue(save.CharCode, forKey: "charCode")
            currency.setValue(save.ID, forKey: "id")
            currency.setValue(save.Nominal, forKey: "nominal")
            currency.setValue(save.NumCode, forKey: "numCode")
            currency.setValue(save.Previous, forKey: "previous")
            currency.setValue(save.Value, forKey: "value")
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
    }
    
    class func deleteAllData() {
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyTest")
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
