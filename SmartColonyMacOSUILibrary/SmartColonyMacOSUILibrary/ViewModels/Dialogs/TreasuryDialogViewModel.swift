//
//  TreasuryDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.08.21.
//

import SwiftUI
import SmartAILibrary

class TreasuryDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var goldIncome: String

    @Published
    var goldFromCities: String

    @Published
    var goldFromDeals: String

    @Published
    var goldFromTradeRoutes: String

    @Published
    var goldExpenses: String

    @Published
    var goldForCityMaintenance: String

    @Published
    var goldForUnitMaintenance: String

    @Published
    var goldForDeals: String

    weak var delegate: GameViewModelDelegate?

    init() {

        // in
        self.goldIncome = "0.0"
        self.goldFromCities = "0.0"
        self.goldFromDeals = "0.0"
        self.goldFromTradeRoutes = "0.0"

        // out
        self.goldExpenses = "0.0"
        self.goldForCityMaintenance = "0.0"
        self.goldForUnitMaintenance = "0.0"
        self.goldForDeals = "0.0"
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let player = gameModel.humanPlayer() else {
            fatalError("can't get player")
        }

        guard let treasury = player.treasury else {
            fatalError("can't get treasury")
        }

        // in
        let cityIncome = treasury.goldFromCities(in: gameModel)
        let dealIncome = treasury.goldPerTurnFromDiplomacy(in: gameModel)
        let tradeRoutes = treasury.goldFromTradeRoutes(in: gameModel)
        let income = cityIncome + dealIncome + tradeRoutes

        self.goldIncome = String(format: "%.1f", income)
        self.goldFromCities = String(format: "%.1f", cityIncome)
        self.goldFromDeals = String(format: "%.1f", dealIncome)
        self.goldFromTradeRoutes = String(format: "%.1f", tradeRoutes)

        // out
        let cityMaintenance = treasury.goldForBuildingMaintenance(in: gameModel)
        let unitMaintenance = treasury.goldForUnitMaintenance(in: gameModel)
        let dealExpenses = treasury.goldPerTurnForDiplomacy(in: gameModel)
        let expenses = cityMaintenance + unitMaintenance + dealExpenses

        self.goldExpenses = String(format: "%.1f", expenses)
        self.goldForCityMaintenance = String(format: "%.1f", cityMaintenance)
        self.goldForUnitMaintenance = String(format: "%.1f", unitMaintenance)
        self.goldForDeals = String(format: "%.1f", dealExpenses)
    }

    func goldImage() -> NSImage {

        let imageSize = NSSize(width: 14, height: 14)

        guard let image = ImageCache.shared.image(for: "gold").resize(withSize: imageSize) else {
            return NSImage(size: imageSize)
        }

        return image
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
