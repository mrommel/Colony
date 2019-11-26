//
//  Animal.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Animal: Decodable /*, AIHandable*/ {
    
    // MARK: properties
    
    var position: HexPoint
    let animalType: AnimalType
    
    // MARK: UI connection
    
    var gameObject: GameObject? = nil
    
    // MARK: coding keys
    
    enum CodingKeys: String, CodingKey {

        case position
        case animalType
    }
    
    // MARK: constructor
    
    init(position: HexPoint, animalType: AnimalType) {
        
        self.position = position
        self.animalType = animalType
    }
    
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.position = try values.decode(HexPoint.self, forKey: .position)
        self.animalType = try values.decode(AnimalType.self, forKey: .animalType)
    }
    
    // MARK: unit methods
    
    func createGameObject() -> GameObject? {
        
        fatalError("must be overwritten by sub class")
    }
    
    func tilesInSight() -> HexArea {

        return HexArea(center: self.position, radius: 1)
    }
    
    func stepOnWater(towards point: HexPoint, in game: Game?) {

        guard let waterNeighbors = game?.neighborsInWater(of: point) else {
            return
        }

        var bestWaterNeighbor = waterNeighbors.first!
        var bestDistance: Int = Int.max

        for waterNeighbor in waterNeighbors {
            let neighborDistance = waterNeighbor.distance(to: point) + Int.random(number: 1)
            if neighborDistance < bestDistance {
                bestWaterNeighbor = waterNeighbor
                bestDistance = neighborDistance
            }
        }

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = game?.pathfinderDataSource(for: self.animalType.movementType, civilization: .pirates, ignoreSight: true) // FIXME: animal has no civ

        if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) {
            self.gameObject?.showWalk(on: path, completion: {
                self.gameObject?.showIdle()
            })
        }
    }
    
    func update(in game: Game?) {

    }
}

extension Animal: Encodable {
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.position, forKey: .position)
        try container.encode(self.animalType, forKey: .animalType)
    }
}
