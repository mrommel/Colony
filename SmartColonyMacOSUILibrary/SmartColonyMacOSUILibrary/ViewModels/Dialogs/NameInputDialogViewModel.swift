//
//  NameInputDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

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
    var confirm: String = "Rename"

    @Published
    var cancel: String = "Cancel"

    weak var delegate: GameViewModelDelegate?
    private var completion: NameCompletionBlock?

    init() {

        self.update(
            title: "title",
            summary: "summary",
            value: "value",
            confirm: "Rename",
            cancel: "Cancel",
            completion: nil
        )
    }

    func update(
        title: String,
        summary: String,
        value: String,
        confirm: String,
        cancel: String,
        completion: NameCompletionBlock?) {

        self.title = title
        self.summary = summary
        self.value = value
        self.confirm = confirm
        self.cancel = cancel
        self.completion = completion
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }

    func closeAndFoundDialog() {

        self.delegate?.closeDialog()
        self.completion?(self.value)
    }
}
