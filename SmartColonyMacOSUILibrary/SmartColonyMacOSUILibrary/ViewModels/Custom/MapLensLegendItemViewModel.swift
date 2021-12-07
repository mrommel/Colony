//
//  MapLensLegendItemViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 07.12.21.
//

import SwiftUI
import SmartAssets

public class MapLensLegendItemViewModel: ObservableObject, Identifiable {

    public let id: UUID = UUID()

    let textureName: String
    let legend: String

    init(textureName: String, legend: String) {

        self.textureName = textureName
        self.legend = legend
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.textureName)
    }
}

extension MapLensLegendItemViewModel: Hashable {

    public static func == (lhs: MapLensLegendItemViewModel, rhs: MapLensLegendItemViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
