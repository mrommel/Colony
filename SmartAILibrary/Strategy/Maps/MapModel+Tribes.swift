//
//  MapModel+Tribes.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

enum FoodHarvestingType {
    
    case hunterGatherer
    case settled
    
    func peopleSupportedOn(terrain: TerrainType) -> Int {
        
        switch self {
        case .hunterGatherer:
            return self.peopleSupportedByHunterGatheringOn(terrain: terrain)
        case .settled:
            return self.peopleSupportedBySettledOn(terrain: terrain)
        }
    }
    
    func peopleBonusWith(feature: FeatureType) -> Int {
        
        switch self {
        case .hunterGatherer:
            return self.peopleBonusByHunterGatheringWith(feature: feature)
        case .settled:
            return self.peopleBonusBySettledWith(feature: feature)
        }
    }
    
    private func peopleSupportedByHunterGatheringOn(terrain: TerrainType) -> Int {
        
        switch terrain {
        
        case .grass:
            return 2500
        case .plains:
            return 2000
        case .desert:
            return 500
        case .tundra:
            return 1500
        case .snow:
            return 500
        case .shore:
            return 0
        case .ocean:
            return 0
        }
    }
    
    private func peopleSupportedBySettledOn(terrain: TerrainType) -> Int {
        
        switch terrain {
        
        case .grass:
            return 10000
        case .plains:
            return 5000
        case .desert:
            return 0
        case .tundra:
            return 2500
        case .snow:
            return 0
        case .shore:
            return 0
        case .ocean:
            return 0
        }
    }
    
    private func peopleBonusByHunterGatheringWith(feature: FeatureType) -> Int {
        
        switch feature {
        
        case .none:
            return 0
        case .forest:
            return 1000
        case .rainforest:
            return 700
        case .floodplains:
            return 200
        case .marsh:
            return 200
        case .oasis:
            return 1000
        case .reef:
            return 0
        case .ice:
            return 0
        case .atoll:
            return 0
        default:
            return 0
        }
    }
    
    private func peopleBonusBySettledWith(feature: FeatureType) -> Int {
        
        switch feature {
        
        case .none:
            return 0
        case .forest:
            return -500
        case .rainforest:
            return 700
        case .floodplains:
            return 200
        case .marsh:
            return 200
        case .oasis:
            return 1000
        case .reef:
            return 0
        case .ice:
            return 0
        case .atoll:
            return 0
        default:
            return 0
        }
    }
}

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
    
    private func peopleSupported(by foodHarvestingType: FoodHarvestingType, at point: HexPoint) -> Int {
        
        if !self.valid(point: point) {
            return 0
        }
        
        let terrain = self.terrain(at: point)
        let feature = self.feature(at: point)
        let river = self.river(at: point)
        
        let terrainValue = foodHarvestingType.peopleSupportedOn(terrain: terrain)
        let featureValue = foodHarvestingType.peopleBonusWith(feature: feature)
        let riverValue = river ? 1000 : 0
        
        return max(terrainValue + featureValue + riverValue, 0)
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
                        
                        for neighbor in HexPoint(x: x, y: y).neighbors() {
                            let supported = self.peopleSupported(by: foodHarvestingType, at: neighbor)
                            
                            neighborPositions.add(weight: supported, for: neighbor)
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
                        }
                        
                        if let secondBestLocation = neighborPositions.chooseSecondBest(),
                           let secondBestTribesItem = self.tribes[secondBestLocation.x, secondBestLocation.y] {
                            
                            secondBestTribesItem.inhabitants += migratants * 25 / 100
                            
                            if secondBestTribesItem.items.count == 0 {
                                if let mostRecentTribe = tribesItem.items.first {
                                    secondBestTribesItem.items.append(TribeItem(type: mostRecentTribe.type))
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
