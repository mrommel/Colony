//
//  GreatPersonViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.10.21.
//

import SwiftUI
import SmartAILibrary

class GreatPersonViewModel: ObservableObject {

    let id: UUID = UUID()

    @Published
    var portraitTexture: String

    @Published
    var name: String

    init(greatPerson: GreatPerson) {

        self.name = greatPerson.name()
        self.portraitTexture = ""
    }

    func image() -> NSImage {

        return NSImage()
    }
}

extension GreatPersonViewModel: Hashable {

    static func == (lhs: GreatPersonViewModel, rhs: GreatPersonViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
