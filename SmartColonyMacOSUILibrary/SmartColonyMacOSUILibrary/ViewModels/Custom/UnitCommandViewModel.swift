//
//  UnitCommandViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol UnitCommandViewModelDelegate: AnyObject {

    func clicked(on commandType: CommandType)
}

class UnitCommandViewModel: ObservableObject {

    @Published
    var toolTip: NSAttributedString

    weak var delegate: UnitCommandViewModelDelegate?

    private var commandType: CommandType

    // MARK: constructors

    init() {

        self.commandType = .none

        self.toolTip = NSAttributedString(string: "-")
    }

    // MARK: methods

    func update(command commandType: CommandType) {

        self.commandType = commandType

        let toolTipText = NSMutableAttributedString(string: "")

        let title = NSAttributedString(
            string: commandType.title(),
            attributes: [NSAttributedString.Key.font: Globals.Fonts.tooltipTitleFont]
        )
        toolTipText.append(title)

        let effects = NSAttributedString(string: "\n\ndummy content\(commandType)")
        toolTipText.append(effects)

        self.toolTip = toolTipText

        self.objectWillChange.send()
    }

    func image() -> NSImage {

        if self.commandType == .none {

            return NSImage()
        }

        return ImageCache.shared.image(for: self.commandType.buttonTexture())
    }

    func clicked() {

        self.delegate?.clicked(on: self.commandType)
    }
}
