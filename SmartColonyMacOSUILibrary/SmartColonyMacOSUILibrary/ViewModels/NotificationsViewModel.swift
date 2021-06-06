//
//  NotificationsViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary

class NotificationsViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var notificationViewModels: [NotificationViewModel]
    
    weak var delegate: GameViewModelDelegate?
    
    private var items: [NotificationItem]
    
    init() {
        
        self.items = []
        self.notificationViewModels = []
        
        self.rebuildNotifcations()
    }
    
#if DEBUG
    init(items: [NotificationItem]) {
        
        self.items = items
        self.notificationViewModels = []
        
        self.rebuildNotifcations()
    }
#endif
    
    func add(notification: NotificationItem) {
        
        print("=== add notification: \(notification.type) ===")
        if notification.type == .cityGrowth {
            print("debug")
        }
        
        self.items.append(notification)

        self.rebuildNotifcations()
    }
    
    func remove(notification: NotificationItem) {
        
        print("=== remove notification: \(notification.type) ===")
        
        self.items.removeAll(where: { $0 == notification })
        
        self.rebuildNotifcations()
    }
    
    private func rebuildNotifcations() {
        
        let newNotificationViewModels: [NotificationViewModel] = self.items.map {
            let viewModel = NotificationViewModel(item: $0)
            viewModel.delegate = self
            return viewModel
        }
        
        DispatchQueue.main.async {
            self.notificationViewModels = newNotificationViewModels
        }
    }
}

extension NotificationsViewModel: NotificationViewModelDelegate {
    
    func clicked(on item: NotificationItem) {

        item.activate(in: self.gameEnvironment.game.value)
    }
}
