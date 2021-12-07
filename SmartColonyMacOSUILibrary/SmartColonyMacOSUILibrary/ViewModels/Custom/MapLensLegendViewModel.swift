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
            self.items = self.mapLens.legendItems()
                .map { item in
                    MapLensLegendItemViewModel(textureName: item.textureName, legend: item.title)
                }
        }
    }

    init() {

        self.mapLens = .none
        self.items = []
    }
}
