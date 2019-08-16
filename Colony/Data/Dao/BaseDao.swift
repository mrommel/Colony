//
//  BaseDao.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

class BaseDao {
    
    var context: NSManagedObjectContext? {
        get {
            return CoreDataManager.shared.persistentContainer.viewContext
        }
    }
    
    func deleteAllData(of entity: String) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion of all \(entity)")
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                context.delete(objectData)
            }
            try context.save()
            return true
        } catch let error {
            print("Detele all data in \(entity) error :", error)
            return false
        }
    }
}
