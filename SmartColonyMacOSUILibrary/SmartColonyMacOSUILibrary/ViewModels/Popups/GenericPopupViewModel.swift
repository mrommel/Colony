//
//  GenericPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 08.02.22.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class GenericPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var summary: String

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "-"
        self.summary = "-"
    }

    func update(with title: String, and summary: String) {

        self.title = title
        self.summary = summary
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
