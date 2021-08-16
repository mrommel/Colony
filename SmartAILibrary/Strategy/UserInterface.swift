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
    
    case declareWarQuestion(player: AbstractPlayer?)
    case barbarianCampCleared(location: HexPoint, gold: Int)
    
    case goodyHutReward(goodyType: GoodyType, location: HexPoint)
    
    case techDiscovered(tech: TechType)
    case civicDiscovered(civic: CivicType)
    case eraEntered(era: EraType)
    case eurekaTechActivated(tech: TechType)
    case eurekaCivicActivated(civic: CivicType)
    
    case unitTrained(unit: UnitType)
    case buildingBuilt
    
    case religionByCityAdopted(religion: ReligionType, location: HexPoint)
    case religionNewMajority(religion: ReligionType) // TXT_KEY_NOTIFICATION_RELIGION_NEW_PLAYER_MAJORITY
    case religionCanBuyMissionary // TXT_KEY_NOTIFICATION_ENOUGH_FAITH_FOR_MISSIONARY
    case canFoundPantheon
    case religionNeedNewAutomaticFaithSelection // TXT_KEY_NOTIFICATION_NEED_NEW_AUTOMATIC_FAITH_SELECTION
    case religionEnoughFaithForMissionary // ENOUGH_FAITH_FOR_MISSIONARY
}

extension PopupType: Equatable {
    
    public static func == (lhs: PopupType, rhs: PopupType) -> Bool {
        
        switch (lhs, rhs) {
        case (let .declareWarQuestion(lhs_player), let .declareWarQuestion(rhs_player)):
            return lhs_player?.leader == rhs_player?.leader
            
        case (let .barbarianCampCleared(lhs_location, lhs_gold), let .barbarianCampCleared(rhs_location, rhs_gold)):
            return lhs_location == rhs_location && lhs_gold == rhs_gold
        
        case (let .goodyHutReward(lhs_goodyType, lhs_location), let .goodyHutReward(rhs_goodyType, rhs_location)):
            return lhs_goodyType == rhs_goodyType && lhs_location == rhs_location
        
        case (let .techDiscovered(lhs_tech), let .techDiscovered(rhs_tech)):
            return lhs_tech == rhs_tech
            
        case (let .civicDiscovered(lhs_civic), let .civicDiscovered(rhs_civic)):
            return lhs_civic == rhs_civic
            
        case (let .eraEntered(lhs_era), let .eraEntered(rhs_era)):
            return lhs_era == rhs_era
            
        case (let .eurekaTechActivated(lhs_tech), let .eurekaTechActivated(rhs_tech)):
            return lhs_tech == rhs_tech
            
        case (let .eurekaCivicActivated(lhs_civic), let .eurekaCivicActivated(rhs_civic)):
            return lhs_civic == rhs_civic
        
        case (let .unitTrained(lhs_unit), let .unitTrained(rhs_unit)):
            return lhs_unit == rhs_unit
            
        case (.buildingBuilt, .buildingBuilt):
            return true
        
        case (let .religionByCityAdopted(lhs_religion, lhs_location), let .religionByCityAdopted(rhs_religion, rhs_location)):
            return lhs_religion == rhs_religion && lhs_location == rhs_location
            
        case (let .religionNewMajority(lhs_religion), let .religionNewMajority(rhs_religion)):
            return lhs_religion == rhs_religion
            
        case (.religionCanBuyMissionary, .religionCanBuyMissionary):
            return true
            
        case (.canFoundPantheon, .canFoundPantheon):
            return true
        case (.religionNeedNewAutomaticFaithSelection, .religionNeedNewAutomaticFaithSelection):
            return true
        case (.religionEnoughFaithForMissionary, .religionEnoughFaithForMissionary):
            return true
            
        case (.none, .none):
            return true
            
        default:
            return false
        }
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
    
    case unitList
    case selectPromotion
    case disbandConfirm
    case selectTradeCity
    
    case cityName
    
    case menu
    
    case selectPantheon
}

public enum UnitAnimationType {
    
    case fortify
    case unfortify
}

public protocol UserInterfaceDelegate: AnyObject {
    
    func showPopup(popupType: PopupType)

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
