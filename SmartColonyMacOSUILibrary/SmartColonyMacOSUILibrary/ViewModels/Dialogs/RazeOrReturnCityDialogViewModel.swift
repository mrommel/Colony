//
//  RazeOrReturnCityDialogViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 08.04.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

class RazeOrReturnCityDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var cityName: String

    @Published
    var cityPopulation: String

    @Published
    var canRazeCity: Bool

    @Published
    var canLiberateCity: Bool

    @Published
    var originalOwnerName: String

    weak var delegate: GameViewModelDelegate?

    private var cityRef: AbstractCity?

    init() {

        self.cityName = ""
        self.cityPopulation = "0"
        self.canRazeCity = false
        self.canLiberateCity = false
        self.originalOwnerName = ""
    }

    func update(for cityRef: AbstractCity?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard let city = cityRef else {
            fatalError("cant get city")
        }

        self.cityRef = cityRef

        self.cityName = city.name
        self.cityPopulation = "\(city.population())"
        self.originalOwnerName = city.originalLeader().civilization().name().localized()

        self.canRazeCity = humanPlayer.canRaze(city: city, ignoreCapitals: false, in: gameModel)
        self.canLiberateCity = humanPlayer.canLiberate(city: city, in: gameModel)
    }

    func keepCityClicked() {

        // NOOP
        self.delegate?.closeDialog()
    }

    func razeCityClicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        let razed = humanPlayer.doRaze(city: self.cityRef, in: gameModel)

        guard razed else {
            fatalError("raze was not successful")
        }

        self.delegate?.closeDialog()
    }

    func returnCityClicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        let liberated = humanPlayer.doLiberate(city: self.cityRef, forced: false, in: gameModel)

        guard liberated else {
            fatalError("liberate was not successful")
        }

        self.delegate?.closeDialog()
    }
}

extension RazeOrReturnCityDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
