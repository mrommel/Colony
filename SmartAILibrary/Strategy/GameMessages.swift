//
//  GameMessages.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

protocol AbstractGameMessage {

    var text: String { get }
}

class FirstContactMessage: AbstractGameMessage {

    let text: String
    let player: AbstractPlayer?

    init(with player: AbstractPlayer?) {

        self.player = player

        guard let player = player else {
            fatalError("cant get player")
        }
        
        self.text = "You made first contact with \(player.leader)"
    }
}

class PlayerNeedsTechSelectionMessage: AbstractGameMessage {

    let text: String
    
    init() {

        self.text = "You need to select the tech to research."
    }
}

class TechDiscoveredMessage: AbstractGameMessage {

    let text: String
    let tech: TechType
    
    init(with tech: TechType) {

        self.tech = tech
        
        self.text = "You have discovered the new technology '\(tech)'."
    }
}

class CivicDiscoveredMessage: AbstractGameMessage {

    let text: String
    let civic: CivicType
    
    init(with civic: CivicType) {

        self.civic = civic
        
        self.text = "You have discovered the civic '\(civic)'."
    }
}

class EnteredEraMessage: AbstractGameMessage {

    let text: String
    let era: EraType
    
    init(with era: EraType) {

        self.era = era
        
        self.text = "You have entered the era \(era)."
    }
}

class GrowthStatusMessage: AbstractGameMessage {

    let text: String
    let city: AbstractCity?
    let growth: GrowthStatusType
    
    init(in city: AbstractCity?, growth: GrowthStatusType) {

        self.city = city
        self.growth = growth
        
        if self.growth == .growth {
            self.text = "Your city \(city!.name) has grown."
        } else {
            self.text = "Your city \(city!.name) is starving."
        }
    }
}

class DeclarationOfFriendshipMessage: AbstractGameMessage {

    let text: String
    
    init(text: String) {

        self.text = text
    }
}

class DenouncementMessage: AbstractGameMessage {

    let text: String
    
    init(text: String) {

        self.text = text
    }
}

class DeclarationOfWarMessage: AbstractGameMessage {

    let text: String
    
    init(text: String) {

        self.text = text
    }
}

class CityNeedsBuildableMessage: AbstractGameMessage {

    let text: String
    
    init(city: AbstractCity?) {

        self.text = "Your city \(city!.name) needs something to work on."
    }
}

class CityHasFinishedTrainingMessage: AbstractGameMessage {

    let text: String
    let city: AbstractCity?
    let unitType: UnitType
    
    init(city: AbstractCity?, unit unitType: UnitType) {

        self.city = city
        self.unitType = unitType
        
        self.text = "Your city \(city!.name) has finished training at \(unitType.name())"
    }
}

class CityHasFinishedBuildingMessage: AbstractGameMessage {

    let text: String
    let city: AbstractCity?
    let buildingType: BuildingType
    
    init(city: AbstractCity?, building buildingType: BuildingType) {

        self.city = city
        self.buildingType = buildingType
        
        self.text = "Your city \(city!.name) has finished working on \(buildingType.name())"
    }
}

class CityHasFinishedDistrictMessage: AbstractGameMessage {

    let text: String
    let city: AbstractCity?
    let districtType: DistrictType
    
    init(city: AbstractCity?, district districtType: DistrictType) {

        self.city = city
        self.districtType = districtType
        
        self.text = "Your city \(city!.name) has finished working on \(districtType.name())"
    }
}

class PromotionGainedMessage: AbstractGameMessage {

    let text: String
    
    init(unit: AbstractUnit?) {
        
        self.text = "\(unit!.name()) has gained a promotion."
    }
}
