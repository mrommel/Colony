//
//  GameMessages.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

/*public protocol AbstractGameMessage {

    var title: String { get }
    var text: String { get }
}

class FirstContactMessage: AbstractGameMessage {

    let title: String
    let text: String
    let player: AbstractPlayer?

    init(with player: AbstractPlayer?) {

        self.player = player

        guard let player = player else {
            fatalError("cant get player")
        }
        
        self.title = "You made first contact with \(player.leader)"
        self.text = "..."
    }
}

class PlayerNeedsTechSelectionMessage: AbstractGameMessage {

    let title: String
    let text: String
    
    init() {

        self.title = "You need to select the tech to research."
        self.text = "..."
    }
}

class TechDiscoveredMessage: AbstractGameMessage {

    let title: String
    let text: String
    let tech: TechType
    
    init(with tech: TechType) {

        self.tech = tech
        
        self.title = "You have discovered the new technology '\(tech)'."
        self.text = "..."
    }
}

class CivicDiscoveredMessage: AbstractGameMessage {

    let title: String
    let text: String
    let civic: CivicType
    
    init(with civic: CivicType) {

        self.civic = civic
        
        self.title = "You have discovered the civic '\(civic)'."
        self.text = "..."
    }
}

class EnteredEraMessage: AbstractGameMessage {

    let title: String
    let text: String
    let era: EraType
    
    init(with era: EraType) {

        self.era = era
        
        self.title = "You have entered the era \(era)."
        self.text = "..."
    }
}

class CityGrowthMessage: AbstractGameMessage {

    let title: String
    let text: String
    let city: AbstractCity?
    
    init(in city: AbstractCity?) {
        
        self.city = city
        
        if let city = self.city {
            self.title = "\(city.name) has Grown!"
            self.text = "The City of \(city.name) now has \(city.population()) [ICON_CITIZEN] Citizens! The new Citizen will automatically work the land near the City for additional [ICON_FOOD] Food, [ICON_PRODUCTION] Production or [ICON_GOLD] Gold."
        } else {
            self.title = ""
            self.text = ""
        }
    }
}

class CityStarvingMessage: AbstractGameMessage {

    let title: String
    let text: String
    let city: AbstractCity?
    
    init(in city: AbstractCity?) {
        
        self.city = city
        
        if let city = self.city {
            self.title = "\(city.name) is Starving!"
            self.text = "The City of \(city.name) is starving! If it runs out of stored [ICON_FOOD] Food, a [ICON_CITIZEN] Citizen will die!"
        } else {
            self.title = ""
            self.text = ""
        }
    }
}

class DeclarationOfFriendshipMessage: AbstractGameMessage {

    let title: String
    let text: String
    
    init(text: String) {

        self.title = text
        self.text = "..."
    }
}

class DenouncementMessage: AbstractGameMessage {

    let title: String
    let text: String
    
    init(text: String) {

        self.title = text
        self.text = "..."
    }
}

class DeclarationOfWarMessage: AbstractGameMessage {

    let title: String
    let text: String
    let player: AbstractPlayer?
    
    init(by player: AbstractPlayer?) {

        self.player = player
        
        if let player = self.player {
            self.title = "Declaration of war"
            self.text = "\(player.leader.name()) has declared war on you!" // TXT_KEY_MISC_DECLARED_WAR_ON_YOU
        } else {
            self.title = ""
            self.text = ""
        }
    }
}

class CityNeedsBuildableMessage: AbstractGameMessage {

    let title: String
    let text: String
    
    init(city: AbstractCity?) {

        self.title = "Your city \(city!.name) needs something to work on."
        self.text = "..."
    }
}

class CityHasFinishedTrainingMessage: AbstractGameMessage {

    let title: String
    let text: String
    let city: AbstractCity?
    let unitType: UnitType
    
    init(city: AbstractCity?, unit unitType: UnitType) {

        self.city = city
        self.unitType = unitType
        
        self.title = "Your city \(city!.name) has finished training at \(unitType.name())"
        self.text = "..."
    }
}

class CityHasFinishedBuildingMessage: AbstractGameMessage {

    let title: String
    let text: String
    let city: AbstractCity?
    let buildingType: BuildingType
    
    init(city: AbstractCity?, building buildingType: BuildingType) {

        self.city = city
        self.buildingType = buildingType
        
        self.title = "Your city \(city!.name) has finished working on \(buildingType.name())"
        self.text = "..."
    }
}

class CityHasFinishedDistrictMessage: AbstractGameMessage {

    let title: String
    let text: String
    let city: AbstractCity?
    let districtType: DistrictType
    
    init(city: AbstractCity?, district districtType: DistrictType) {

        self.city = city
        self.districtType = districtType
        
        self.title = "Your city \(city!.name) has finished working on \(districtType.name())"
        self.text = "..."
    }
}

class PromotionGainedMessage: AbstractGameMessage {

    let title: String
    let text: String
    
    init(unit: AbstractUnit?) {
        
        self.title = "\(unit!.name()) has gained a promotion."
        self.text = "..."
    }
}

class EnemyInTerritoryMessage: AbstractGameMessage {

    let title: String
    let text: String

    init(at location: HexPoint, of type: UnitType) {
        
        self.title = "An Enemy is Near!"
        self.text = "An enemy unit has been spotted in our territory!"
    }
}

class UnitCapturedMessage: AbstractGameMessage {

    let title: String
    let text: String
    let player: AbstractPlayer?

    init(by player: AbstractPlayer?, unitType: UnitType) {
        
        self.player = player
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if player.isBarbarian() {
            self.title = "A civilian was captured by Barbarians!"
            self.text = "\(unitType) was captured by the Barbarians! They will take it to their nearest Encampment. If you wish to recover your unit you will have to track it down!"
        } else {
            self.title = "A Civilian was captured!"
            self.text = "\(unitType) was captured by \(player.leader)!"
        }
    }
}

class LostUnitMessage: AbstractGameMessage {

    let title: String
    let text: String

    init(by player: AbstractPlayer?) {        
        self.title = "A Unit was Killed!"
        self.text = "..."
    }
}*/
