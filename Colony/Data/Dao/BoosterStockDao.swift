//
//  BoosterStockDao.swift
//  Colony
//
//  Created by Michael Rommel on 31.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

class BoosterStockDao: BaseDao {
    
    func fetch() -> [BoosterStockEntity]? {
        
        guard let context = self.context else {
            fatalError("Can't get context for fetching users")
        }
        
        do {
            let fetchRequest: NSFetchRequest<BoosterStockEntity> = BoosterStockEntity.fetchRequest()
            //fetch.predicate = NSPredicate(format: "genreValue == %@", genre)
            //fetchRequest.sortDescriptors
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    func get(by objectId: NSManagedObjectID) -> BoosterStockEntity? {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating user")
        }
        
        do {
            return try context.existingObject(with: objectId) as? BoosterStockEntity
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func create(boosterType: BoosterType, amount: Int, user: UserEntity?) -> BoosterStockEntity? {
        
        guard let context = self.context else {
            fatalError("Can't get context for booster stock")
        }
        
        let newBoosterStock = BoosterStockEntity(context: context)
        newBoosterStock.boosterType = boosterType.rawValue
        newBoosterStock.amount = Int32(amount)
        newBoosterStock.user = user
        
        do {
            try context.save()
            return self.get(by: newBoosterStock.objectID)
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func save(boosterStock: BoosterStockEntity?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion")
        }
        
        guard let _ = boosterStock else {
            fatalError("Can't save nil user")
        }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func delete(boosterStock: BoosterStockEntity?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion")
        }
        
        guard let boosterStock = boosterStock else {
            fatalError("Can't delete nil user")
        }
        
        context.delete(boosterStock)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func deleteAll() -> Bool {
        
        if let entityName = BoosterStockEntity.entity().name {
            return self.deleteAllData(of: entityName)
        }
        
        return false
    }
}
