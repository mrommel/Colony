//
//  CivicDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary

class CivicDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var civicGridViewModels: [CivicViewModel] = []

    @Published
    var civicListViewModels: [CivicViewModel] = []

    weak var delegate: GameViewModelDelegate?

    init(game: GameModel? = nil) {

        self.update(game: game)
    }

    func update(game: GameModel? = nil) {

        var gameRef: GameModel? = game

        if gameRef == nil {
            gameRef = self.gameEnvironment.game.value
        }

        self.rebuildCivics(for: gameRef)
    }

    private func rebuildCivics(for game: GameModel?) {

        guard let civics = game?.humanPlayer()?.civics else {
            return
        }

        var tmpCivicViewModels: [CivicViewModel] = []

        let possibleCivics: [CivicType] = civics.possibleCivics()

        self.civicListViewModels = possibleCivics.map { civicType in

            var turns = -1
            if civics.lastCultureInput() > 0.0 {
                let cost: Double = Double(civicType.cost())
                turns = Int(cost / civics.lastCultureInput() + 0.5)
            }

            let civicViewModel = CivicViewModel(
                civicType: civicType,
                state: .possible,
                boosted: civics.inspirationTriggered(for: civicType),
                turns: turns
            )
            civicViewModel.delegate = self
            return civicViewModel
        }

        for y in 0..<7 {
            for x in 0..<8 {

                if let civicType = CivicType.all.first(where: { $0.indexPath() == IndexPath(item: x, section: y) }) {

                    var state: CivicTypeState = .disabled
                    var turns: Int = -1

                    if civics.currentCivic() == civicType {
                        state = .selected
                        turns = civics.currentCultureTurnsRemaining()
                    } else if civics.has(civic: civicType) {
                        state = .researched
                    } else if possibleCivics.contains(civicType) {
                        state = .possible
                        if civics.lastCultureInput() > 0.0 {
                            let cost: Double = Double(civicType.cost())
                            turns = Int(cost / civics.lastCultureInput() + 0.5)
                        }
                    }

                    let civicViewModel = CivicViewModel(
                        civicType: civicType,
                        state: state,
                        boosted: civics.inspirationTriggered(for: civicType),
                        turns: turns
                    )
                    civicViewModel.delegate = self

                    tmpCivicViewModels.append(civicViewModel)
                } else {
                    let civicViewModel = CivicViewModel(
                        civicType: .none,
                        state: .disabled,
                        boosted: false,
                        turns: -1
                    )
                    tmpCivicViewModels.append(civicViewModel)
                }
            }
        }

        self.civicGridViewModels = tmpCivicViewModels
    }

    func openCivicTreeDialog() {

        self.delegate?.closeDialog()
        self.delegate?.showCivicTreeDialog()
    }
}

extension CivicDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}

extension CivicDialogViewModel: CivicViewModelDelegate {

    func selected(civic: CivicType) {

        let game = self.gameEnvironment.game.value

        guard let civics = game?.humanPlayer()?.civics else {
            fatalError("cant get civics")
        }

        let nothingSelected = civics.currentCivic() == nil

        do {
            try civics.setCurrent(civic: civic, in: game)

            self.rebuildCivics(for: game)
        } catch {
            print("cant select: \(civic)")
        }

        // close dialog, when user has selected a civic
        if nothingSelected {
            self.delegate?.closeDialog()
        }
    }
}
