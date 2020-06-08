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
    case featureGivesProduction // Das Entfernen der Geländeart {@1_FeatName} hat {2_Num} [ICON_PRODUCTION] für die Stadt {@3_CityName} eingebracht.
    
    case techDiscovered
    case civicDiscovered
    case eraEntered
    case eurekaActivated
}

public class PopupData {
    
    let player: AbstractPlayer?
    let money: Int
    
    let featureType: FeatureType
    let production: Int
    let cityName: String
    
    public let tech: TechType
    public let civic: CivicType
    
    public let era: EraType
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        self.money = -1
        
        self.featureType = .none
        self.production = -1
        self.cityName = ""
        
        self.tech = .none
        self.civic = .none
        
        self.era = .none
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
    
    case menu
}

public protocol UserInterfaceProtocol: class {
    
    func showPopup(popupType: PopupType, with data: PopupData?)

    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?)
    func isShown(screen: ScreenType) -> Bool
    
    func add(notification: NotificationItem)
    func remove(notification: NotificationItem)
    
    func select(unit: AbstractUnit?)
    func unselect()
    
    func show(unit: AbstractUnit?) // unit gets visible
    func hide(unit: AbstractUnit?) // unit gets hidden
    func move(unit: AbstractUnit?, on points: [HexPoint])
    
    func select(tech: TechType)
    func select(civic: CivicType)
    
    // on map
    func show(city: AbstractCity?)
    func update(city: AbstractCity?)
    
    func refresh(tile: AbstractTile?)
    
    func showTooltip(at point: HexPoint, text: String, delay: Double)
    
    func focus(on location: HexPoint)
}
