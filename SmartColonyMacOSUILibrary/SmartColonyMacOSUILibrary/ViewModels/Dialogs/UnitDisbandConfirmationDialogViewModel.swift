//
//  UnitDisbandConfirmationDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class UnitDisbandConfirmationDialogViewModel: ObservableObject {

    typealias CompletionBlock = (Bool) -> Void

    var completion: CompletionBlock?
    var unit: AbstractUnit?

    @Published
    var question: String

    @Published
    var unitName: String

    weak var delegate: GameViewModelDelegate?

    init() {

        self.question = "Do you really want to disband this "
        self.unitName = ""
    }

#if DEBUG
    init(unit: AbstractUnit?) {

        self.question = "Do you really want to disband this "
        if let unit = self.unit {
            self.unitName = unit.name()
        } else {
            self.unitName = ""
        }
    }
#endif

    func update(with unit: AbstractUnit?, completion: @escaping CompletionBlock) {

        self.unit = unit
        self.completion = completion

        if let unit = self.unit {
            self.unitName = unit.name()
        }
    }

    func closeDialog() {

        self.delegate?.closeDialog()
        self.completion?(false)
    }

    func closeDialogAndDisband() {

        self.delegate?.closeDialog()
        self.completion?(true)
    }
}
