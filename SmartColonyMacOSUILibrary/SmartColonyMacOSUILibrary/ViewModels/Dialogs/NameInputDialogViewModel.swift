//
//  NameInputDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class NameInputDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    typealias NameCompletionBlock = (String) -> Void

    @Published
    var title: String = "title"

    @Published
    var summary: String = "summary"

    @Published
    var value: String = "value"

    @Published
    var confirm: String = "TXT_KEY_RENAME".localized()

    @Published
    var cancel: String = "TXT_KEY_CANCEL".localized()

    weak var delegate: GameViewModelDelegate?
    private var completion: NameCompletionBlock?

    init() {

        self.update(
            title: "title",
            summary: "summary",
            value: "value",
            confirm: "TXT_KEY_RENAME".localized(),
            cancel: "TXT_KEY_CANCEL".localized(),
            completion: nil
        )
    }

    func update(
        title: String,
        summary: String,
        value: String,
        confirm: String,
        cancel: String = "TXT_KEY_CANCEL".localized(),
        completion: NameCompletionBlock?) {

        self.title = title
        self.summary = summary
        self.value = value.localized()
        self.confirm = confirm
        self.cancel = cancel
        self.completion = completion
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }

    func closeAndConfirmDialog() {

        self.delegate?.closeDialog()
        self.completion?(self.value)
    }
}
