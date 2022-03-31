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

    case goodyHutReward(goodyType: GoodyType, location: HexPoint)

    case techDiscovered(tech: TechType)
    case civicDiscovered(civic: CivicType)
    case eraEntered(era: EraType)
    case eurekaTriggered(tech: TechType)
    case inspirationTriggered(civic: CivicType)

    case unitTrained(unit: UnitType)
    case wonderBuilt(wonder: WonderType)
    case buildingBuilt

    case religionByCityAdopted(religion: ReligionType, location: HexPoint)
    case religionNewMajority(religion: ReligionType) // TXT_KEY_NOTIFICATION_RELIGION_NEW_PLAYER_MAJORITY
    case religionCanBuyMissionary // TXT_KEY_NOTIFICATION_ENOUGH_FAITH_FOR_MISSIONARY
    case canFoundPantheon
    case religionNeedNewAutomaticFaithSelection // TXT_KEY_NOTIFICATION_NEED_NEW_AUTOMATIC_FAITH_SELECTION
    case religionEnoughFaithForMissionary // ENOUGH_FAITH_FOR_MISSIONARY

    case cityRevolted(city: AbstractCity?)
    case foreignCityRevolted(city: AbstractCity?)
    case lostOwnCapital
    case lostCapital(leader: LeaderType)
}

extension PopupType: Equatable {

    public static func == (lhs: PopupType, rhs: PopupType) -> Bool {

        switch (lhs, rhs) {
        case (let .declareWarQuestion(lhs_player), let .declareWarQuestion(rhs_player)):
            return lhs_player?.leader == rhs_player?.leader

        case (let .goodyHutReward(lhs_goodyType, lhs_location), let .goodyHutReward(rhs_goodyType, rhs_location)):
            return lhs_goodyType == rhs_goodyType && lhs_location == rhs_location

        case (let .techDiscovered(lhs_tech), let .techDiscovered(rhs_tech)):
            return lhs_tech == rhs_tech

        case (let .civicDiscovered(lhs_civic), let .civicDiscovered(rhs_civic)):
            return lhs_civic == rhs_civic

        case (let .eraEntered(lhs_era), let .eraEntered(rhs_era)):
            return lhs_era == rhs_era

        case (let .eurekaTriggered(lhs_tech), let .eurekaTriggered(rhs_tech)):
            return lhs_tech == rhs_tech

        case (let .inspirationTriggered(lhs_civic), let .inspirationTriggered(rhs_civic)):
            return lhs_civic == rhs_civic

        case (let .unitTrained(lhs_unit), let .unitTrained(rhs_unit)):
            return lhs_unit == rhs_unit

        case (let .wonderBuilt(lhs_wonder), let .wonderBuilt(rhs_wonder)):
            return lhs_wonder == rhs_wonder

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

        case (.cityRevolted(city: let lhsCity), .cityRevolted(city: let rhsCity)):
            return lhsCity!.location == rhsCity!.location

        case (.foreignCityRevolted(city: let lhsCity), .foreignCityRevolted(city: let rhsCity)):
            return lhsCity!.location == rhsCity!.location

        case (.lostOwnCapital, .lostOwnCapital):
            return true

        case (.lostCapital(leader: let lhsLeader), .lostCapital(leader: let rhsLeader)):
            return lhsLeader == rhsLeader

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
    case cityState

    case techTree
    case techList
    case civicTree
    case civicList

    case interimRanking // not needed?
    case diplomatic
    case governors
    case greatPeople
    case tradeRoutes

    case government // <-- main dialog
    case changePolicies
    case changeGovernment

    case unitList
    case cityList

    case selectPromotion
    case selectTradeCity

    case confirm
    case selectItems
    case selectName

    case menu

    case selectPantheon
    case religion
    case ranking

    case victory
    case eraProgress
    case selectDedication
    case moments
    case cityStates
}

public enum TooltipType {

    case barbarianCampCleared(gold: Int)
    case clearedFeature(feature: FeatureType, production: Int, cityName: String)
    case capturedCity(cityName: String)
    case cultureFromKill(culture: Int)
    case goldFromKill(gold: Int)
    // combat
    case unitDiedAttacking(attackerName: String, defenderName: String, defenderDamage: Int)
    case enemyUnitDiedAttacking(attackerName: String, attackerPlayer: AbstractPlayer?, defenderName: String, defenderDamage: Int)
    case unitDestroyedEnemyUnit(attackerName: String, attackerDamage: Int, defenderName: String)
    case unitDiedDefending(attackerName: String, attackerPlayer: AbstractPlayer?, attackerDamage: Int, defenderName: String)
    case unitAttackingWithdraw(attackerName: String, attackerDamage: Int, defenderName: String, defenderDamage: Int)
    case enemyAttackingWithdraw(attackerName: String, attackerDamage: Int, defenderName: String, defenderDamage: Int)
    case conqueredEnemyCity(attackerName: String, attackerDamage: Int, cityName: String)
    case cityCapturedByEnemy(attackerName: String, attackerPlayer: AbstractPlayer?, attackerDamage: Int, cityName: String)
}

public enum UnitAnimationType {

    case idle(location: HexPoint)
    case move(from: HexPoint, to: HexPoint)
    case show(location: HexPoint)
    case hide(location: HexPoint)
    case enterCity(location: HexPoint)
    case fortify
    case unfortify
}

public struct SelectableItem {

    public let iconTexture: String?
    public let title: String
    public let subtitle: String

    public init(iconTexture: String? = nil, title: String, subtitle: String = "") {

        self.iconTexture = iconTexture
        self.title = title
        self.subtitle = subtitle
    }
}

public protocol UserInterfaceDelegate: AnyObject {

    func update(gameState: GameStateType)
    func update(activePlayer: AbstractPlayer?)

    func showPopup(popupType: PopupType)

    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?)
    func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType)
    func isShown(screen: ScreenType) -> Bool

    func add(notification: NotificationItem)
    func remove(notification: NotificationItem)

    func select(unit: AbstractUnit?)
    func unselect()

    func show(unit: AbstractUnit?, at location: HexPoint) // unit gets visible
    func hide(unit: AbstractUnit?, at location: HexPoint) // unit gets hidden and remove from list
    func enterCity(unit: AbstractUnit?, at location: HexPoint) // unit gets visible
    func leaveCity(unit: AbstractUnit?, at location: HexPoint) // unit gets hidden
    func refresh(unit: AbstractUnit?)
    func move(unit: AbstractUnit?, on points: [HexPoint])
    func animate(unit: AbstractUnit?, animation: UnitAnimationType)

    func clearAttackFocus()
    func showAttackFocus(at point: HexPoint)

    func select(tech: TechType)
    func select(civic: CivicType)

    // todo - should not be part of the interface protocol
    func askForConfirmation(
        title: String,
        question: String,
        confirm: String,
        cancel: String,
        completion: @escaping (Bool) -> Void
    )
    func askForCity(
        start startCity: AbstractCity?,
        of cities: [AbstractCity?],
        completion: @escaping (AbstractCity?) -> Void
    )
    func askForSelection(
        title: String,
        items: [SelectableItem],
        completion: @escaping (Int) -> Void
    )
    func askForInput(
        title: String,
        summary: String,
        value: String,
        confirm: String,
        cancel: String,
        completion: @escaping (String) -> Void
    )

    // on map
    func show(city: AbstractCity?)
    func update(city: AbstractCity?)
    func remove(city: AbstractCity?)

    func refresh(tile: AbstractTile?)

    func showTooltip(at point: HexPoint, type: TooltipType, delay: Double)

    func focus(on location: HexPoint)
}
