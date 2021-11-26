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

        // place some tribes
        for startLocation in startLocations {
            let tribeTile = self.tribeTiles[startLocation.point.x, startLocation.point.y]
            let selectedCivilizationType = startLocation.leader.civilization()

            print("added tribe: \(selectedCivilizationType) at \(startLocation.point.x), \(startLocation.point.y)")
            tribeTile?.setup(with: selectedCivilizationType)

            self.tribes.append(TribeInfo(type: selectedCivilizationType))

            if let tribe = self.tribes.first(where: { $0.type == selectedCivilizationType }) {
                tribe.add(point: startLocation.point)
                tribe.capital = startLocation.point
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

        if let tribesItem = self.tribeTiles[point.x, point.y] {
            return tribesItem.inhabitants
        }

        return 0
    }

    fileprivate func calculateGrowth(_ foodHarvestingType: FoodHarvestingType, _ x: Int, _ y: Int, _ tribesItem: TribeTileInfo, _ migrationRate: Float, _ migrationArray: Array2D<Int>, _ civilizationType: CivilizationType) {
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

        print("tribe at (\(x), \(y)): \(civilizationType.rawValue) - " +
              "\(tribesItem.inhabitants) people - growthRate: \(growthRate), migratants: \(tmpMigratants) people")
    }

    fileprivate func setupNewTile(at position: HexPoint, for civilizationType: CivilizationType, with people: Int) {

        if let tribesItem = self.tribeTiles[position] {

            tribesItem.setup(with: civilizationType)
            tribesItem.inhabitants = people

            if let tribe = self.tribes.first(where: { $0.type == civilizationType }) {
                tribe.add(point: position)
            }
        }
    }

    public var allPoints: [HexPoint] {

        var points: [HexPoint] = []

        for x in 0..<size.width() {
            for y in 0..<size.height() {

                points.append(HexPoint(x: x, y: y))
            }
        }

        return points
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

                if let tribesItem = self.tribeTiles[x, y], let civilizationType = tribesItem.civilizationType {
                    calculateGrowth(foodHarvestingType, x, y, tribesItem, migrationRate, migrationArray, civilizationType)
                }
            }
        }

        // do migration
        for point in self.allPoints {
            if let tribesItem = self.tribeTiles[point],
                let civilizationType = tribesItem.civilizationType,
                let migratants = migrationArray[point] {

                // when we have people who are willing to leave ...
                if migratants > 0 {

                    // if the tribes ruling system does not support more tiles, stop here
                    if let tribe = self.tribes.first(where: { $0.type == civilizationType }) {

                        let maxTiles = 16
                        if tribe.numberOfTiles() > maxTiles {
                            tribe.emigrants += migratants
                            continue
                        }
                    }

                    // find neighbors
                    // @TODO: if sailing is invented - some random far away lands
                    let neighborPositions: WeightedList<HexPoint> = WeightedList<HexPoint>()

                    for var neighbor in point.neighbors() {

                        // wrap neighbor if needed
                        neighbor = self.wrap(point: neighbor)

                        let supported = self.peopleSupported(by: foodHarvestingType, at: neighbor)

                        // make sure the neighbors are on the map
                        if !self.valid(point: neighbor) {
                            continue
                        }

                        // if the tribes ruling system does not support a larger distance to the capital, skip this tile
                        if let tribe = self.tribes.first(where: { $0.type == civilizationType }) {

                            let maxDistance = 8
                            if tribe.capital.distance(to: neighbor) > maxDistance {
                                continue
                            }
                        }

                        neighborPositions.add(weight: supported, for: neighbor)
                    }

                    if let bestLocation = neighborPositions.chooseLargest(),
                       let bestTribesItem = self.tribeTiles[bestLocation] {

                        if bestTribesItem.civilizationType == nil {
                            self.setupNewTile(at: bestLocation, for: civilizationType, with: migratants * 66 / 100)
                        } else {
                            bestTribesItem.inhabitants += migratants * 66 / 100
                        }
                    } else {
                        // if we don't have any valid spot
                        if let tribe = self.tribes.first(where: { $0.type == civilizationType }) {
                            tribe.emigrants += migratants
                        }
                    }

                    if Float.random < 0.5 {
                        if let secondBestLocation = neighborPositions.chooseSecondLargest(),
                           let secondBestTribesItem = self.tribeTiles[secondBestLocation] {

                            if secondBestTribesItem.civilizationType == nil {
                                self.setupNewTile(at: secondBestLocation, for: civilizationType, with: migratants * 34 / 100)
                            } else {
                                secondBestTribesItem.inhabitants += migratants * 34 / 100
                            }
                        }
                    } else {
                        // random tile
                        let positionWithFood = neighborPositions.filter(
                            where: { (_, value) in
                                value > 0.0
                            }
                        )

                        if !positionWithFood.isEmpty {
                            if let randomPosition = positionWithFood.chooseRandom(),
                               let randomTribesItem = self.tribeTiles[randomPosition] {

                                if randomTribesItem.civilizationType == nil {
                                    self.setupNewTile(at: randomPosition, for: civilizationType, with: migratants * 34 / 100)
                                } else {
                                    randomTribesItem.inhabitants += migratants * 34 / 100
                                }
                            }
                        }
                    }
                }
            }
        }

        // create some events
        for tribe in self.tribes {

            if Int.random(minimum: 0, maximum: 100) < 2 {
                print("-- event: find new capital")

                let tilesWithPopulation: WeightedPoints = WeightedPoints()

                for pt in tribe.area.points {
                    guard let bestTribesItem = self.tribeTiles[pt] else {
                        continue
                    }

                    tilesWithPopulation.add(weight: bestTribesItem.inhabitants, for: pt)
                }

                if let newCapitalLocation = tilesWithPopulation.chooseLargest() {

                    if tribe.capital != newCapitalLocation {
                        print("-- event: found new capital for \(tribe.type) at \(newCapitalLocation)")
                        tribe.capital = newCapitalLocation
                    }
                }
            }

            if Int.random(minimum: 0, maximum: 100) < 3 {
                print("-- event: abandon least populated tile")

                // make sure we have more than
                if tribe.numberOfTiles() > 2 {

                    let tilesWithPopulation: WeightedPoints = WeightedPoints()

                    for pt in tribe.area.points {
                        guard let bestTribesItem = self.tribeTiles[pt] else {
                            continue
                        }

                        tilesWithPopulation.add(weight: bestTribesItem.inhabitants, for: pt)
                    }

                    if let leastPopulatedLocation = tilesWithPopulation.chooseLargest() {

                        if let tribesItem = self.tribeTiles[leastPopulatedLocation] {
                            tribesItem.inhabitants = 0
                            tribesItem.civilizationType = nil
                        }

                        tribe.remove(point: leastPopulatedLocation)

                        print("-- event: abandoned tile at \(leastPopulatedLocation) of \(tribe.type)")
                    }
                }
            }

            // spawn a new tribe
            if tribe.emigrants > 2500 {
                print("-- event: enough emigrants to spawn a new tribe")

                if self.tribes.count > 8 {
                    // not more than 8 civs
                    // TODO: make dynamic
                    continue
                }

                var allCivilizationTypes = CivilizationType.all
                let usedCivilizationTypes: [CivilizationType] = self.tribes.map({ $0.type })

                for usedCivilizationType in usedCivilizationTypes {
                    allCivilizationTypes.removeAll(where: { $0 == usedCivilizationType })
                }

                let civilizationTypeToSpawn = allCivilizationTypes.randomItem()

                let tilesToSpawn: WeightedPoints = WeightedPoints()

                for dir in HexDirection.all {
                    var locationToSpawn = tribe.capital.neighbor(in: dir, and: 10)

                    // wrap neighbor if needed
                    locationToSpawn = self.wrap(point: locationToSpawn)

                    if !self.valid(point: locationToSpawn) {
                        continue
                    }

                    // sum of tiles in area of 3 diameter
                    let possibleArea = locationToSpawn.areaWith(radius: 3)
                    var areaInhabitants = 0
                    var areaSupported = 0
                    for possibleAreaPoint in possibleArea {
                        if self.valid(point: possibleAreaPoint) {
                            if let tribesItem = self.tribeTiles[possibleAreaPoint] {
                                areaInhabitants += tribesItem.inhabitants
                            }
                        }

                        areaSupported += self.peopleSupported(by: .hunterGatherer, at: possibleAreaPoint)
                    }

                    // we only consider this area, when there is enough space
                    if areaInhabitants > 0 {
                        continue
                    }

                    // verify that a path can be found
                    let pathfinder = AStarPathfinder()
                    pathfinder.dataSource = MoveTypeIgnoreUnitsPathfinderDataSource(
                        in: self,
                        for: .walk,
                        for: nil,
                        options: MoveTypeIgnoreUnitsOptions(unitMapType: .civilian, canEmbark: false)
                    )

                    if !pathfinder.doesPathExist(fromTileCoord: tribe.capital, toTileCoord: locationToSpawn) {
                        continue
                    }

                    // only add tile if it supports food
                    // no oceans or mountains are added
                    if areaSupported > 8000 {
                        tilesToSpawn.add(weight: areaSupported, for: locationToSpawn)
                    }
                }

                if let bestTileToSpawn = tilesToSpawn.chooseFromTopChoices() {

                    let newTribe = TribeInfo(type: civilizationTypeToSpawn)
                    newTribe.capital = bestTileToSpawn
                    self.tribes.append(newTribe)

                    self.setupNewTile(at: bestTileToSpawn, for: civilizationTypeToSpawn, with: tribe.emigrants)

                    tribe.emigrants = 0
                }
            }
        }

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
