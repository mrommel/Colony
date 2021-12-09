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

    let legendColor: TypeColor
    let legendTitle: String

    init(legendColor: TypeColor, legendTitle: String) {

        self.legendColor = legendColor
        self.legendTitle = legendTitle
    }

    func image() -> NSImage {

        if !ImageCache.shared.exists(key: "tile") {

            let bundle = Bundle.init(for: Textures.self)
            let tileTexture = bundle.image(forResource: "tile")!
            ImageCache.shared.add(image: tileTexture, for: "tile")
            return tileTexture.tint(with: self.legendColor)
        }

        return ImageCache.shared.image(for: "tile")
            .tint(with: self.legendColor)
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
