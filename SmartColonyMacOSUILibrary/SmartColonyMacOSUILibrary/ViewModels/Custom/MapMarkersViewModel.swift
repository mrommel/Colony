//
//  MapMarkersViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 29.04.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

protocol MapMarkersViewModelDelegate: AnyObject {

    func addMarkerClicked()
    func center(on location: HexPoint)
}

public class MapMarkersViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var items: [MapMarkerItemViewModel]

    weak var delegate: MapMarkersViewModelDelegate?

    init() {

        self.items = []
    }

    func updateMarkers() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        var tmpItems: [MapMarkerItemViewModel] = []

        for marker in humanPlayer.markers() {

            tmpItems.append(MapMarkerItemViewModel(marker: marker))
        }

        self.items = tmpItems
    }

    func addMarkerClicked() {

        self.delegate?.addMarkerClicked()
    }

    func clicked(on location: HexPoint) {

        self.delegate?.center(on: location)
    }
}
