//
//  RegionFinder.swift
//  Colony
//
//  Created by Michael Rommel on 15.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class RegionFinder {
    
    weak var map: HexagonTileMap?
    var evaluator: SiteEvaluator?
    
    init(map: HexagonTileMap?, evaluator: SiteEvaluator?) {
        self.map = map
        self.evaluator = evaluator
    }
    
    func divideInto(regions: Int) -> [HexArea] {
        
        var areas: [HexArea] = []
        
        // fill from continents
        guard let continents = self.map?.continents else {
            return []
        }
        
        guard let evaluator = self.evaluator else {
            return []
        }
        
        for continent in continents {
            let area = HexArea(points: continent.points)
            
            // skip small islands
            if area.size < 6 { // FIXME: move to constants
                continue
            }
            
            let value = evaluator.value(of: area, by: .player)
            
            if value == 0 {
                continue
            }
            
            area.set(value: value)
            areas.append(area)
        }
        
        assert(areas.count > 0, "no valid areas in map -> map invalid")
        
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
        
        return areas
    }
    
    func findStartPosition(in area: HexArea) -> HexPoint {
        
        guard area.size > 0 else {
            fatalError("can't find position in empty area")
        }
        
        guard let evaluator = self.evaluator else {
            fatalError("no evaluator")
        }
        
        var selectedPoint = area.points.first!
        var selectedValue = -1
        
        for point in area {
            let value = evaluator.value(of: point, by: .player)
            
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
        
        for dx in minX..<maxX {
            
            let (firstArea, secondArea) = area.divideHorizontally(at: dx)
            
            let firstValue = evaluator.value(of: firstArea, by: .player)
            firstArea.set(value: firstValue)
            
            let secondValue = evaluator.value(of: secondArea, by: .player)
            secondArea.set(value: secondValue)
            
            if firstValue > secondValue {
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
        
        for dy in minY...maxY {
            
            let (firstArea, secondArea) = area.divideVertically(at: dy)
            
            let firstValue = evaluator.value(of: firstArea, by: .player)
            firstArea.set(value: firstValue)
            
            let secondValue = evaluator.value(of: secondArea, by: .player)
            secondArea.set(value: secondValue)
            
            if firstValue > secondValue {
                return (firstArea, secondArea)
            }
        }
        
        fatalError("can't find split")
    }
}
