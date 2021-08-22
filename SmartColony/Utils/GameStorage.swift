//
//  GameStorage.swift
//  SmartColony
//
//  Created by Michael Rommel on 31.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class GameStorage {

    static fileprivate let kCurrentGame = "current.game"
    static fileprivate let kRestartGame = "restart.game"

    static fileprivate func gamesFolder() -> URL {

        let fileManager = FileManager.default
        let folder = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        var isDirectory: ObjCBool = false
        if !(fileManager.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            do {
                try fileManager.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
            } catch { }
        }

        return folder
    }

    static func listGames() -> [String] {

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: gamesFolder(), includingPropertiesForKeys: nil)
            // print(directoryContents)

            // filter the directory contents for games
            let gameFiles = directoryContents.filter { $0.pathExtension == "game" }
            // print("game urls: \(gameFiles)")

            // only the file name
            var gameFileNames = gameFiles.map { $0.lastPathComponent }
            // print("game list: \(gameFileNames)")

            // remove the default files
            gameFileNames.removeAll(where: { $0 == kCurrentGame })
            gameFileNames.removeAll(where: { $0 == kRestartGame })
            
            return gameFileNames

        } catch {
            print("Failed to load directory: \(error)")
            return []
        }
    }

    static func hasGame(named name: String) -> Bool {

        return listGames().contains(name)
    }
    
    static func hasCurrentGame() -> Bool {
        
        return self.hasGame(named: kCurrentGame)
    }
    
    static func hasRestartGame() -> Bool {
        
        return self.hasGame(named: kRestartGame)
    }

    @discardableResult
    static func store(game: GameModel?, named name: String) -> Bool {

        guard let game = game else {
            fatalError("no game to save")
        }

        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(game)
            let string = String(data: data, encoding: .utf8)!

            let filename = gamesFolder().appendingPathComponent(name)

            try string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            print("Saved game as \(name)!")
            return true
        } catch {
            print("Failed to save game as \(name): \(error)")
            return false
        }
    }

    @discardableResult
    static func storeCurrent(game: GameModel?) -> Bool {

        self.store(game: game, named: kCurrentGame)
    }

    @discardableResult
    static func storeRestart(game: GameModel?) -> Bool {

        self.store(game: game, named: kRestartGame)
    }

    static func loadGame(named name: String) -> GameModel? {

        let decoder = JSONDecoder()

        do {
            let filename = gamesFolder().appendingPathComponent(name)
            let jsonData = try Data(contentsOf: filename, options: .mappedIfSafe)

            let tmpGame = try decoder.decode(GameModel.self, from: jsonData)
            print("Loaded game from \(name)!")
            return tmpGame
        } catch {
            print("Failed to load game from \(name): \(error)")
            return nil
        }
    }

    static func loadCurrentGame() -> GameModel? {

        return self.loadGame(named: kCurrentGame)
    }

    static func loadRestartGame() -> GameModel? {

        return self.loadGame(named: kRestartGame)
    }

    @discardableResult
    static func removeGame(named name: String) -> Bool {

        let filename = gamesFolder().appendingPathComponent(name)
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: filename)
            print("Deleted game named \(name)!")
            return true
        } catch {
            print("Failed to delete game named \(name): \(error)")
            return false
        }
    }
    
    @discardableResult
    static func removeCurrentGame() -> Bool {
        
        return self.removeGame(named: kCurrentGame)
    }
    
    @discardableResult
    static func removeRestartGame() -> Bool {
        
        return self.removeGame(named: kRestartGame)
    }
}
