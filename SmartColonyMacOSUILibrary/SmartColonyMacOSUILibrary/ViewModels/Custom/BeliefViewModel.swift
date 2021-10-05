//
//  BeliefViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.10.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol BeliefViewModelDelegate: AnyObject {

    func selected(belief: BeliefType)
}

class BeliefViewModel: ObservableObject {

    let id: UUID = UUID()

    @Published
    var iconTexture: String

    @Published
    var title: String

    @Published
    var effect: String

    weak var delegate: BeliefViewModelDelegate?
    private let belief: BeliefType

    init(belief: BeliefType) {

        self.belief = belief

        self.iconTexture = self.belief.iconTexture()
        self.title = belief.name()
        self.effect = belief.effect()
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.iconTexture)
    }

    func selectReligion() {

        self.delegate?.selected(belief: self.belief)
    }
}

extension BeliefViewModel: Hashable {

    static func == (lhs: BeliefViewModel, rhs: BeliefViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
        // hasher.combine(self.religion)
    }
}
