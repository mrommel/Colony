//
//  PromotionViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 31.08.21.
//

import Foundation

class PromotionViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    @Published
    var title: String

    @Published
    var state: PromotionState

    init() {

        self.title = "Promotion"
        self.state = .possible
    }
}

extension PromotionViewModel: Hashable {

    static func == (lhs: PromotionViewModel, rhs: PromotionViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
