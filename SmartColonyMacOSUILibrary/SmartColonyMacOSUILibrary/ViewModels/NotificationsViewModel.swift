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
    
    private var items: [NotificationItem] = []
    
    init() {
        
    }
    
#if DEBUG
    init(items: [NotificationItem]) {
        
        self.items = items
        
        self.rebuildNotifcations()
    }
#endif
    
    func add(notification: NotificationItem) {
        
        self.items.append(notification)

        self.rebuildNotifcations()
    }
    
    func remove(notification: NotificationItem) {
        
        self.items.removeAll(where: { $0 == notification })
        
        self.rebuildNotifcations()
    }
    
    private func rebuildNotifcations() {
        
        DispatchQueue.main.async {
            self.notificationViewModels = self.items.map {
                let viewModel = NotificationViewModel(item: $0)
                viewModel.delegate = self
                return viewModel
            }
        }
    }
}

extension NotificationsViewModel: NotificationViewModelDelegate {
    
    func clicked(on item: NotificationItem) {

        item.activate(in: self.gameEnvironment.game.value)
    }
}
