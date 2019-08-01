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
    func battle(between: GameObject?, and target: GameObject?)
}

protocol GameObjectUnitDelegate {
    
    func selectedGameObjectChanged(to gameObject: GameObject?)
    func removed(gameObject: GameObject?)
}

protocol GameObservationDelegate {
    
    func updated()
    func coinConsumed()
    func boosterConsumed(type: BoosterType)
    func battle(between: GameObject?, and target: GameObject?)
}

class GameObjectManager: Codable {
    
    weak var map: HexagonTileMap?
    var userUsecase: UserUsecase?
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
        
        self.userUsecase = UserUsecase()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let objectsFromFile = try values.decode([GameObject?].self, forKey: .objects)
        
        self.objects = []
        for objectFromFile in objectsFromFile {

            if let type = objectFromFile?.type,
                let identifier = objectFromFile?.identifier,
                let position = objectFromFile?.position,
                let dict = objectFromFile?.dict {
                
                switch type {
                
                case .ship:
                    if let civilization = objectFromFile?.civilization {
                        self.objects.append(ShipObject(with: identifier, at: position, civilization: civilization))
                    }
                    break
                    
                case .axeman:
                    if let civilization = objectFromFile?.civilization {
                        self.objects.append(Axeman(with: identifier, at: position, civilization: civilization))
                    }
                    break
                    
                case .monster:
                    self.objects.append(Monster(with: identifier, at: position))
                    break
                    
                case .city:
                    if let civilization = objectFromFile?.civilization {

                        if let name = dict[GameObject.keyDictName] as? String {
                            self.map?.cities.append(City(named: name, at: position, civilization: civilization))
                            let city = CityObject(with: identifier, named: name, at: position, civilization: civilization)

                            self.objects.append(city)
                        }
                    }
                    break
                    
                case .coin:
                    self.objects.append(Coin(at: position))
                    break
                    
                case .pirates:
                    self.objects.append(Pirates(with: identifier, at: position))
                    break
                    
                case .tradeShip:
                    self.objects.append(TradeShip(with: identifier, at: position))
                    break
                    
                case .obstacle:
                    if identifier.starts(with: "shipwreck-") {
                        self.objects.append(ShipWreck(at: position))
                    } else if identifier.starts(with: "reef-") {
                        self.objects.append(Reef(at: position))
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
                    
                case .booster:
                    if identifier.starts(with: "booster-") {
                        let boosterType = dict[Booster.keyDictBoosterType]
                        // let booster = Booster(at: position, boosterType: boosterType)
                    } else {
                        fatalError("booster cannot be loaded")
                    }
                    break
                }
            }
        }
        
        self.userUsecase = UserUsecase()
    }

    // MARK: methods
    
    func add(object: GameObject?) {

        guard let object = object else {
            fatalError("Can't add nil object")
        }
        
        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        // only player unit update the fog
        if let civilization = object.civilization {
            if civilization == currentUserCivilization {
                self.map?.fogManager?.add(unit: object)
                
                if self.selected == nil {
                    self.selected = object
                }
            }
        }

        object.delegate = self
        self.objects.append(object)
        
        self.moved(object: object)
    }
    
    func remove(object: GameObject?) {
        if let objectIndex = self.objects.firstIndex(where: { $0?.identifier == object?.identifier }) {
            self.objects.remove(at: objectIndex)
            object?.removeFromParent()
        }
    }
    
    // MARK:
    
    func nextPlayerUnit() {
        
        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }
        
        let playerUnits = self.unitsOf(civilization: currentUserCivilization)
        
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
    
    func unitsOf(type: GameObjectType) -> [GameObject?] {
        
        return self.objects.filter { $0?.type == type }
    }

    func unitsOf(civilization: Civilization) -> [GameObject?] {

        return self.objects.filter { $0?.civilization == civilization }
    }
    
    func unitsExcept(civilization: Civilization) -> [GameObject?] {
        
        return self.objects.filter { $0?.civilization != civilization } // also nil
    }
    
    func units(at position: HexPoint) -> [GameObject?] {
    
        return self.objects.filter { $0?.position == position }
    }
    
    func obstacle(at position: HexPoint) -> Bool {
        
        let unitsAtPosition = self.units(at: position)
        
        for unit in unitsAtPosition {
            
            if unit?.type == .obstacle {
                return true
            }
        }
        
        return false
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
    
    // MARK: update methods
    
    func updatePlayer(object: GameObject) {
        
        guard let fogManager = self.map?.fogManager else {
            fatalError("no fogManager set")
        }
        
        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }
        
        // update fog for own units
        fogManager.update()
        
        // everyone except player
        for unit in self.unitsExcept(civilization: currentUserCivilization) {
            
            if let position = unit?.position, let type = unit?.type {
                
                if position == object.position && type == .coin {
                    
                    // consume coin
                    self.gameObservationDelegate?.coinConsumed()
                    
                    self.gameObjectUnitDelegates |> { delegate in
                        delegate.removed(gameObject: unit)
                    }
                    self.remove(object: unit)
                    continue
                }
                
                if position == object.position && type == .booster {
                    
                    guard let boosterObject = unit as? Booster else {
                        fatalError("error")
                        continue
                    }
                    
                    // consume coin
                    self.gameObservationDelegate?.boosterConsumed(type: boosterObject.boosterType)
                    
                    self.gameObjectUnitDelegates |> { delegate in
                        delegate.removed(gameObject: unit)
                    }
                    self.remove(object: unit)
                    continue
                }
                
                // show/hide enemies based on fog
                let fogAtEnemy = fogManager.fog(at: position)
                if fogAtEnemy == .sighted {
                    unit?.show()
                } else {
                    if unit?.type == .city && fogAtEnemy == .discovered {
                        unit?.show() // already discovered
                    } else {
                        unit?.hide()
                    }
                }
            }
        }
    }
    
    func updateForeign(object: GameObject) {
    
        guard let fogManager = self.map?.fogManager else {
            fatalError("no fogManager set")
        }
        
        let fogAtEnemy = fogManager.fog(at: object.position)
        if fogAtEnemy == .sighted {
            object.show()
        } else {
            if object.type == .city && fogAtEnemy == .discovered {
                object.show() // already discovered
            } else {
                object.hide()
            }
        }
    }
}

extension GameObjectManager: GameObjectDelegate {

    func moved(object: GameObject?) {

        guard let object = object else {
            fatalError("Can't add nil object")
        }
        
        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        if let civilization = object.civilization {
            if civilization == currentUserCivilization {
                self.updatePlayer(object: object)
            } else {
                self.updateForeign(object: object)
            }
        } else {
            self.updateForeign(object: object)
        }

        // check if won / lost the game
        self.checkGameConditions()
    }
    
    func battle(between source: GameObject?, and target: GameObject?) {
        
        self.gameObservationDelegate?.battle(between: source, and: target)
    }
}
