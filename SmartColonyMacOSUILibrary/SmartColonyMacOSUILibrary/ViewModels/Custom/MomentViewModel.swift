//
//  MomentViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.01.22.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class MomentViewModel: ObservableObject {

    public let id: UUID = UUID()

    @Published
    var title: String

    @Published
    var summary: String

    private let momentType: MomentType

    init(moment: Moment) {

        self.title = moment.type.name().localized()
        self.summary = moment.type.summary().localized()

        self.momentType = moment.type
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.momentType.iconTexture())
    }
}

extension MomentViewModel: Hashable {

    public static func == (lhs: MomentViewModel, rhs: MomentViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
