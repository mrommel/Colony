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
    var notificationViewModels: [NotificationViewModel] = []
    
    weak var delegate: GameViewModelDelegate?
    
    init() {
        
        self.notificationViewModels = []
    }
    
#if DEBUG
    init(items: [NotificationItem]) {
        
        self.notificationViewModels = items.map {
            let viewModel = NotificationViewModel(item: $0)
            viewModel.delegate = self
            return viewModel
        }
    }
#endif
    
    func add(notification: NotificationItem) {
        
        print("=== add notification: \(notification.type) ===")
        
        DispatchQueue.main.async {
            let viewModel = NotificationViewModel(item: notification)
            viewModel.delegate = self
            self.notificationViewModels.append(viewModel)
        }
    }
    
    func remove(notification: NotificationItem) {
        
        print("=== remove notification: \(notification.type) ===")
        
        DispatchQueue.main.async {
            self.notificationViewModels.removeAll(where: { $0.equal(to: notification) })
        }
    }
}

extension NotificationsViewModel: NotificationViewModelDelegate {
    
    func clicked(on item: NotificationItem) {

        item.activate(in: self.gameEnvironment.game.value)
    }
}
