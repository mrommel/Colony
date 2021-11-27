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

    private let items: [NotificationItem]

    weak var delegate: NotificationViewModelDelegate?

    init(items: [NotificationItem]) {

        self.items = items
        self.amount = items.count

        guard let firstItem = items.first else {
            fatalError("cant get first item")
        }

        let toolTopText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: firstItem.type.title(),
            attributes: [
                NSAttributedString.Key.font: Globals.Fonts.tooltipTitleFont,
                NSAttributedString.Key.foregroundColor: Globals.Colors.tooltipTitleColor
            ]
        )
        toolTopText.append(title)

        self.toolTip = toolTopText
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

        guard let firstItem = items.first else { // stepper
            fatalError("cant get first item")
        }

        self.delegate?.clicked(on: firstItem)
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
