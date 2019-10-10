//
//  Scripts.swift
//  Colony
//
//  Created by Michael Rommel on 08.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Scripts {
    
    static func addNumberOf(sharks: Int, in game: Game?) {
               
        guard let oceanTiles = game?.oceanTiles else {
            fatalError("can't get ocean tiles")
        }
        
        if oceanTiles.count < sharks {
            print("warning: not enough ocean for the number of sharks")
        }
        
        let sharkCount = min(oceanTiles.count, sharks)
        
        for _ in 0..<sharkCount {
            let oceanTile = oceanTiles.randomItem()
            
            if let point = oceanTile?.point {
                let shark = Shark(position: point)
                game?.add(animal: shark)
                //self.gameObjectManager.add(object: shark)
                //shark.idle()
            }
        }
    }
    
    static func addNumberOf(wulfs: Int, in game: Game?) {
        
        guard let forestTiles = game?.forestTiles else {
            fatalError("can't get forest tiles")
        }
        
        if forestTiles.count < wulfs {
            print("warning: not enough forest for the number of wulfs")
        }
        
        let wulfCount = min(forestTiles.count, wulfs)
        
        for _ in 0..<wulfCount {
            let forestTile = forestTiles.randomItem()
            
            if let point = forestTile?.point {
                let wulf = Wulf(position: point)
                game?.add(animal: wulf)
                //self.gameObjectManager.add(object: wulf)
                //wulf.idle()
            }
        }
    }
}
