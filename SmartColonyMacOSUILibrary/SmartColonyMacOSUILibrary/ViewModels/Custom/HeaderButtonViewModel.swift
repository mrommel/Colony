//
//  HeaderButtonViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAssets
import SwiftUITooltip

protocol HeaderButtonViewModelDelegate: AnyObject {

    func clicked(on type: HeaderButtonType)
}

class HeaderButtonViewModel: ObservableObject {

    let type: HeaderButtonType
    let toolTipSide: TooltipSide

    @Published
    var alert: Bool = false

    weak var delegate: HeaderButtonViewModelDelegate?

    init(type: HeaderButtonType, toolTipSide: TooltipSide) {

        self.type = type
        self.toolTipSide = toolTipSide
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.type.iconTexture())
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
            string: self.type.name().localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        return toolTipText
    }

    func clicked() {

        // print("clicked on header: \(self.type)")
        self.delegate?.clicked(on: self.type)
    }
}
