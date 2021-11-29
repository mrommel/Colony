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

        items.forEach { item in
            self.add(notification: item)
        }
    }
#endif

    func add(notification: NotificationItem) {

        print("=== add notification: \(notification.type) ===")

        DispatchQueue.main.async {

            if let existingNotificationViewModel = self.notificationViewModels.first(
                where: { $0.type.sameType(as: notification.type) }
            ) {

                self.notificationViewModels.removeAll(where: { $0.type.sameType(as: notification.type) })
                var items = existingNotificationViewModel.items
                items.append(notification)

                let viewModel = NotificationViewModel(items: items)
                viewModel.delegate = self
                self.notificationViewModels.append(viewModel)

            } else {
                let viewModel = NotificationViewModel(items: [notification])
                viewModel.delegate = self
                self.notificationViewModels.append(viewModel)
            }
        }
    }

    func remove(notification: NotificationItem) {

        print("=== remove notification: \(notification.type) ===")

        DispatchQueue.main.async {

            if let existingNotificationViewModel = self.notificationViewModels.first(
                where: { $0.type.sameType(as: notification.type) }
            ) {

                self.notificationViewModels.removeAll(where: { $0.type.sameType(as: notification.type) })
                var items = existingNotificationViewModel.items

                items.removeAll(where: { $0.type == notification.type })

                if !items.isEmpty {
                    let viewModel = NotificationViewModel(items: items)
                    viewModel.delegate = self
                    self.notificationViewModels.append(viewModel)
                }
            }
        }
    }
}

extension NotificationsViewModel: NotificationViewModelDelegate {

    func clicked(on item: NotificationItem) {

        item.activate(in: self.gameEnvironment.game.value)
    }
}
