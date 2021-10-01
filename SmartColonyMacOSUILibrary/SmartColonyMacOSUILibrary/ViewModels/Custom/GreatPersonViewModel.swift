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
    var typeName: String

    @Published
    var name: String

    @Published
    var eraName: String

    @Published
    var progress: CGFloat

    @Published
    var maxValue: CGFloat

    init(greatPerson: GreatPerson, progress: CGFloat, cost: CGFloat) {

        self.typeName = greatPerson.type().name()
        self.name = greatPerson.name()
        self.eraName = greatPerson.era().title()

        self.portraitTexture = ""

        self.progress = progress
        self.maxValue = cost
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
