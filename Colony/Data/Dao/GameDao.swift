//
//  GameDao.swift
//  Colony
//
//  Created by Michael Rommel on 28.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

class GameDao: BaseDao {
    
    func fetch() -> [GameEntity]? {
        
        guard let context = self.context else {
            fatalError("Can't get context for fetching from game table")
        }
        
        do {
            let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
            //fetch.predicate = NSPredicate(format: "genreValue == %@", genre)
            //fetchRequest.sortDescriptors
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    func get(by objectId: NSManagedObjectID) -> GameEntity? {
        
        guard let context = self.context else {
            fatalError("Can't get context for getting score")
        }
        
        do {
            return try context.existingObject(with: objectId) as? GameEntity
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func create(data: Data, user: UserEntity?) -> GameEntity? {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating score")
        }
        
        let newGame = GameEntity(context: context)
        newGame.data = data
        newGame.date = Date()
        newGame.user = user
        
        do {
            try context.save()
            return self.get(by: newGame.objectID)
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func save(game: GameEntity?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for saving game")
        }
        
        guard let _ = game else {
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
    func delete(game: GameEntity?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion of game")
        }
        
        guard let game = game else {
            fatalError("Can't delete nil user")
        }
        
        context.delete(game)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func deleteAll() -> Bool {
        
        if let entityName = GameEntity.entity().name {
            return self.deleteAllData(of: entityName)
        }
        
        return false
    }
}
