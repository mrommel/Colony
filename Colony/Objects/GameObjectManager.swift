//
//  GameObjectManager.swift
//  Colony
//
//  Created by Michael Rommel on 07.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol GameObjectDelegate {

    func moved(object: GameObject?)
}

class GameObjectManager {

    weak var map: HexagonTileMap?
    var objects: [GameObject?]

    init(on map: HexagonTileMap?) {
        self.objects = []
        self.map = map
    }

    func add(object: GameObject?) {

        guard let object = object else {
            fatalError("Can't add nil object")
        }

        // only player unit update the fog
        if object.tribe == .player {
            self.map?.fogManager?.add(unit: object)
        }

        object.delegate = self
        self.objects.append(object)
    }

    func unitsOf(tribe: GameObjectTribe) -> [GameObject?] {

        return self.objects.filter { $0?.tribe == tribe }
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

            for enemyUnit in self.unitsOf(tribe: .enemy) {

                if let position = enemyUnit?.position {

                    // show/hide enemies based on fog
                    let fogAtEnemy = fogManager.fog(at: position)
                    if fogAtEnemy == .sighted {
                        enemyUnit?.sprite.alpha = 1.0
                    } else {
                        enemyUnit?.sprite.alpha = 0.5
                    }
                }
            }
        }
    }
}
