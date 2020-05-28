//
//  GameSceneMenu.swift
//  SmartColony
//
//  Created by Michael Rommel on 27.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

extension GameScene {
    
    fileprivate func gamesFolder() -> URL {
        
        let fm = FileManager.default
        let folder = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]

        var isDirectory: ObjCBool = false
        if !(fm.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            try! fm.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
        }
        return folder
    }
    
    func handleGameSave() {
    
        guard let game = self.viewModel?.game else {
            fatalError("no game to save")
        }
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(game)
            let string = String(data: data, encoding: .utf8)!
        
            let filename = gamesFolder().appendingPathComponent("current.game")
        
            try string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            print("Saved!")
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func handleGameLoad() {
    
        let decoder = JSONDecoder()
        
        do {
            let filename = gamesFolder().appendingPathComponent("current.game")
            let jsonData = try Data(contentsOf: filename, options: .mappedIfSafe)
        
            let tmpGame = try decoder.decode(GameModel.self, from: jsonData)
            print("Loaded!")
        } catch {
            print("Failed to load: \(error)")
        }
    }
    
    func handleGameRetire() {
        
        print("Retire")
    }
    
    func handleGameRestart() {
        
        print("Restart")
    }
    
    func handleGameExit() {
        
        print("Exit")
    }
}
