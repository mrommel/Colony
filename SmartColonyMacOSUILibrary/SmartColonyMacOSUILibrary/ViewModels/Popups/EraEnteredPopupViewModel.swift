//
//  EraEnteredPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary

class EraEnteredPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var summaryText: String

    private var eraType: EraType = .none

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "New Era started"
        self.summaryText = "The World has entered a new Era"
    }

    func update(for eraType: EraType) {

        self.eraType = eraType
        self.summaryText = "The World has entered the \(eraType) Era"
    }

    func closePopup() {

        self.delegate?.closePopup()
        self.delegate?.showSelectDedicationDialog()
    }
}
