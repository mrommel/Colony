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
    
    case religionByCityAdopted
    case religionNewMajority // TXT_KEY_NOTIFICATION_RELIGION_NEW_PLAYER_MAJORITY
    case religionCanBuyMissionary // TXT_KEY_NOTIFICATION_ENOUGH_FAITH_FOR_MISSIONARY
    case religionCanFoundPantheon // TXT_KEY_NOTIFICATION_ENOUGH_FAITH_FOR_PANTHEON
    case religionNeedNewAutomaticFaithSelection // TXT_KEY_NOTIFICATION_NEED_NEW_AUTOMATIC_FAITH_SELECTION
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
    public let religionType: ReligionType
    
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
        self.religionType = .none
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
        self.religionType = .none
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
        self.religionType = .none
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
        self.religionType = .none
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
        self.religionType = .none
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
        self.religionType = .none
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
        self.religionType = .none
    }
    
    init(religionType: ReligionType, for cityName: String = "") {
        
        self.player = nil
        self.money = -1
        
        self.featureType = .none
        self.production = -1
        self.cityName = cityName
        
        self.tech = .none
        self.civic = .none
        
        self.era = .none
        self.goodyType = nil
        self.religionType = religionType
    }
}

public enum ScreenType {
    
    case none // map
    
    case city
    
    case techs
    case civics
    case treasury
    case interimRanking
    case diplomatic
    
    case government // <-- main dialog
    case changePolicies
    case changeGovernment
    
    case selectPromotion
    case disbandConfirm
    case selectTradeCity
    case cityName
    
    case menu
}

public enum UnitAnimationType {
    
    case fortify
    case unfortify
}

public protocol UserInterfaceDelegate: AnyObject {
    
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
    
    // todo - should not be part of the interface protocol
    func askToDisband(unit: AbstractUnit?, completion: @escaping (Bool)->())
    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?)->())
    
    // on map
    func show(city: AbstractCity?)
    func update(city: AbstractCity?)
    
    func refresh(tile: AbstractTile?)
    
    func showTooltip(at point: HexPoint, text: String, delay: Double)
    
    func focus(on location: HexPoint)
}
