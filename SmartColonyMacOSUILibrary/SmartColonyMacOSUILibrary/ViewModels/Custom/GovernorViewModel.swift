//
//  GovernorViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.09.21.
//

import SwiftUI
import SmartAILibrary

class GovernorViewModel: ObservableObject {

    let id: UUID = UUID()

    @Published
    var name: String

    @Published
    var title: String

    @Published
    var appointed: Bool

    init(governor: Governor, appointed: Bool) {

        self.name = governor.type.name()
        self.title = governor.type.title()
        self.appointed = appointed
    }

    func image() -> NSImage {

        return NSImage() // FIXME
    }
}

extension GovernorViewModel: Hashable {

    static func == (lhs: GovernorViewModel, rhs: GovernorViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
