//
//  CurrencyUserData+CoreDataClass.swift
//  SobesApp
//
//  Created by Никита on 29.01.2021.
//
//

import Foundation
import CoreData

@objc(CurrencyUserData)
public class CurrencyUserData: NSManagedObject {

    class func addNew (arrData: [CustomViewCurrency]){
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        for save in arrData {
            let currencyData = NSEntityDescription.insertNewObject(forEntityName: "CurrencyUserData", into: context)
            currencyData.setValue(save.classField.text, forKey: "classField")
            currencyData.setValue(save.currentValue.titleLabel?.text, forKey: "currentValue")
            currencyData.setValue(save.curse, forKey: "curse")
            currencyData.setValue(save.labelName.text, forKey: "labelName")
            currencyData.setValue(save.count, forKey: "count")
            currencyData.setValue(save.currentValue.tag, forKey: "tag")
        }
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    class func getArrData () -> [CustomViewCurrency] {
        let request: NSFetchRequest<CurrencyUserData> = CurrencyUserData.fetchRequest()
        let currencyData = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
        var arrView: [CustomViewCurrency] = []
        
        if currencyData != nil {
            for currency in currencyData! {
                let view = CustomViewCurrency()
                view.classField.text = currency.classField
                view.currentValue.setTitle(currency.currentValue, for: .normal)
                view.curse = currency.curse
                view.labelName.text = currency.labelName
                arrView.append(view)
            }
        }
        return arrView.sorted(by: {$0.currentValue.tag < $1.currentValue.tag })
    }
    
    class func deleteData() {
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyUserData")
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
