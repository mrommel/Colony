//
//  Notifications.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class DiplomaticData: Codable {

    enum CodingKeys: CodingKey {

        case state
        case message
        case emotion
    }

    public let state: DiplomaticRequestState
    public let message: DiplomaticRequestMessage
    public let emotion: LeaderEmotionType

    public init(state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType) {

        self.state = state
        self.message = message
        self.emotion = emotion
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.state = try container.decode(DiplomaticRequestState.self, forKey: .state)
        self.message = try container.decode(DiplomaticRequestMessage.self, forKey: .message)
        self.emotion = try container.decode(LeaderEmotionType.self, forKey: .emotion)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.state, forKey: .state)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.emotion, forKey: .emotion)
    }
}

public class NotificationItem: Codable, Equatable {

    enum CodingKeys: CodingKey {

        case type

        case turn
        case dismissed
        case needsBroadcasting
    }

    public let type: NotificationType

    let turn: Int // which turn this event was created on
    var dismissed: Bool
    var needsBroadcasting: Bool

    public init(type: NotificationType) {

        self.type = type

        self.dismissed = false
        self.needsBroadcasting = true
        self.turn = -1
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(NotificationType.self, forKey: .type)

        self.dismissed = try container.decode(Bool.self, forKey: .dismissed)
        self.needsBroadcasting = try container.decode(Bool.self, forKey: .needsBroadcasting)
        self.turn = try container.decode(Int.self, forKey: .turn)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)

        try container.encode(self.turn, forKey: .turn)
        try container.encode(self.dismissed, forKey: .dismissed)
        try container.encode(self.needsBroadcasting, forKey: .needsBroadcasting)
    }

    public func activate(in gameModel: GameModel?) {

        switch self.type {

        case .techNeeded:
            gameModel?.userInterface?.showScreen(screenType: .techList, city: nil, other: nil, data: nil)

        case .civicNeeded:
            gameModel?.userInterface?.showScreen(screenType: .civicList, city: nil, other: nil, data: nil)

        case .productionNeeded(cityName: _, location: let location):

            guard let city = gameModel?.city(at: location) else {
                fatalError("cant get city")
            }

            gameModel?.userInterface?.showScreen(screenType: .city, city: city, other: nil, data: nil)

        case .starving(cityName: _, location: let location),
             .cityGrowth(cityName: _, population: _, location: let location):

            guard let city = gameModel?.city(at: location) else {
                fatalError("cant get city")
            }

            gameModel?.userInterface?.showScreen(screenType: .city, city: city, other: nil, data: nil)

            // FIXME: give hint on city screen if city grown or starving

            self.dismiss(in: gameModel)

        case .unitNeedsOrders(location: let location):
            gameModel?.userInterface?.focus(on: location)

        case .diplomaticDeclaration:

            /*guard let otherPlayer = gameModel?.player(for: self.otherPlayer) else {
                fatalError("cant get player")
            }

            gameModel?.userInterface?.showScreen(screenType: .diplomatic, city: nil, other: otherPlayer, data: self.diplomaticData)
            self.dismiss(in: gameModel)*/
            fatalError("not implemented")

        case .canChangeGovernment:
            gameModel?.userInterface?.showScreen(screenType: .government, city: nil, other: nil, data: nil)
            self.dismiss(in: gameModel)

        case .policiesNeeded:
            gameModel?.userInterface?.showScreen(screenType: .changePolicies, city: nil, other: nil, data: nil)

        case .unitPromotion:
            gameModel?.userInterface?.showScreen(screenType: .selectPromotion, city: nil, other: nil, data: nil)

        case .canFoundPantheon:
            gameModel?.userInterface?.showScreen(screenType: .selectPantheon, city: nil, other: nil, data: nil)

        case .governorTitleAvailable:
            gameModel?.userInterface?.showScreen(screenType: .governors, city: nil, other: nil, data: nil)

        case .canRecruitGreatPerson(greatPerson: _):
            gameModel?.userInterface?.showScreen(screenType: .greatPeople, city: nil, other: nil, data: nil)

        case .goodyHutDiscovered(location: let location):
            gameModel?.userInterface?.focus(on: location)

        case .barbarianCampDiscovered(location: let location):
            gameModel?.userInterface?.focus(on: location)

        case .metCityState(cityState: let cityType, first: _):
            if let cityStatePlayer = gameModel?.cityStatePlayer(for: cityType) {
                if let capital = cityStatePlayer.capitalCity(in: gameModel) {
                    gameModel?.userInterface?.focus(on: capital.location)
                }
            }

            gameModel?.userInterface?.showScreen(screenType: .cityStates, city: nil, other: nil, data: nil)
            self.dismiss(in: gameModel)

        case .momentAdded(type: _):
            gameModel?.userInterface?.showScreen(screenType: .moments, city: nil, other: nil, data: nil)
            self.dismiss(in: gameModel)

        case .questCityStateFulfilled(cityState: let cityState, quest: let quest):
            gameModel?.userInterface?.showPopup(popupType: .questFulfilled(cityState: cityState, quest: quest))
            self.dismiss(in: gameModel)

        case .questCityStateGiven(cityState: _, quest: _):
            gameModel?.userInterface?.showScreen(screenType: .cityStates, city: nil, other: nil, data: nil)
            self.dismiss(in: gameModel)

        case .questCityStateObsolete(cityState: _, quest: _):
            gameModel?.userInterface?.showScreen(screenType: .cityStates, city: nil, other: nil, data: nil)
            self.dismiss(in: gameModel)

        case .tradeRouteCapacityIncreased:
            gameModel?.userInterface?.showScreen(screenType: .tradeRoutes, city: nil, other: nil, data: nil)
            self.dismiss(in: gameModel)

        case .naturalWonderDiscovered(location: let location):
            if let tile = gameModel?.tile(at: location) {
                if tile.feature().isNaturalWonder() {
                    gameModel?.userInterface?.focus(on: location)
                }
            }
            self.dismiss(in: gameModel)

        case .wonderBuilt:
            print("show popup?")
            self.dismiss(in: gameModel)

        case .cityCanShoot(cityName: _, location: let location):
            gameModel?.userInterface?.focus(on: location)

        case .cityAcquired(cityName: _, location: let location):
            guard let city = gameModel?.city(at: location) else {
                fatalError("cant get city at \(location)")
            }

            guard let cityPlayer = city.player else {
                fatalError("cant get city player")
            }

            var showRazeOrReturnDialog: Bool = false
            if cityPlayer.canRaze(city: city, ignoreCapitals: false, in: gameModel) {
                showRazeOrReturnDialog = true
            }

            if city.originalLeader() != city.previousLeader() {
                showRazeOrReturnDialog = true
            }

            if showRazeOrReturnDialog {
                gameModel?.userInterface?.showScreen(screenType: .razeOrReturnCity, city: city, other: nil, data: nil)
            } else {
                gameModel?.userInterface?.showScreen(screenType: .city, city: city, other: nil, data: nil)
            }
            self.dismiss(in: gameModel)

        case .continentDiscovered(location: let location, continentName: _):
            gameModel?.userInterface?.focus(on: location)
            self.dismiss(in: gameModel)

        default:
            print("activate \(self.type) not handled")
        }
    }

    public func dismiss(in gameModel: GameModel?) {

        // print("dismiss: \(self.type)")
        self.dismissed = true
        gameModel?.userInterface?.remove(notification: self)
    }

    func expired(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("Cant get gameModel")
        }

        switch self.type {

        case .techNeeded:

            guard let techs = player?.techs else {
                fatalError("cant get techs")
            }

            if !techs.needToChooseTech() {
                // already selected a tech
                return true
            }

            return false

        case .civicNeeded:

            guard let civics = player?.civics else {
                fatalError("cant get civics")
            }

            if !civics.needToChooseCivic() {
                // already selected a civic
                return true
            }

            return false

        case .productionNeeded(cityName: _, location: let location):

            guard let city = gameModel.city(at: location) else {
                fatalError("cant get city to check")
            }

            guard let currentPlayer = player else {
                fatalError("cant get player")
            }

            // when the city does no longer belong to this player (revolt),
            // it should be exired
            guard currentPlayer.isEqual(to: city.player) else {
                return true
            }

            if city.buildQueue.hasBuildable() {
                // already has something to build
                return true
            }

            return false

        case .canChangeGovernment:
            return false

        case .policiesNeeded:

            guard let government = player?.government else {
                fatalError("cant get government")
            }

            return government.hasPolicyCardsFilled(in: gameModel)

        case .unitPromotion:
            guard let currentPlayer = player else {
                fatalError("cant get player")
            }

            if !currentPlayer.hasPromotableUnit(in: gameModel) {
                return true
            }

            return false

        case .canFoundPantheon:
            guard let currentPlayer = player else {
                fatalError("cant get player")
            }

            guard let religion = currentPlayer.religion else {
                fatalError("Cant get player religion")
            }

            if religion.pantheon() != .none {
                return true
            }

            return false

        case .governorTitleAvailable:
            guard let currentPlayer = player else {
                fatalError("cant get player")
            }

            guard let governors = currentPlayer.governors else {
                fatalError("Cant get player governors")
            }

            if governors.numTitlesAvailable() > 0 {
                return false
            }

            return true

        case .greatPersonJoined:
            return true

        case .canRecruitGreatPerson(greatPerson: _):
            return true

        case .goodyHutDiscovered(location: let location):

            guard let tile = gameModel.tile(at: location) else {
                fatalError("goodyHut notification outside game map")
            }

            if tile.has(improvement: .goodyHut) {
                return false
            }

            return true

        case .barbarianCampDiscovered(location: let location):

            guard let tile = gameModel.tile(at: location) else {
                fatalError("goodyHut notification outside game map")
            }

            if tile.has(improvement: .barbarianCamp) {
                return false
            }

            return true

        case .questCityStateFulfilled(cityState: _, quest: _):
            return false

        case .questCityStateGiven(cityState: _, quest: _):
            return false

        case .questCityStateObsolete(cityState: _, quest: _):
            return false

        case .metCityState(cityState: _, first: _):
            return false

        case .tradeRouteCapacityIncreased:
            return false

        case .momentAdded(type: _):
            return false

        case .cityCanShoot(cityName: _, location: let location):
            guard let city = gameModel.city(at: location) else {
                fatalError("cant get city at \(location)")
            }

            return city.madeAttack()

        case .cityAcquired(cityName: _, location: _):
            return false

        default:
            return false
        }
    }

    public static func == (lhs: NotificationItem, rhs: NotificationItem) -> Bool {

        return lhs.type == rhs.type
    }
}

public class Notifications: Codable {

    enum CodingKeys: CodingKey {

        case notifications
    }

    var player: AbstractPlayer?
    var notificationsArray: [NotificationItem]

    init(player: AbstractPlayer?) {

        self.player = player
        self.notificationsArray = []
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.player = nil
        self.notificationsArray = try container.decode([NotificationItem].self, forKey: .notifications)

        for item in self.notificationsArray {

            item.needsBroadcasting = true
        }
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.notificationsArray, forKey: .notifications)
    }

    public func update(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for notification in self.notificationsArray where !notification.dismissed {

            if notification.expired(for: self.player, in: gameModel) {
                notification.dismiss(in: gameModel)
            } else {
                if notification.needsBroadcasting {
                    gameModel.userInterface?.add(notification: notification)
                    notification.needsBroadcasting = false
                }
            }
        }
    }

    public func notifications() -> [NotificationItem] {

        return self.notificationsArray
    }

    func add(notification type: NotificationType) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if !player.isHuman() {
            // no notifications for ai player
            return
        }

        let notification = NotificationItem(type: type)

        if !self.notificationsArray.contains(where: { $0 == notification }) {

            self.notificationsArray.append(notification)
        }
    }

    func endTurnBlockingNotification() -> NotificationItem? {

        for notification in self.notificationsArray {

            if notification.dismissed {
                continue
            }

            // NOTIFICATION_DIPLO_VOTE

            // NOTIFICATION_PRODUCTION
            if case NotificationType.productionNeeded(cityName: _, location: _) = notification.type {
                return notification
            }
            /* if notification.type.value() == NotificationType.productionNeeded(cityName: "", location: HexPoint.invalid).value() {
                return notification
            }*/

            // NOTIFICATION_POLICY
            if notification.type == .civicNeeded {
                return notification
            }

            // NOTIFICATION_FREE_POLICY

            // NOTIFICATION_TECH
            if notification.type == .techNeeded {
                return notification
            }

            // NOTIFICATION_FREE_TECH

            // NOTIFICATION_FREE_GREAT_PERSON

            // policies
            if notification.type == .policiesNeeded {
                return notification
            }

            if case .cityAcquired(cityName: _, location: _) = notification.type {
                return notification
            }
        }

        return nil
    }

    // removing notifications at the end turns
    func cleanUp(in gameModel: GameModel?) {

        for notification in self.notificationsArray {

            // city growth should vanish at the end of turn (if not already)
            if notification.type.value() == NotificationType.cityGrowth(cityName: "", population: 0, location: HexPoint.invalid).value() &&
                notification.dismissed == false {

                notification.dismiss(in: gameModel)
            }
        }

        self.notificationsArray.removeAll(where: { $0.dismissed })
    }
}
