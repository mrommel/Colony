//
//  MapLensLegendViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 07.12.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

public class MapLensLegendViewModel: ObservableObject {

    @Published
    var items: [MapLensLegendItemViewModel]

    var mapLens: MapLensType {
        didSet {
            self.updateItems()
        }
    }

    init() {

        self.mapLens = .none
        self.items = []
    }

    private func updateItems() {

        self.items = self.mapLens.legendItems()
            .map { item in
                MapLensLegendItemViewModel(
                    textureName: item.textureName,
                    legend: item.title
                )
            }
    }
}
