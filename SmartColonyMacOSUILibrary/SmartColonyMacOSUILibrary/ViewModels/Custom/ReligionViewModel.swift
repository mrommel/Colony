//
//  ReligionViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.10.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol ReligionViewModelDelegate: AnyObject {

    func selected(religion: ReligionType)
}

class ReligionViewModel: ObservableObject {

    let id: UUID = UUID()

    @Published
    var iconTexture: String

    @Published
    var title: String

    weak var delegate: ReligionViewModelDelegate?
    private let religion: ReligionType

    init(religion: ReligionType) {

        self.religion = religion

        self.iconTexture = self.religion.iconTexture()
        self.title = self.religion.name()
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.iconTexture)
    }

    func selectReligion() {

        self.delegate?.selected(religion: self.religion)
    }
}

extension ReligionViewModel: Hashable {

    static func == (lhs: ReligionViewModel, rhs: ReligionViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
        // hasher.combine(self.religion)
    }
}
