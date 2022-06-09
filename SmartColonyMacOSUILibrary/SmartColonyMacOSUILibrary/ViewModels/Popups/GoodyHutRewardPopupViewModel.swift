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

        self.title = "TXT_KEY_GOODY_REWARD_RECEIVED_TITLE".localized()
        self.text = "TXT_KEY_GOODY_REWARD_RECEIVED_SUMMARY".localized()
    }

    func update(for goodyHutType: GoodyType, at location: HexPoint) {

        self.text = "TXT_KEY_GOODY_REWARD_RECEIVED_SUMMARY".localized() + " " + goodyHutType.effect().localized()
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
