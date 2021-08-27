//
//  WonderBuiltPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.08.21.
//

import SwiftUI
import SmartAILibrary

class WonderBuiltPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var nameText: String

    weak var delegate: GameViewModelDelegate?

    init(wonderType: WonderType) {

        self.title = "Wonder built"
        self.nameText = "Your civilization has finished construction on \(wonderType)"
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
