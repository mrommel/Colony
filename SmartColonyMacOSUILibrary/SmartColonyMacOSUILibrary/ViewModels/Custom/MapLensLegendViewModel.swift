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

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

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

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        self.items = self.mapLens.legendItems(in: gameModel)
            .map { item in
                MapLensLegendItemViewModel(
                    legendColor: item.color,
                    legendTitle: item.title
                )
            }
    }
}
