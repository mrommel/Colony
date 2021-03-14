//
//  MapModel+Tribes.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

extension MapModel {

    public func setupTribes(at startLocations: [StartLocation]) {

        // var tribeTypes = TribeType.all.shuffled.suffix(points.count)

        // place some tribes
        for startLocation in startLocations {
            let tribeTile = self.tribeTiles[startLocation.point.x, startLocation.point.y]
            let selectedCivilization = startLocation.leader.civilization()
            
            print("added tribe: \(selectedCivilization) at \(startLocation.point.x), \(startLocation.point.y)")
            tribeTile?.setup(with: selectedCivilization)
            
            self.tribes.append(TribeInfo(type: selectedCivilization))
        }
    }
    
    public func peopleSupported(by foodHarvestingType: FoodHarvestingType, at point: HexPoint) -> Int {
        
        guard self.valid(point: point) else {
            return 0
        }
        
        guard let tile = self.tile(at: point) else {
            return 0
        }
        
        let terrain = tile.terrain()
        let feature = tile.feature()
        let river = tile.isRiver()
        let hills = tile.hasHills()
        
        let terrainValue = foodHarvestingType.peopleSupportedOn(terrain: terrain)
        let featureValue = foodHarvestingType.peopleBonusWith(feature: feature)
        let riverValue = river ? 1000 : 0
        let hillsValue = hills ? -100 : 0
        
        return max(terrainValue + featureValue + riverValue + hillsValue, 0)
    }
    
    public func inhabitants(at point: HexPoint) -> Int {
        
        if let tribesItem = self.tribeTiles[point.x, point.y] {
            return tribesItem.inhabitants
        }
        
        return 0
    }

    public func updateTribes() {
        
        print("------------------------------")
        
        let foodHarvestingType: FoodHarvestingType = .hunterGatherer
        let migrationRate: Float = 0.02 // 2% of the people move to neighboring tiles
        let migrationArray: Array2D<Int> = Array2D<Int>(size: self.size)
        migrationArray.fill(with: 0)

        // growth
        for x in 0..<size.width() {
            for y in 0..<size.height() {
                if let tribesItem = self.tribeTiles[x, y] {

                    if let civilizationType = tribesItem.type {
                        
                        // growth
                        let supportedPeople = self.peopleSupported(by: foodHarvestingType, at: HexPoint(x: x, y: y))
                        var growthRate: Float = 0.0
                        
                        let supportRatio = Float(supportedPeople) / Float(tribesItem.inhabitants)
                        
                        if supportRatio > 1.2 {
                            growthRate = 1.05
                        } else if supportRatio > 1.1 {
                            growthRate = 1.02
                        } else if supportRatio > 1.0 {
                            growthRate = 1.01
                        } else if supportRatio > 0.9 {
                            growthRate = 0.98
                        } else {
                            growthRate = 0.93
                        }
                        
                        let growthRange = Range<Float>(uncheckedBounds: (lower: (growthRate - 0.05), upper: (growthRate + 0.05)))
                        growthRate = Float.random(in: growthRange)
                        
                        let tmpInhabitants = Int(growthRate * Float(tribesItem.inhabitants))
                        let tmpMigratants = Int(Float(tmpInhabitants) * migrationRate)
                        migrationArray[x, y] = tmpMigratants
                        
                        tribesItem.inhabitants = tmpInhabitants - tmpMigratants

                        print("tribe at (\(x), \(y)): \(civilizationType.rawValue) - \(tribesItem.inhabitants) people - growthRate: \(growthRate), migratants: \(tmpMigratants) people")
                    }
                }
            }
        }
        
        // do migration
        for x in 0..<size.width() {
            for y in 0..<size.height() {
                if let tribesItem = self.tribeTiles[x, y],
                   let civilizationType = tribesItem.type,
                   let migratants = migrationArray[x, y] {
                    
                    // when we have people who are willing to leave ...
                    if migratants > 0 {
                        // find neighbors
                        // @TODO: if sailing is invented - some random far away lands
                        let neighborPositions: WeightedList<HexPoint> = WeightedList<HexPoint>()
                        
                        for var neighbor in HexPoint(x: x, y: y).neighbors() {
                            
                            // wrap if needed
                            neighbor = self.wrap(point: neighbor)
                            
                            let supported = self.peopleSupported(by: foodHarvestingType, at: neighbor)
                            
                            // make sure the neighbors are on the map
                            if self.valid(point: neighbor) {
                                neighborPositions.add(weight: supported, for: neighbor)
                            }
                        }
                        
                        neighborPositions.sort()
                        
                        if let bestLocation = neighborPositions.chooseBest(),
                           let bestTribesItem = self.tribeTiles[bestLocation] {
                            
                            bestTribesItem.inhabitants += migratants * 66 / 100
                            
                            if bestTribesItem.type == nil {
                                bestTribesItem.setup(with: civilizationType)
                                
                                if let tribe = self.tribes.first(where: { $0.type == civilizationType }) {
                                    tribe.area.add(point: bestLocation)
                                }
                            }
                        } else {
                            // hm, what happened to those people?
                        }
                        
                        if Float.random < 0.5 {
                            if let secondBestLocation = neighborPositions.chooseSecondBest(),
                               let secondBestTribesItem = self.tribeTiles[secondBestLocation] {
                                
                                secondBestTribesItem.inhabitants += migratants * 34 / 100
                                
                                if secondBestTribesItem.type == nil {
                                    secondBestTribesItem.setup(with: civilizationType)
                                    
                                    if let tribe = self.tribes.first(where: { $0.type == civilizationType }) {
                                        tribe.area.add(point: secondBestLocation)
                                    }
                                }
                            }
                        } else {
                            // random tile
                            let positionWithFood = neighborPositions.filter({ $0.weight > 0 })
                            
                            if positionWithFood.count > 0 {
                                if let randomPosition = positionWithFood.chooseRandom(),
                                   let randomTribesItem = self.tribeTiles[randomPosition] {
                                    
                                    randomTribesItem.inhabitants += migratants * 34 / 100
                                    
                                    if randomTribesItem.type == nil {
                                        randomTribesItem.setup(with: civilizationType)
                                        
                                        if let tribe = self.tribes.first(where: { $0.type == civilizationType }) {
                                            tribe.area.add(point: randomPosition)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // merge tribes to main tribe (if any)
        
        // finalize
        for x in 0..<size.width() {
            for y in 0..<size.height() {
                if let tribesItem = self.tribeTiles[x, y] {
                    tribesItem.update()
                }
            }
        }
    }
}
