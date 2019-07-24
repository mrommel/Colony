//
//  ScoreDao.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

class ScoreDao: BaseDao {

    func fetch() -> [Score]? {

        guard let context = self.context else {
            fatalError("Can't get context for fetching score")
        }

        do {
            let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
            //fetch.predicate = NSPredicate(format: "genreValue == %@", genre)
            //fetchRequest.sortDescriptors
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }

    func get(by objectId: NSManagedObjectID) -> Score? {

        guard let context = self.context else {
            fatalError("Can't get context for getting score")
        }

        do {
            return try context.existingObject(with: objectId) as? Score
        } catch {
            return nil
        }
    }

    @discardableResult
    func create(with level: Int32, score: Int32, levelScore: String, user: User?) -> Score? {

        guard let context = self.context else {
            fatalError("Can't get context for creating score")
        }

        let newScore = Score(context: context)
        newScore.level = level
        newScore.date = Date()
        newScore.score = score
        newScore.levelScore = levelScore
        newScore.user = user

        do {
            try context.save()
            return self.get(by: newScore.objectID)
        } catch {
            return nil
        }
    }

    @discardableResult
    func save(score: Score?) -> Bool {

        guard let context = self.context else {
            fatalError("Can't get context for saving score")
        }

        guard let _ = score else {
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
    func delete(score: Score?) -> Bool {

        guard let context = self.context else {
            fatalError("Can't get context for deletion of Score")
        }

        guard let score = score else {
            fatalError("Can't delete nil user")
        }

        context.delete(score)

        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func deleteAll() -> Bool {

        if let entityName = Score.entity().name {
            return self.deleteAllData(of: entityName)
        }

        return false
    }
}
