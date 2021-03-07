//
//  MapModel+Tribes.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

extension MapModel {

    public func setupTribes(at points: [HexPoint]) {

        var tribeTypes = TribeType.all.shuffled.suffix(points.count)

        // place some tribes
        for point in points {
            let tribeItem = self.tribes[point.x, point.y]

            guard let selectedTribe = tribeTypes.first else {
                fatalError("cant get first tribe")
            }

            tribeTypes.removeFirst()

            if tribeItem?.items.count ?? 0 < tribeItem?.maxTribes ?? 0 {
                
                print("added tribe: \(selectedTribe) at \(point.x), \(point.y)")
                tribeItem?.items.append(TribeItem(type: selectedTribe))
                tribeItem?.inhabitants = 1000 // start with a thousand people
            }
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
        
        if let tribesItem = self.tribes[point.x, point.y] {
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
                if let tribesItem = self.tribes[x, y] {

                    if tribesItem.items.count > 0 {
                        
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

                        if let type = tribesItem.items.first?.type {
                            print("tribe at (\(x), \(y)): \(type.rawValue) - \(tribesItem.inhabitants) people - growthRate: \(growthRate), migratants: \(tmpMigratants) people")
                        }
                    }
                }
            }
        }
        
        // do migration
        for x in 0..<size.width() {
            for y in 0..<size.height() {
                if let tribesItem = self.tribes[x, y], let migratants = migrationArray[x, y] {
                    
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
                           let bestTribesItem = self.tribes[bestLocation.x, bestLocation.y] {
                            
                            bestTribesItem.inhabitants += migratants * 75 / 100
                            
                            if bestTribesItem.items.count == 0 {
                                if let mostRecentTribe = tribesItem.items.first {
                                    bestTribesItem.items.append(TribeItem(type: mostRecentTribe.type))
                                }
                            }
                        } else {
                            // hm, what happened to those people?
                        }
                        
                        if Float.random < 0.5 {
                            if let secondBestLocation = neighborPositions.chooseSecondBest(),
                               let secondBestTribesItem = self.tribes[secondBestLocation.x, secondBestLocation.y] {
                                
                                secondBestTribesItem.inhabitants += migratants * 25 / 100
                                
                                if secondBestTribesItem.items.count == 0 {
                                    if let mostRecentTribe = tribesItem.items.first {
                                        secondBestTribesItem.items.append(TribeItem(type: mostRecentTribe.type))
                                    }
                                }
                            }
                        } else {
                            // random tile
                            let positionWithFood = neighborPositions.filter({ $0.weight > 0 })
                            
                            if positionWithFood.count > 0 {
                                if let randomPosition = positionWithFood.chooseRandom(),
                                   let randomTribesItem = self.tribes[randomPosition.x, randomPosition.y] {
                                    
                                    randomTribesItem.inhabitants += migratants * 25 / 100
                                    
                                    if randomTribesItem.items.count == 0 {
                                        if let mostRecentTribe = tribesItem.items.first {
                                            randomTribesItem.items.append(TribeItem(type: mostRecentTribe.type))
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
                if let tribesItem = self.tribes[x, y] {
                    tribesItem.update()
                }
            }
        }
    }
}
