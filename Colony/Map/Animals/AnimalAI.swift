//
//  AnimalAIProtocol.swift
//  Colony
//
//  Created by Michael Rommel on 08.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol AnimalAIProtocol {

    func update(for game: Game?)
}

class AnimalAI {

    // MARK: constants
    
    private static let kDISTURB_DURATION: Int = 2 // seconds
    
    // MARK: properties

    private let animal: Animal?
    private var game: Game? = nil
    private var stateMachine: AnimalStateMachine? = nil

    // MARK: general properties
    private var disturbTime: TimeInterval = 0.0
    private var path: HexPath? = nil

    // MARK: constructors

    init(animal: Animal?) {

        self.animal = animal

        self.stateMachine = AnimalStateMachine(ai: self)
        self.stateMachine?.push(state: .waitingForOrders)
    }

    // MARK: methods

    func doWaitOrders() {

        if let target = self.neighbor() {
        
            self.stateMachine?.popState()
            self.stateMachine?.push(state: .findPath, arg: target)
        }
    }

    func doFindPath(towards target: HexPoint) {

        guard let animalPosition = self.animal?.position else {
            fatalError("can't find position of animal")
        }

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = self.game?.pathfinderDataSource(for: self.animal, ignoreSight: true)

        if let path = pathFinder.shortestPath(fromTileCoord: animalPosition, toTileCoord: target) {

            self.path = path
            self.stateMachine?.popState()
            self.stateMachine?.push(state: .followPath)
        } else {
            // fallback
            self.stateMachine?.popState()
            self.stateMachine?.push(state: .wait, arg: AnimalAI.kDISTURB_DURATION)
        }
    }
    
    func doWait(for duration: TimeInterval) {

        if self.disturbTime == 0 {
            self.disturbTime = Date().timeIntervalSince1970
        } else if self.disturbTime + duration < Date().timeIntervalSince1970 {
            self.disturbTime = 0
            self.stateMachine?.popState()
        }
    }
    
    func doFollowPath() {

        if let path = self.path {
            self.animal?.gameObject?.showWalk(on: path, completion: {
                self.stateMachine?.popState()
            })
        }
    }
    
    // MARK: private methods

    private func neighbor() -> HexPoint? {

        guard let movementType = self.animal?.animalType.movementType else {
            fatalError("can't get movementType")
        }

        switch movementType {
        case .immobile:
            return nil
        case .swimOcean:
            return self.neighborOnOcean()
        case .walk:
            return self.neighborOnLand()
        }
    }

    private func neighborOnLand() -> HexPoint? {

        guard let game = self.game else {
            fatalError("can't get game")
        }

        guard let position = self.animal?.position else {
            fatalError("can't get position")
        }

        // find neighboring land tile
        let landNeighbors = game.neighborsOnLand(of: position)

        if landNeighbors.isEmpty {
            return nil
        }

        return landNeighbors.randomItem()
    }

    private func neighborOnOcean() -> HexPoint? {

        guard let game = self.game else {
            fatalError("can't get game")
        }

        guard let position = self.animal?.position else {
            fatalError("can't get position")
        }

        // find neighboring water tile
        let waterNeighbors = game.neighborsInWater(of: position)

        if waterNeighbors.isEmpty {
            return nil
        }

        return waterNeighbors.randomItem()
    }
}

extension AnimalAI: AnimalAIProtocol {

    func update(for game: Game?) {

        self.game = game
        self.stateMachine?.update()
    }
}
