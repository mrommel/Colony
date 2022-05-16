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

    weak var delegate: UnitCommandViewModelDelegate?

    private var commandType: CommandType

    // MARK: constructors

    init() {

        self.commandType = .none
    }

    // MARK: methods

    func update(command commandType: CommandType) {

        self.commandType = commandType

        self.objectWillChange.send()
    }

    func toolTip() -> NSAttributedString? {

        guard commandType.title() != "" else {
            return nil
        }

        let toolTipText = NSMutableAttributedString(string: "")

        let title = NSAttributedString(
            string: commandType.title(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        /* let effects = NSAttributedString(
            string: "\n\nDescription \(Int.random(number: 10))",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)*/

        return toolTipText
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
