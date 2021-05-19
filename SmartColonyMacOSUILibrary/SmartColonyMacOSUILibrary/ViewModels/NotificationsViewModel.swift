//
//  NotificationsViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary

struct NotificationInfo {
    
    let type: NotificationType
    let location: HexPoint
}

class NotificationsViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    weak var delegate: GameViewModelDelegate?
    
    var types: [NotificationInfo] = []
    
    init() {
        
    }
    
#if DEBUG
    init(types: [NotificationInfo]) {
        
        self.types = types
        
        self.rebuildNotifcations()
    }
#endif
    
    @Published
    var notificationViewModels: [NotificationViewModel] = []
    
    func add(notification: NotificationItem) {
        
        self.types.append(NotificationInfo(type: notification.type, location: notification.location))

        self.rebuildNotifcations()
    }
    
    func remove(notification: NotificationItem) {
        
        self.types.removeAll(where: { $0.type == notification.type })
        
        self.rebuildNotifcations()
    }
    
    private func rebuildNotifcations() {
        
        DispatchQueue.main.async {
            self.notificationViewModels = self.types.map {
                let viewModel = NotificationViewModel(type: $0.type, location: $0.location)
                viewModel.delegate = self
                return viewModel
            }
        }
    }
}

extension NotificationsViewModel: NotificationViewModelDelegate {
    
    func clicked(type: NotificationType, location: HexPoint) {
        
        print("clicked: \(type)")
        
        if type == .techNeeded {
            self.delegate?.showChangeTechDialog()
            return
        } else if type == .civicNeeded {
            self.delegate?.showChangeCivicDialog()
            return
        } else if type == .productionNeeded {
            
            guard let game = self.gameEnvironment.game.value else {
                fatalError("cant get game")
            }
            
            guard let city = game.city(at: location) else {
                fatalError("no game at \(location)")
            }
            
            self.delegate?.showCityDialog(for: city)
            return
        } else if type == .policiesNeeded {
            self.delegate?.showChangePoliciesDialog()
            return
        } /*else if type == .unitPromotion {
            self.handleUnitPromotion(at: self.turnButtonNotificationLocation)
            return
        } */else {
            print("--- unhandled notification type: \(type)")
        }
    }
}
