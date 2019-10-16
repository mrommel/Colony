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

    func moved(unit: Unit?)

    func battle(between: Unit?, and target: Unit?) // unit is attacker
    func ambushed(_ target: Unit?, by attacker: Unit?) // passive
    func killed(unit: Unit?)
}

protocol GameObjectUnitDelegate {

    func selectedUnitChanged(to unit: Unit?)
    func removed(unit: Unit?)
}

protocol GameObservationDelegate {

    func updated()
    func coinConsumed()
    func boosterConsumed(type: BoosterType)

    func battle(between: Unit?, and target: Unit?)
}

class GameObjectManager {

    weak var map: HexagonTileMap?
    var userUsecase: UserUsecase?
    var objects: [GameObject?]
    var selected: Unit? {
        didSet {
            self.gameObjectUnitDelegates |> { delegate in
                delegate.selectedUnitChanged(to: selected)
            }
        }
    }

    var gameObjectUnitDelegates = MulticastDelegate<GameObjectUnitDelegate>()
    var gameObservationDelegate: GameObservationDelegate?
    var node: SKNode? = nil

    // MARK: constructors

    init(on map: HexagonTileMap?) {
        self.objects = []
        self.map = map

        self.userUsecase = UserUsecase()

        // create from map objects
        self.setupUnits()
        self.setupCities()
    }

    func setupUnits() {

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        for unit in self.map?.units ?? [] {

            let gameObject = unit.createGameObject()
            gameObject?.delegate = self
            self.objects.append(gameObject)

            // only player unit update the fog
            if unit.civilization == currentUserCivilization {
                // FIXME: add to correct 
                self.map?.fogManager?.add(unit: gameObject!)

                if self.selected == nil {
                    self.selected = unit
                }
            }

            self.moved(unit: unit)
        }
    }

    func setupCities() {

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        guard let cities = self.map?.getCities() else {
            fatalError("Can't get all cities")
        }
        
        for city in cities {

            if city.gameObject != nil {
                continue
            }
            
            let gameObject = city.createGameObject()
            gameObject?.delegate = self
            self.objects.append(gameObject)

            // only player unit update the fog
            if city.civilization == currentUserCivilization {
                self.map?.fogManager?.add(city: gameObject!)
            }
        }
    }

    func remove(city: City?) {

        if let objectIndex = self.objects.firstIndex(where: { $0 == city?.gameObject }) {
            self.objects.remove(at: objectIndex)
            city?.gameObject?.removeFromParent()
        }
    }
    
    func remove(unit: Unit?) {
        fatalError("FIXME")
        /*if let objectIndex = self.objects.firstIndex(where: { $0?.identifier == object?.identifier }) {
            self.objects.remove(at: objectIndex)
            object?.removeFromParent()
        }*/
    }

    // MARK:

    func nextPlayerUnit() {

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        guard let playerUnits = self.map?.unitsOf(civilization: currentUserCivilization) else {
            fatalError("Can't get current users units")
        }

        guard playerUnits.count > 1 else {
            return
        }

        guard let currentIndex = playerUnits.firstIndex(where: { $0 == selected }) else {
            fatalError("selected no in player units")
        }

        let nextIndex = (currentIndex + 1) % playerUnits.count

        self.selected = playerUnits[nextIndex]
    }

    func centerOnPlayerUnit() {

        // focus on unit
        self.gameObjectUnitDelegates |> { delegate in
            delegate.selectedUnitChanged(to: self.selected)
        }
    }

    func checkGameConditions() {

        self.gameObservationDelegate?.updated()
    }

    func dismiss() {

        for object in self.objects {
            object?.dismiss()
        }
    }

    // MARK: update methods

    func updatePlayer(unit _: Unit) {

        guard let fogManager = self.map?.fogManager else {
            fatalError("no fogManager set")
        }

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        // update fog for own units
        fogManager.update()

        // everyone except player
        for unit in self.map?.unitsExcept(civilization: currentUserCivilization) ?? [] {

            if let position = unit?.position {

                // FIXME: coins are map items
                /*if position == object.position && type == .coin {
                    
                    // consume coin
                    self.gameObservationDelegate?.coinConsumed()
                    
                    self.gameObjectUnitDelegates |> { delegate in
                        delegate.removed(gameObject: unit)
                    }
                    self.remove(object: unit)
                    continue
                }*/

                // FIXME: boosters are map items
                /*if position == object.position && type == .booster {
                    
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
                }*/

                // show/hide enemies based on fog
                let fogAtEnemy = fogManager.fog(at: position)
                if fogAtEnemy == .sighted {
                    unit?.gameObject?.show()
                } else {
                    unit?.gameObject?.hide()
                }
            }
        }

        guard let cities = self.map?.getCities() else {
            fatalError("can't get cities")
        }
        
        for city in cities {
            // show/hide cities based on discovery fog
            let fogAtEnemy = fogManager.fog(at: city.position)

            if fogAtEnemy == .discovered || fogAtEnemy == .sighted {
                city.gameObject?.show() // already discovered
            } else {
                city.gameObject?.hide()
            }
        }
    }

    func updateForeign(unit: Unit) {

        guard let fogManager = self.map?.fogManager else {
            fatalError("no fogManager set")
        }

        let fogAtEnemy = fogManager.fog(at: unit.position)
        if fogAtEnemy == .sighted {
            unit.gameObject?.show()
        } else {
            unit.gameObject?.hide()
        }
    }

    func updateForeign(city: City) {

        guard let fogManager = self.map?.fogManager else {
            fatalError("no fogManager set")
        }

        let fogAtEnemy = fogManager.fog(at: city.position)
        if fogAtEnemy == .discovered {
            city.gameObject?.show()
        } else {
            city.gameObject?.hide()
        }
    }
}

extension GameObjectManager: GameObjectDelegate {

    func moved(unit: Unit?) {

        guard let unit = unit else {
            fatalError("Can't add nil object")
        }

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        if unit.civilization == currentUserCivilization {
            self.updatePlayer(unit: unit)
        } else {
            self.updateForeign(unit: unit)
        }

        // check if won / lost the game
        self.checkGameConditions()
    }

    func battle(between source: Unit?, and target: Unit?) {

        self.gameObservationDelegate?.battle(between: source, and: target)
    }

    func ambushed(_ target: Unit?, by attacker: Unit?) {

        self.gameObservationDelegate?.battle(between: attacker, and: target)
    }

    func killed(unit: Unit?) {

        if let unit = unit {
            print("\(unit) killed")
        }
        // FIXME: animation of unit dying?
        self.remove(unit: unit)
    }
}
