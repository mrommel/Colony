//
//  CreateGameMenuViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import Foundation
import SmartAssets
import Cocoa
import SmartAILibrary

struct LeaderData {
    let name: String
    let image: NSImage
}

class CreateGameMenuViewModel: ObservableObject {
    
    func leaderImage(for leaderType: LeaderType) -> NSImage {
        
        let targetSize = NSSize(width: 16, height: 16)
        let bundle = Bundle.init(for: Textures.self)
        
        return (bundle.image(forResource: leaderType.textureName())?.resize(withSize: targetSize))!
    }
    
    var leaders: [LeaderData] {
        
        var array: [LeaderData] = []
        
        for leader in LeaderType.all {
            array.append(LeaderData(name: leader.name(), image: self.leaderImage(for: leader)))
        }
        /*array.append(LeaderData(name: "Random Leader",
                                image: ))
        
        
        array.append(LeaderData(name: "Alexander", image: bundle.image(forResource: "leader-alexander")!))
        array.append(LeaderData(name: "Augustus", image: bundle.image(forResource: "leader-augustus")!))
        array.append(LeaderData(name: "Barbarossa", image: bundle.image(forResource: "leader-barbarossa")!))*/
        
        return array
    }
}
