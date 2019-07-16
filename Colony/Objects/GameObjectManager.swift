//
//  GameObjectManager.swift
//  Colony
//
//  Created by Michael Rommel on 07.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameObjectDelegate {

    func moved(object: GameObject?)
}

protocol GameObjectUnitDelegate {
    
    func selectedGameObjectChanged(to gameObject: GameObject?)
    func removed(gameObject: GameObject?)
}

protocol GameObservationDelegate {
    
    func updated()
    func coinConsumed()
}

class GameObjectManager: Codable {

    let alphaVisible: CGFloat = 1.0
    let alphaInvisible: CGFloat = 0.0 
    
    weak var map: HexagonTileMap?
    var objects: [GameObject?]
    var selected: GameObject? {
        didSet {
            self.gameObjectUnitDelegates |> { delegate in
                delegate.selectedGameObjectChanged(to: selected)
            }
        }
    }

    var gameObjectUnitDelegates = MulticastDelegate<GameObjectUnitDelegate>()
    var gameObservationDelegate: GameObservationDelegate?

    enum CodingKeys: String, CodingKey {
        case objects
    }
    
    // MARK: constructors

    init(on map: HexagonTileMap?) {
        self.objects = []
        self.map = map
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let objectsFromFile = try values.decode([GameObject?].self, forKey: .objects)
        
        self.objects = []
        for objectFromFile in objectsFromFile {

            if let type = objectFromFile?.type,
                let identifier = objectFromFile?.identifier,
                let position = objectFromFile?.position,
                let tribe = objectFromFile?.tribe {
                
                switch type {
                
                case .ship:
                    self.objects.append(ShipObject(with: identifier, at: position, tribe: tribe))
                    break
                case .axeman:
                    self.objects.append(Axeman(with: identifier, at: position, tribe: tribe))
                    break
                    
                case .monster:
                    self.objects.append(Monster(with: identifier, at: position))
                    break
                case .city:
                    self.objects.append(CityObject(with: identifier, at: position, tribe: tribe))
                    break
                case .coin:
                    self.objects.append(Coin(at: position))
                    break
                case .pirates:
                    self.objects.append(Pirates(with: identifier, at: position))
                    break
                    
                case .obstacle:
                    if identifier.starts(with: "shipwreck-") {
                        self.objects.append(ShipWreck(at: position))
                    } else {
                        fatalError("obstacle cannot be loaded")
                    }
                    break
                case .animal:
                    if identifier.starts(with: "shark-") {
                        self.objects.append(Shark(at: position))
                    } else {
                        fatalError("animal cannot be loaded")
                    }
                    break
                }
            }
        }
    }

    // MARK: methods
    
    func add(object: GameObject?) {

        guard let object = object else {
            fatalError("Can't add nil object")
        }

        // only player unit update the fog
        if object.tribe == .player {
            self.map?.fogManager?.add(unit: object)
            
            if self.selected == nil {
                self.selected = object
            }
        }

        object.delegate = self
        self.objects.append(object)
        
        self.moved(object: object)
    }
    
    func remove(object: GameObject?) {
        if let objectIndex = self.objects.firstIndex(where: { $0?.identifier == object?.identifier }) {
            self.objects.remove(at: objectIndex)
            print("remove object")
        }
    }
    
    // MARK:
    
    func nextPlayerUnit() {
        
        let playerUnits = self.unitsOf(tribe: .player)
        
        guard playerUnits.count > 1 else {
            return
        }
        
        guard let currentIndex = playerUnits.firstIndex(where: { $0?.identifier == selected?.identifier }) else {
            fatalError("selected no in player units")
        }
        
        let nextIndex = (currentIndex + 1 ) % playerUnits.count
        
        self.selected = playerUnits[nextIndex]
    }
    
    func centerOnPlayerUnit() {
        
        // focus on unit
        self.gameObjectUnitDelegates |> { delegate in
            delegate.selectedGameObjectChanged(to: selected)
        }
    }
    
    func unitBy(identifier: String) -> GameObject? {
        
        if let object = self.objects.first(where: { $0?.identifier == identifier }) {
            return object
        }
        
        return nil
    }

    func unitsOf(tribe: GameObjectTribe) -> [GameObject?] {

        return self.objects.filter { $0?.tribe == tribe }
    }
    
    func unitsOf(tribes: [GameObjectTribe]) -> [GameObject?] {
        
        return self.objects.filter { tribes.contains($0!.tribe) }
    }
    
    func checkGameConditions() {
        
        self.gameObservationDelegate?.updated()
    }
    
    func setup() {
        
        for object in self.objects {
            object?.setup()
        }
    }
    
    func update(in game: Game?) {
        
        for object in self.objects {
            object?.update(in: game)
        }
    }
    
    func dismiss() {
        
        for object in self.objects {
            object?.dismiss()
        }
    }
}

extension GameObjectManager: GameObjectDelegate {

    func moved(object: GameObject?) {

        guard let object = object else {
            fatalError("Can't add nil object")
        }

        guard let fogManager = self.map?.fogManager else {
            fatalError("no fogManager set")
        }

        if object.tribe == .player {
            // update fog for own units
            fogManager.update()

            // everyone except player
            for unit in self.unitsOf(tribes: [.enemy, .neutral, .reward, .decoration]) {
                
                if let position = unit?.position, let tribe = unit?.tribe {
                    
                    if position == object.position && tribe == .reward {
                        
                        // consume reward
                        self.gameObservationDelegate?.coinConsumed()
                        
                        self.gameObjectUnitDelegates |> { delegate in
                            delegate.removed(gameObject: unit)
                        }
                        self.remove(object: unit)
                        continue
                    }
                    
                    // show/hide enemies based on fog
                    let fogAtEnemy = fogManager.fog(at: position)
                    if fogAtEnemy == .sighted {
                        unit?.sprite.alpha = self.alphaVisible
                    } else {
                        unit?.sprite.alpha = self.alphaInvisible
                    }
                }
            }

        } else if object.tribe == .enemy || object.tribe == .reward || object.tribe == .neutral {

            let fogAtEnemy = fogManager.fog(at: object.position)
            if fogAtEnemy == .sighted {
                object.sprite.alpha = self.alphaVisible
            } else {
                object.sprite.alpha = self.alphaInvisible
            }
        }

        // check if won / lost the game
        self.checkGameConditions()
    }
}
