//
//  PantheonViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol PantheonViewModelDelegate: AnyObject {

    func selected(pantheon: PantheonType)
}

class PantheonViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    let pantheonType: PantheonType

    weak var delegate: PantheonViewModelDelegate?

    init(pantheonType: PantheonType) {

        self.pantheonType = pantheonType
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.pantheonType.iconTexture())
    }

    func name() -> String {

        return self.pantheonType.name().localized()
    }

    func summary() -> String {

        return self.pantheonType.bonus().localized()
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: "pantheon-background")
    }

    func selectPantheon() {

        self.delegate?.selected(pantheon: self.pantheonType)
    }
}
