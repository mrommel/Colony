//
//  UnitListDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.08.21.
//

import SwiftUI
import SmartAILibrary

class UnitListDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    weak var delegate: GameViewModelDelegate?

    @Published
    var unitViewModels: [UnitViewModel] = []

    init() {

    }

    func update(for player: AbstractPlayer) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        var tempUnitViewModels: [UnitViewModel] = []
        let units = gameModel.units(of: player)

        for unitRef in units {

            guard let unit = unitRef else {
                continue
            }

            let unitViewModel = UnitViewModel(unit: unit)
            unitViewModel.delegate = self
            tempUnitViewModels.append(unitViewModel)
        }

        self.unitViewModels = tempUnitViewModels
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}

extension UnitListDialogViewModel: UnitViewModelDelegate {

    func clicked(on unit: AbstractUnit?, at index: Int) {

        self.delegate?.closeDialog()
        self.delegate?.select(unit: unit)
    }

    func clicked(on unitType: UnitType, at index: Int) {

        fatalError("should not happen")
    }
}
