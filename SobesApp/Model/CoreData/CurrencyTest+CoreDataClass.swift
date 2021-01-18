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
        
        for save in saved {
            let test = NSEntityDescription.insertNewObject(forEntityName: "CurrencyTest", into: context)
            test.setValue(save.Name, forKey: "name")
            test.setValue(save.CharCode, forKey: "charCode")
            test.setValue(save.ID, forKey: "id")
            test.setValue(save.Nominal, forKey: "nominal")
            test.setValue(save.NumCode, forKey: "numCode")
            test.setValue(save.Previous, forKey: "previous")
            test.setValue(save.Value, forKey: "value")
        }
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
        do
        {
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
