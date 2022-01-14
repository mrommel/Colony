//
//  GoodyHutRewardPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary

class GoodyHutRewardPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var text: String

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "Received Goodies"
        self.text = "The people from a tribal village gave you a present."
    }

    func update(for goodyHutType: GoodyType, at location: HexPoint) {

        self.text = "The people from a tribal village gave you a present. \(goodyHutType.effect())"
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
