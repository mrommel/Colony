//
//  NotificationViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary
import Cocoa
import SmartAssets

protocol NotificationViewModelDelegate: AnyObject {

    func clicked(on item: NotificationItem)
}

class NotificationViewModel: ObservableObject, Identifiable {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var toolTip: NSAttributedString

    @Published
    var amount: Int

    @Published
    var expanded: Bool

    @Published
    var detailViewModel: NotificationDetailViewModel

    let type: NotificationType
    let items: [NotificationItem]

    weak var delegate: NotificationViewModelDelegate?

    init(items: [NotificationItem]) {

        self.items = items
        self.amount = items.count
        self.expanded = false // items.count > 1

        guard let firstItem = items.first else {
            fatalError("cant get first item")
        }

        self.type = firstItem.type

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: firstItem.type.title(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        self.toolTip = toolTipText

        self.detailViewModel = NotificationDetailViewModel(title: "default", texts: ["default"])
    }

    func icon() -> NSImage {

        guard let firstItem = items.first else {
            fatalError("cant get first item")
        }

        return ImageCache.shared.image(for: firstItem.type.iconTexture())
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: "notification-bagde")
    }

    func click() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        guard humanPlayer.isActive() else {
            // only open dialog when human is active
            self.expanded = false
            return
        }

        // we need to expand the details
        self.expanded = !self.expanded

        if self.expanded {

            guard let gameModel = self.gameEnvironment.game.value else {
                fatalError("need to assign a valid game")
            }

            guard let firstItem = self.items.first else {
                fatalError("cant get first item")
            }

            self.detailViewModel = NotificationDetailViewModel(
                title: "\(items.count) \(firstItem.type.title())",
                texts: items.map { item in
                    item.type.message(in: gameModel)
                }
            )
            self.detailViewModel.delegate = self
        }
    }

    func equal(to item: NotificationItem) -> Bool {

        guard let firstItem = items.first else {
            fatalError("cant get first item")
        }

        return firstItem == item
    }
}

extension NotificationViewModel: Hashable {

    static func == (lhs: NotificationViewModel, rhs: NotificationViewModel) -> Bool {

        return lhs.items == rhs.items
    }

    func hash(into hasher: inout Hasher) {

        for item in self.items {

            hasher.combine(item.type)
        }
    }
}

extension NotificationViewModel: NotificationDetailViewModelDelegate {

    func clickedContent(with index: Int) {

        let item = self.items[index]

        self.delegate?.clicked(on: item)
    }
}
