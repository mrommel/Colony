//
//  UserInterface.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum PopupType {
    
    case none
    
    case declareWarQuestion  // ??
    case barbarianCampCleared
    
    case goodyHutReward
    
    case techDiscovered
    case civicDiscovered
    case eraEntered
    case eurekaActivated
    
    case unitTrained
    case buildingBuilt
}

public class PopupData {
    
    public let player: AbstractPlayer?
    public let money: Int
    
    public let featureType: FeatureType
    public let production: Int
    public let cityName: String
    
    public let tech: TechType
    public let civic: CivicType
    
    public let era: EraType
    
    public let goodyType: GoodyType?
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        self.money = -1
        
        self.featureType = .none
        self.production = -1
        self.cityName = ""
        
        self.tech = .none
        self.civic = .none
        
        self.era = .none
        
        self.goodyType = nil
    }
    
    init(money: Int) {
        
        self.player = nil
        self.money = money
        
        self.featureType = .none
        self.production = -1
        self.cityName = ""
        
        self.tech = .none
        self.civic = .none
        
        self.era = .none
        
        self.goodyType = nil
    }
    
    init(featureType: FeatureType, production: Int, cityName: String) {
        
        self.player = nil
        self.money = -1
        
        self.featureType = featureType
        self.production = production
        self.cityName = cityName
        
        self.tech = .none
        self.civic = .none
        
        self.era = .none
        
        self.goodyType = nil
    }
    
    init(tech: TechType) {
        
        self.player = nil
        self.money = -1
        
        self.featureType = .none
        self.production = -1
        self.cityName = ""
        
        self.tech = tech
        self.civic = .none
        
        self.era = .none
        
        self.goodyType = nil
    }
    
    init(civic: CivicType) {
        
        self.player = nil
        self.money = -1
        
        self.featureType = .none
        self.production = -1
        self.cityName = ""
        
        self.tech = .none
        self.civic = civic
        
        self.era = .none
        
        self.goodyType = nil
    }
    
    init(era: EraType) {
        
        self.player = nil
        self.money = -1
        
        self.featureType = .none
        self.production = -1
        self.cityName = ""
        
        self.tech = .none
        self.civic = .none
        
        self.era = era
        
        self.goodyType = nil
    }
    
    init(goodyType: GoodyType, for cityName: String = "") {
        
        self.player = nil
        self.money = -1
        
        self.featureType = .none
        self.production = -1
        self.cityName = cityName
        
        self.tech = .none
        self.civic = .none
        
        self.era = .none
        self.goodyType = goodyType
    }
}

public enum ScreenType {
    
    case none // map
    
    case interimRanking
    case diplomatic
    
    case city
    case techs
    case civics
    
    case treasury
    case government
    case governmentPolicies
    case changePolicies
    case changeGovernment
    case selectPromotion
    
    case menu
}

public enum UnitAnimationType {
    
    case fortify
    case unfortify
}

public protocol UserInterfaceProtocol: class {
    
    func showPopup(popupType: PopupType, with data: PopupData?)

    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?)
    func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType)
    func isShown(screen: ScreenType) -> Bool
    
    func add(notification: NotificationItem)
    func remove(notification: NotificationItem)
    
    func select(unit: AbstractUnit?)
    func unselect()
    
    func show(unit: AbstractUnit?) // unit gets visible
    func hide(unit: AbstractUnit?) // unit gets hidden
    func refresh(unit: AbstractUnit?)
    func move(unit: AbstractUnit?, on points: [HexPoint])
    func animate(unit: AbstractUnit?, animation: UnitAnimationType)
    
    func select(tech: TechType)
    func select(civic: CivicType)
    
    // on map
    func show(city: AbstractCity?)
    func update(city: AbstractCity?)
    
    func refresh(tile: AbstractTile?)
    
    func showTooltip(at point: HexPoint, text: String, delay: Double)
    
    func focus(on location: HexPoint)
}
