//
//  NotificationDetailViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.11.21.
//

import SwiftUI

class NotificationDetailViewModel: ObservableObject {

    @Published
    var titleText: String

    @Published
    var selectedText: String

    @Published
    var selected: Int = 0

    @Published
    var pages: Int

    private let texts: [String]

    init(title: String, texts: [String]) {

        self.titleText = title
        self.texts = texts
        self.pages = texts.count
        self.selectedText = texts[0]
    }
}
