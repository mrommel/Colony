//
//  Notifications.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class NotificationItem {
    
    public let type: NotificationType
    let player: AbstractPlayer?
    let location: HexPoint
    public let message: String
    public let summary: String
    let turn: Int = -1 // which turn this event was created on
    var dismissed: Bool
    var needsBroadcasting: Bool
    
    public init(type: NotificationType, for player: AbstractPlayer?, message: String, summary: String, at location: HexPoint) {
        
        self.type = type
        self.player = player
        self.message = message
        self.summary = summary
        self.location = location
        
        self.dismissed = false
        self.needsBroadcasting = true
    }
    
    public func activate(in gameModel: GameModel?) {
        
        switch self.type {
            
        case .tech:
            gameModel?.userInterface?.showScreen(screenType: .techs, city: nil)
            
        case .civic:
            gameModel?.userInterface?.showScreen(screenType: .civics, city: nil)
            
        case .production:
            if let city = gameModel?.city(at: self.location) {
                gameModel?.userInterface?.showScreen(screenType: .city, city: city)
            }
            
        case .unitNeedsOrders:
            gameModel?.userInterface?.focus(on: self.location)
            
        default:
            print("activate \(self.type) not handled")
        }
    }
    
    public func dismiss(in gameModel: GameModel?) {
        print("dismiss: \(self.type)")
        self.dismissed = true
        gameModel?.userInterface?.remove(notification: self)
    }
    
    func expired(in gameModel: GameModel?) -> Bool {
        
        switch self.type {
            
        case .tech:
            guard let techs = self.player?.techs else {
                fatalError("cant get techs")
            }
            
            if !techs.needToChooseTech() {
                // already selected a tech
                return true
            }
            
            return false
            
        case .civic:
            guard let civics = self.player?.civics else {
                fatalError("cant get civics")
            }
            
            if !civics.needToChooseCivic() {
                // already selected a civic
                return true
            }
            
            return false
            
        default:
            return false
        }
    }
}

public class Notifications {
    
    let player: AbstractPlayer?
    var notificationsValue: [NotificationItem]
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        self.notificationsValue = []
    }
    
    public func update(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for notification in self.notificationsValue {
            
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
    
        return self.notificationsValue
    }
    
    func add(type: NotificationType, for player: AbstractPlayer?, message: String, summary: String, at location: HexPoint = HexPoint.zero) {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if !player.isHuman() {
            // no notifications for ai player
            return
        }
        
        self.notificationsValue.append(NotificationItem(type: type, for: player, message: message, summary: summary, at: location))
    }
    
    func endTurnBlockingNotification() -> NotificationItem? {
        
        for notification in self.notificationsValue {
            
            if notification.dismissed {
                continue
            }
            
            // NOTIFICATION_DIPLO_VOTE
            
            // NOTIFICATION_PRODUCTION
            if notification.type == .production {
                return notification
            }
            
            // NOTIFICATION_POLICY
            if notification.type == .civic {
                return notification
            }
            
            // NOTIFICATION_FREE_POLICY
            
            // NOTIFICATION_TECH
            if notification.type == .tech {
                return notification
            }
            
            // NOTIFICATION_FREE_TECH
            
            // NOTIFICATION_FREE_GREAT_PERSON
        }
        
        return nil
    }
    
    // removing notifications at the end turns
    func cleanUp() {
        
    }
}
