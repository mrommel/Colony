//
//  GameStorage.swift
//  SmartColony
//
//  Created by Michael Rommel on 31.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class GameStorage {
    
    static fileprivate func gamesFolder() -> URL {
        
        let fm = FileManager.default
        let folder = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]

        var isDirectory: ObjCBool = false
        if !(fm.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            try! fm.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
        }
        return folder
    }
    
    static func listGames() -> [String] {
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: gamesFolder(), includingPropertiesForKeys: nil)
            print(directoryContents)

            // filter the directory contents for games
            let gameFiles = directoryContents.filter{ $0.pathExtension == "game" }
            print("game urls: \(gameFiles)")
            
            // only the file name
            let gameFileNames = gameFiles.map{ $0.lastPathComponent }
            print("game list: \(gameFileNames)")
            
            return gameFileNames
            
        } catch {
            print("Failed to load directory: \(error)")
            return []
        }
    }
    
    static func hasGame(named name: String) -> Bool {
        
        return listGames().contains(name)
    }
    
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
            print("Saved!")
            return true
        } catch {
            print("Failed to save: \(error)")
            return false
        }
    }
    
    static func loadGame(named name: String) -> GameModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let filename = gamesFolder().appendingPathComponent(name)
            let jsonData = try Data(contentsOf: filename, options: .mappedIfSafe)
        
            let tmpGame = try decoder.decode(GameModel.self, from: jsonData)
            print("Loaded!")
            return tmpGame
        } catch {
            print("Failed to load: \(error)")
            return nil
        }
    }
}
