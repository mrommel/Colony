//
//  RegionFinder.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class RegionFinder {
    
    weak var map: MapModel?
    var evaluator: SiteEvaluator?
    var player: AbstractPlayer?
    
    init(map: MapModel?, evaluator: SiteEvaluator?, for player: AbstractPlayer?) {
        
        self.map = map
        self.evaluator = evaluator
        self.player = player
    }
    
    func divideInto(regions: Int) -> [HexArea] {
        
        var areas: [HexArea] = []
        
        // fill from continents
        guard let continents = self.map?.continents else {
            fatalError("no continents found")
        }
        
        guard let evaluator = self.evaluator else {
            fatalError("no evaluator provided")
        }
        
        for continent in continents {
            let area = HexArea(points: continent.points)
            
            // skip small islands
            if area.size < 6 { // FIXME: move to constants
                continue
            }
            
            let value = evaluator.value(of: area, for: self.player)
            
            if value == 0.0 {
                continue
            }
            
            area.set(value: value)
            areas.append(area)
        }
        
        assert(areas.count >= continents.count, "no valid areas in map -> map invalid")
        
        if areas.count > 0 {
            while areas.count < regions {
                
                // order smallest value first
                areas.sort(by: { $0.getValue() < $1.getValue() })
                
                guard let lastArea = areas.popLast() else {
                    fatalError("something wierd happend")
                }
                
                let (firstArea, secondArea) = self.divide(area: lastArea)
                
                areas.append(firstArea)
                areas.append(secondArea)
            }
        }
        
        return areas
    }
    
    func findBestPosition(in area: HexArea) -> HexPoint {
        
        guard area.size > 0 else {
            fatalError("can't find position in empty area")
        }
        
        guard let evaluator = self.evaluator else {
            fatalError("no evaluator")
        }
        
        var selectedPoint = area.points.first!
        var selectedValue = Double.leastNormalMagnitude
        
        for point in area {
            let value = evaluator.value(of: point, for: self.player)
            
            if value > selectedValue {
                selectedPoint = point
                selectedValue = value
            }
        }
        
        return selectedPoint
    }
    
    // MARK: private methods
    
    private func divide(area: HexArea) -> (HexArea, HexArea) {
        
        if area.width > area.height {
            return self.divideHorizontally(area: area)
        } else {
            return self.divideVertically(area: area)
        }
    }
    
    func divideHorizontally(area: HexArea) -> (HexArea, HexArea) {
        
        guard let evaluator = self.evaluator else {
            fatalError("no evaluator")
        }
        
        let minX = area.boundingBox.minX + 1
        let maxX = area.boundingBox.maxX
        
        let targetValue = area.getValue() / 2
        var dx = (minX + maxX) / 2
        
        while dx > minX && dx < maxX {
            
            // evaluation run
            let (firstArea, secondArea) = area.divideHorizontally(at: dx)
            
            let firstValue = evaluator.value(of: firstArea, for: self.player)
            firstArea.set(value: firstValue)
            
            if firstArea.getValue() < (targetValue * 9 / 10) {
                dx += 1
            } else if firstArea.getValue() > (targetValue * 11 / 10) {
                dx -= 1
            } else {
                return (firstArea, secondArea)
            }
        }
        
        fatalError("can't find split")
    }
    
    func divideVertically(area: HexArea) -> (HexArea, HexArea) {
        
        guard let evaluator = self.evaluator else {
            fatalError("no evaluator")
        }
        
        let minY = area.boundingBox.minY + 1
        let maxY = area.boundingBox.maxY
        
        let targetValue = area.getValue() / 2
        var dy = (minY + maxY) / 2
        
        while dy > minY && dy < maxY {
            
            // evaluation run
            let (firstArea, secondArea) = area.divideVertically(at: dy)
            
            let firstValue = evaluator.value(of: firstArea, for: self.player)
            firstArea.set(value: firstValue)
            
            if firstArea.getValue() < (targetValue * 9 / 10) {
                dy += 1
            } else if firstArea.getValue() > (targetValue * 11 / 10) {
                dy -= 1
            } else {
                return (firstArea, secondArea)
            }
        }
        
        fatalError("can't find split")
    }
}
