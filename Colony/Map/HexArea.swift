//
//  HexArea.swift
//  Colony
//
//  Created by Michael Rommel on 03.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class HexArea {
    
    let points: [HexPoint]
    
    init(center: HexPoint, radius: Int) {
        
        var tmp = Set([center])
        
        for _ in 0..<radius {
            
            var newTmp = Set<HexPoint>()
            for elem in tmp {
                newTmp = newTmp.union(elem.neighbors())
            }
            tmp = tmp.union(newTmp)
        }
        
        self.points = Array(tmp)
    }
}
