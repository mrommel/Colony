//
//  GovernmentCardViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol GovernmentCardViewModelDelegate: AnyObject {

    func update()
}

class GovernmentCardViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    // variables
    let governmentType: GovernmentType
    let state: GovernmentState

    weak var delegate: GovernmentCardViewModelDelegate?

    init(governmentType: GovernmentType, state: GovernmentState) {

        self.governmentType = governmentType
        self.state = state
    }

    func title() -> String {

        return self.governmentType.name().localized()
    }

    func bonus1Summary() -> String {

        return self.governmentType.bonus1Summary().localized()
    }

    func bonus2Summary() -> String {

        return self.governmentType.bonus2Summary().localized()
    }

    func cardImages() -> [NSImage] {

        let slotTypes = self.governmentType.policyCardSlots().types()

        return slotTypes.map { ImageCache.shared.image(for: $0.iconTexture()) }
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: self.state.backgroundTexture())
    }

    func ambient() -> NSImage {

        return ImageCache.shared.image(for: self.governmentType.ambientTexture()).crop(toSize: NSSize(width: 300, height: 100))!
    }
}

extension GovernmentCardViewModel: Hashable {

    static func == (lhs: GovernmentCardViewModel, rhs: GovernmentCardViewModel) -> Bool {

        return lhs.governmentType == rhs.governmentType && lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
        hasher.combine(self.governmentType)
    }
}
