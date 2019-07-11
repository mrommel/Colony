//
//  DiscoverCheck.swift
//  Colony
//
//  Created by Michael Rommel on 15.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum DiscoverAreaGameConditionType: GameConditionType {

    case discoveryGoalReached
    
    var summary: String {
        switch self {
            
        case .discoveryGoalReached:
            return "You have discovered 50 tiles."
        }
    }
}

class DiscoverCheck: GameConditionCheck {

    let tilesToBeDiscovered = 50

    override var identifier: String {
        return "DiscoverCheck"
    }

    override init() {
    }

    override func isWon() -> GameConditionType? {

        if let numberOfDiscoveredTiles = self.game?.level?.map.fogManager?.numberOfDiscoveredTiles() {
            if numberOfDiscoveredTiles > self.tilesToBeDiscovered {
                return DiscoverAreaGameConditionType.discoveryGoalReached
            }
        }

        return nil
    }

    override func isLost() -> GameConditionType? {

        // can't loose
        return nil
    }
}
