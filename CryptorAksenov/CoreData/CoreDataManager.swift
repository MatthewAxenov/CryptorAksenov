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
    let model: String = "CryptedStringsModel"
    
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
    
    public func saveCryptedString(cryptedString: String) {
        let context = persistentContainer.viewContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "CryptedStringsModel", into: context) as! CryptedStringsModel
        contact.stringValue = cryptedString
        
        do {
            try context.save()
            print("✅ String saved succesfuly")
            
        } catch let error {
            print("❌ Failed to write a string to coreData: \(error.localizedDescription)")
        }
    }
    
    public func fetch() -> [CryptedStringsModel] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CryptedStringsModel>(entityName: "CryptedStringsModel")
        
        do{
            let strings = try context.fetch(fetchRequest)
            for (index,string) in strings.enumerated() {
                print("String \(index): \(string.stringValue ?? "N/A")")
            }
            return strings
            
        }catch let fetchErr {
            print("❌ Failed to fetch strings:",fetchErr)
            return []
        }
    }
    
    public func deleteAll() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CryptedStringsModel>(entityName: "CryptedStringsModel")
        
        do {
            let strings = try context.fetch(fetchRequest)
            for string in strings {
                context.delete(string)
            }
            try context.save()
        } catch let fetchErr {
            print("❌ Failed to delete:",fetchErr)
        }
    }
}
