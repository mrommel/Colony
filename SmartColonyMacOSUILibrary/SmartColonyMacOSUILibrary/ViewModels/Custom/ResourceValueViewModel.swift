//
//  ResourceValueViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.10.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ResourceValueViewModel: ObservableObject {

    let resourceType: ResourceType

    var value: Int {
        didSet {
            self.valueText = "\(self.value)"
        }
    }

    @Published
    var valueText: String

    var withBackground: Bool

    init(resourceType: ResourceType, initial value: Int, withBackground: Bool = true) {

        self.resourceType = resourceType
        self.value = value
        self.withBackground = withBackground

        self.valueText = "\(self.value)"
    }

    func iconImage() -> NSImage {

        return ImageCache.shared.image(for: self.resourceType.textureName())
    }
}

extension ResourceValueViewModel: Hashable {

    static func == (lhs: ResourceValueViewModel, rhs: ResourceValueViewModel) -> Bool {

        return lhs.resourceType == rhs.resourceType
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.resourceType)
    }
}
