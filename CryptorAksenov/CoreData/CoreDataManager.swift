//
//  CoreDataManager.swift
//  CryptorAksenov
//
//  Created by Матвей on 19.10.2023.
//

import Foundation
import CoreData

public class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    let identifier: String = "Matthew.CryptorAksenov"
    let model: String = "CryptedDataModel"
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let messageKitBundle = Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error{
                fatalError("❌ Loading of store failed:\(err)")
            }
        }
        return container
    }()
    
    public func saveCryptedString(cryptedString: Data) {
        let context = persistentContainer.viewContext
        let dataItem = NSEntityDescription.insertNewObject(forEntityName: "CryptedDataModel", into: context) as! CryptedDataModel
        dataItem.cryptedData = cryptedString
        
        do {
            try context.save()
            print("✅ Saved succesfuly")
            
        } catch let error {
            print("❌ Failed to write to coreData: \(error.localizedDescription)")
        }
    }
    
    public func fetch() -> [CryptedDataModel] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CryptedDataModel>(entityName: "CryptedDataModel")
        
        do {
            let stringsData = try context.fetch(fetchRequest)
            return stringsData
            
        } catch let fetchErr {
            print("❌ Failed to fetch stringsData:",fetchErr)
            return []
        }
    }
    
    public func deleteAll() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CryptedDataModel>(entityName: "CryptedDataModel")
        
        do {
            let stringsData = try context.fetch(fetchRequest)
            for stringData in stringsData {
                context.delete(stringData)
            }
            try context.save()
        } catch let fetchErr {
            print("❌ Failed to delete:",fetchErr)
        }
    }
}
