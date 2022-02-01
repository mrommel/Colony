//
//  AskYesNoAlertView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.05.21.
//
// https://github.com/davidbaraff/Debmate/blob/c32d5428d01fa9de2966b4044554adb5404b157c/Sources/Debmate/SwiftUI/AskYesNoView.swift

import Foundation
import SwiftUI

public struct AskYesNoAlertView<Content> : View where Content: View {

    @Binding
    var isPresented: Bool

    var autoConfirm: Bool
    let action: () -> Void
    let title: String
    let message: String?
    let yesText: String
    var content: Content

    public init(
        isPresented: Binding<Bool>,
        autoConfirm: Bool,
        action: @escaping () -> Void,
        title: String,
        message: String?,
        yesText: String,
        @ViewBuilder
        content: () -> Content
    ) {

        _isPresented = isPresented
        self.autoConfirm = autoConfirm
        self.action = action
        self.title = title
        self.message = message
        self.yesText = yesText
        self.content = content()
    }

    func runIfAutoconfirm() -> Bool {
        if autoConfirm {
            if isPresented {
                DispatchQueue.main.async {
                    self.action()
                    self.isPresented = false
                }
            }
            return true
        }
        return false
    }

    public var body: some View {
        ZStack {
            if runIfAutoconfirm() {
                content
            } else {
                content.alert(isPresented: self._isPresented) {
                    Alert(title: Text(title),
                          message: Text(message ?? ""),
                          primaryButton: .default(Text(yesText)) { self.action() },
                          secondaryButton: .cancel())
                }
            }
        }
    }
}

public extension View {
    /// Present a model "yes/no" alert dialog.
    /// - Parameters:
    ///   - isPresented: isPresented binding
    ///   - title: Title for alert
    ///   - message: optional message
    ///   - yesText: text for respoding "yes"
    ///   - noText: text for responding "no"
    ///   - autoConfirm: if true, acts as if yes was immediately chosen, does not display dialog
    ///   - action: action if yes button is clicked
    /// - Returns: some View.
    func askYesNo(isPresented: Binding<Bool>, title: String, message: String?,
                  yesText: String, noText: String = "Cancel", autoConfirm: Bool = false,
                  action: @escaping () -> Void) -> AskYesNoAlertView<Self> {
       AskYesNoAlertView(isPresented: isPresented,
                          autoConfirm: autoConfirm,
                          action: action,
                          title: title,
                          message: message,
                          yesText: yesText) {
                            self
        }
    }
}
