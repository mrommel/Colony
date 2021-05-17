//
//  NotificationsViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary

class NotificationsViewModel: ObservableObject {
    
    weak var delegate: GameViewModelDelegate?
    
    var types: [NotificationType] = []
    
    init() {
        
    }
    
#if DEBUG
    init(types: [NotificationType]) {
        
        self.types = types
        
        self.rebuildNotifcations()
    }
#endif
    
    @Published
    var notificationViewModels: [NotificationViewModel] = []
    
    func add(notification: NotificationItem) {
        
        self.types.append(notification.type)

        self.rebuildNotifcations()
    }
    
    func remove(notification: NotificationItem) {
        
        self.types.removeAll(where: { $0 == notification.type })
        
        self.rebuildNotifcations()
    }
    
    private func rebuildNotifcations() {
        
        DispatchQueue.main.async {
            self.notificationViewModels = self.types.map {
                let viewModel = NotificationViewModel(type: $0)
                viewModel.delegate = self
                return viewModel
            }
        }
    }
}

extension NotificationsViewModel: NotificationViewModelDelegate {
    
    func clicked(type: NotificationType) {
        
        print("clicked: \(type)")
        
        if type == .techNeeded {
            self.delegate?.showChangeTechDialog()
            return
        } else if type == .civicNeeded {
            self.delegate?.showChangeCivicDialog()
            return
        } /*else if type == .productionNeeded {
            self.handleProductionNeeded(at: self.turnButtonNotificationLocation)
            return
        } */else if type == .policiesNeeded {
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
