//
//  Notifications.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class Notifications {
    
    let player: AbstractPlayer?
    var notifications: [Notification]
    
    public class Notification {
        
        public let type: NotificationType
        //let player: AbstractPlayer?
        let location: HexPoint
        public let message: String
        public let summary: String
        let turn: Int = -1 // which turn this event was created on
        var dismissed: Bool
        
        init(type: NotificationType, message: String, summary: String, at location: HexPoint) {
            
            self.type = type
            self.message = message
            self.summary = summary
            self.location = location
            
            self.dismissed = false
        }
        
        public func activate(in gameModel: GameModel?) {
            print("active: \(self.type)")
            
            if self.type == .unitNeedsOrders {
                gameModel?.userInterface?.focus(on: self.location)
            } else if self.type == .production {
                gameModel?.userInterface?.showScreen(screenType: .city)
            } else {
                print("activate \(self.type) not handled")
            }
        }
        
        public func dismiss() {
            print("dismiss: \(self.type)")
        }
        
        func expired() -> Bool {
            
            return false
        }
    }
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        self.notifications = []
    }
    
    public func update(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for notification in self.notifications {
            
            if !notification.dismissed {
                
                if notification.expired() {
                    notification.dismiss()
                } else {
                    gameModel.userInterface?.show(notification: notification)
                }
            }
        }
    }
    
    func add(type: NotificationType, message: String, summary: String, at location: HexPoint) {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if !player.isHuman() {
            // no notifications for ai player
            return
        }
        
        self.notifications.append(Notification(type: type, message: message, summary: summary, at: location))
    }
    
    func endTurnBlockingNotification() -> Notification? {
        
        for notification in self.notifications {
            
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
