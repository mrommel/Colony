//
//  NotificationViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SmartAILibrary
import Cocoa
import SmartAssets

protocol NotificationViewModelDelegate: AnyObject {

    func clicked(on item: NotificationItem)
}

class NotificationViewModel: ObservableObject, Identifiable {

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

        let toolTopText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: firstItem.type.title(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTopText.append(title)

        self.toolTip = toolTopText

        self.detailViewModel = NotificationDetailViewModel(
            title: "\(items.count) \(firstItem.type.title())",
            texts: items.map { item in
                item.type.title()
            }
        )
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

        // if there is only one item - we can directly open it
        if self.items.count == 1 {

            guard let firstItem = items.first else {
                fatalError("cant get first item")
            }

            self.delegate?.clicked(on: firstItem)
        } else {
            // otherwise we need to expand the details
            self.expanded = !self.expanded
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
