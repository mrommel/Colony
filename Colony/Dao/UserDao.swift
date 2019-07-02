//
//  UserDao.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

class UserDao: BaseDao {
    
    func fetch() -> [User]? {
        
        guard let context = self.context else {
            fatalError("Can't get context for fetching users")
        }
        
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            //fetch.predicate = NSPredicate(format: "genreValue == %@", genre)
            //fetchRequest.sortDescriptors
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    func get(by objectId: NSManagedObjectID) -> User? {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating user")
        }
        
        do {
            return try context.existingObject(with: objectId) as? User
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func create(named name: String, current: Bool) -> User? {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating user")
        }
        
        let newUser = User(context: context)
        newUser.name = name
        newUser.current = current
        
        do {
            try context.save()
            return self.get(by: newUser.objectID)
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func save(user: User?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion")
        }
        
        guard let _ = user else {
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
    func delete(user: User?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion")
        }
        
        guard let user = user else {
            fatalError("Can't delete nil user")
        }
        
        context.delete(user)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func deleteAll() -> Bool {
        
        if let entityName = User.entity().name {
            return self.deleteAllData(of: entityName)
        }
        
        return false
    }
}
