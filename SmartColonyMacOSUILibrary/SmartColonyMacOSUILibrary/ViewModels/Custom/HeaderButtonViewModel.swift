//
//  HeaderButtonViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAssets

protocol HeaderButtonViewModelDelegate: AnyObject {

    func clicked(on type: HeaderButtonType)
}

class HeaderButtonViewModel: ObservableObject {

    let type: HeaderButtonType

    @Published
    var active: Bool = true

    @Published
    var alert: Bool = false

    weak var delegate: HeaderButtonViewModelDelegate?

    init(type: HeaderButtonType) {

        self.type = type
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.type.iconTexture(for: self.active))
    }

    func alertImage() -> NSImage {

        if self.alert {
            return ImageCache.shared.image(for: "header-alert")
        }

        return NSImage()
    }

    func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.type.name(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        return toolTipText
    }

    func clicked() {

        print("clicked on header: \(self.type)")
        self.delegate?.clicked(on: self.type)
    }
}
