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
        case player
        case location
        case message
        case summary
        case otherPlayer
        
        case diplomaticData
        
        case turn
        case dismissed
        case needsBroadcasting
    }
    
    public let type: NotificationType
    public let player: LeaderType
    public let location: HexPoint
    public let message: String
    public let summary: String
    public let otherPlayer: LeaderType
    
    // diplomatic states / messages
    public var diplomaticData: DiplomaticData?
    
    let turn: Int // which turn this event was created on
    var dismissed: Bool
    var needsBroadcasting: Bool
    
    public init(type: NotificationType, for player: LeaderType, message: String, summary: String, at location: HexPoint, other otherPlayer: LeaderType) {
        
        self.type = type
        self.player = player
        self.message = message
        self.summary = summary
        self.location = location
        self.otherPlayer = otherPlayer
        
        self.dismissed = false
        self.needsBroadcasting = true
        self.turn = -1
    }
    
    required public init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decode(NotificationType.self, forKey: .type)
        self.player = try container.decode(LeaderType.self, forKey: .player)
        self.message = try container.decode(String.self, forKey: .message)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.location = try container.decode(HexPoint.self, forKey: .location)
        self.otherPlayer = try container.decode(LeaderType.self, forKey: .otherPlayer)
        
        self.diplomaticData = try container.decodeIfPresent(DiplomaticData.self, forKey: .diplomaticData)
        
        self.dismissed = try container.decode(Bool.self, forKey: .dismissed)
        self.needsBroadcasting = try container.decode(Bool.self, forKey: .needsBroadcasting)
        self.turn = try container.decode(Int.self, forKey: .turn)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.type, forKey: .type)
        try container.encode(self.player, forKey: .player)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.summary, forKey: .summary)
        try container.encode(self.otherPlayer, forKey: .otherPlayer)
        
        try container.encodeIfPresent(self.diplomaticData, forKey: .diplomaticData)
        
        try container.encode(self.turn, forKey: .turn)
        try container.encode(self.dismissed, forKey: .dismissed)
        try container.encode(self.needsBroadcasting, forKey: .needsBroadcasting)
    }
    
    public func activate(in gameModel: GameModel?) {
        
        switch self.type {
            
        case .techNeeded:
            gameModel?.userInterface?.showScreen(screenType: .techs, city: nil, other: nil, data: nil)
            
        case .civicNeeded:
            gameModel?.userInterface?.showScreen(screenType: .civics, city: nil, other: nil, data: nil)

        case .productionNeeded, .starving, .cityGrowth:
            guard let city = gameModel?.city(at: self.location) else {
                fatalError("cant get city")
            }
            
            gameModel?.userInterface?.showScreen(screenType: .city, city: city, other: nil, data: nil)
            
            // FIXME: give hint on city screen if city grown or starving
            
            if self.type == .starving || self.type == .cityGrowth {
                self.dismiss(in: gameModel)
            }
            
        case .unitNeedsOrders:
            gameModel?.userInterface?.focus(on: self.location)
            
        case .diplomaticDeclaration:
            
            guard let otherPlayer = gameModel?.player(for: self.otherPlayer) else {
                fatalError("cant get player")
            }
            
            gameModel?.userInterface?.showScreen(screenType: .diplomatic, city: nil, other: otherPlayer, data: self.diplomaticData)
            self.dismiss(in: gameModel)
            
        case .canChangeGovernment:
            gameModel?.userInterface?.showScreen(screenType: .government, city: nil, other: nil, data: nil)
            self.dismiss(in: gameModel)
            
        case .policiesNeeded:
            gameModel?.userInterface?.showScreen(screenType: .governmentPolicies, city: nil, other: nil, data: nil)
            
        default:
            print("activate \(self.type) not handled")
        }
    }
    
    public func dismiss(in gameModel: GameModel?) {
        
        // print("dismiss: \(self.type)")
        self.dismissed = true
        gameModel?.userInterface?.remove(notification: self)
    }
    
    func expired(in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("Cant get gameModel")
        }
        
        switch self.type {
            
        case .techNeeded:
            
            guard let player = gameModel.player(for: self.player) else {
                fatalError("cant get player")
            }
            
            guard let techs = player.techs else {
                fatalError("cant get techs")
            }
            
            if !techs.needToChooseTech() {
                // already selected a tech
                return true
            }
            
            return false
            
        case .civicNeeded:
            
            guard let player = gameModel.player(for: self.player) else {
                fatalError("cant get player")
            }
            
            guard let civics = player.civics else {
                fatalError("cant get civics")
            }
            
            if !civics.needToChooseCivic() {
                // already selected a civic
                return true
            }
            
            return false
            
        case .productionNeeded:
            
            guard let city = gameModel.city(at: self.location) else {
                fatalError("cant get city to check")
            }
            
            if city.buildQueue.hasBuildable() {
                // already has something to build
                return true
            }
            
            return false
                
        case .canChangeGovernment:
            return true
            
        case .policiesNeeded:
            guard let currentPlayer = gameModel.player(for: self.player) else {
                fatalError("cant get player")
            }
            
            guard let government = currentPlayer.government else {
                fatalError("cant get government")
            }
            
            return government.hasPolicyCardsFilled()
            
        default:
            return false
        }
    }
    
    public static func == (lhs: NotificationItem, rhs: NotificationItem) -> Bool {
        
        if lhs.type == rhs.type {
            
            if lhs.type == .techNeeded {
                
                // highlander, only one notification of this type
                return true
            }
            
            if lhs.type == .civicNeeded {
                
                // highlander, only one notification of this type
                return true
            }
            
            if lhs.type == .productionNeeded {
                
                if lhs.location == rhs.location {
                    
                    // there can be multiple notifications - one per city == location
                    return true
                }
            }
        }
        
        return false
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
        
        for notification in self.notificationsArray {
            
            if !notification.dismissed {
                
                if notification.expired(in: gameModel) {
                    notification.dismiss(in: gameModel)
                } else {
                    if notification.needsBroadcasting {
                        gameModel.userInterface?.add(notification: notification)
                        notification.needsBroadcasting = false
                    }
                }
            }
        }
    }
    
    public func notifications() -> [NotificationItem] {
    
        return self.notificationsArray
    }
    
    func addNotification(of type: NotificationType, for player: AbstractPlayer?, message: String, summary: String, at location: HexPoint = HexPoint.zero, other otherPlayer: AbstractPlayer? = nil) {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if !player.isHuman() {
            // no notifications for ai player
            return
        }
        
        var otherLeader: LeaderType = .none
        if let otherPlayer = otherPlayer {
            otherLeader = otherPlayer.leader
        }
        
        let notification = NotificationItem(type: type, for: player.leader, message: message, summary: summary, at: location, other: otherLeader)
        
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
            if notification.type == .productionNeeded {
                return notification
            }
            
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
        }
        
        return nil
    }
    
    // removing notifications at the end turns
    func cleanUp(in gameModel: GameModel?) {
        
        for notification in self.notificationsArray {
            
            // city growth should vanish at the end of turn (if not already)
            if notification.type == .cityGrowth && notification.dismissed == false {
                notification.dismiss(in: gameModel)
            }
        }
        
        self.notificationsArray.removeAll(where: { $0.dismissed })
    }
}
