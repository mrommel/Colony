//
//  ConfirmationDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ConfirmationDialogViewModel: ObservableObject {

    typealias CompletionBlock = (Bool) -> Void

    var completion: CompletionBlock?

    @Published
    var title: String

    @Published
    var question: String

    @Published
    var okayText: String

    @Published
    var cancelText: String

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "Title"
        self.question = "Do you confirm?"
        self.okayText = "Okay"
        self.cancelText = "Cancel"
    }

#if DEBUG
    init(title: String, question: String, confirm: String, cancel: String) {

        self.title = title
        self.question = question
        self.okayText = confirm
        self.cancelText = cancel
    }
#endif

    func update(title: String, question: String, confirm: String, cancel: String, completion: @escaping CompletionBlock) {

        self.title = title
        self.question = question
        self.okayText = confirm
        self.cancelText = cancel

        self.completion = completion
    }

    func closeDialog() {

        self.delegate?.closeDialog()
        self.completion?(false)
    }

    func closeDialogAndComfirm() {

        self.delegate?.closeDialog()
        self.completion?(true)
    }
}
