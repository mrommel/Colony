//
//  TechDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary

class TechDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var techGridViewModels: [TechViewModel] = []

    @Published
    var techListViewModels: [TechViewModel] = []

    weak var delegate: GameViewModelDelegate?

    init(game: GameModel? = nil) {

        self.update(game: game)
    }

    func update(game: GameModel? = nil) {

        var gameRef: GameModel? = game

        if gameRef == nil {
            gameRef = self.gameEnvironment.game.value
        }

        self.rebuildTechs(for: gameRef)
    }

    private func rebuildTechs(for game: GameModel?) {

        guard let techs = game?.humanPlayer()?.techs else {
            return
        }

        var tmpTechGridViewModels: [TechViewModel] = []

        let possibleTechs = techs.possibleTechs()

        self.techListViewModels = possibleTechs.map { techType in

            var turns = -1
            if techs.lastScienceEarned() > 0.0 {
                let cost: Double = Double(techType.cost())
                turns = Int(cost / techs.lastScienceEarned() + 0.5)
            }

            let techViewModel = TechViewModel(
                techType: techType,
                state: .possible,
                boosted: techs.eurekaTriggered(for: techType),
                turns: turns
            )
            techViewModel.delegate = self
            return techViewModel
        }

        // build grid
        for y in 0..<7 {
            for x in 0..<8 {

                if let techType = TechType.all.first(where: { $0.indexPath() == IndexPath(item: x, section: y) }) {

                    var state: TechTypeState = .disabled
                    var turns: Int = -1

                    if techs.currentTech() == techType {
                        state = .selected
                        turns = techs.currentScienceTurnsRemaining()
                    } else if techs.has(tech: techType) {
                        state = .researched
                    } else if possibleTechs.contains(techType) {
                        state = .possible
                        if techs.lastScienceEarned() > 0.0 {
                            let cost: Double = Double(techType.cost())
                            turns = Int(cost / techs.lastScienceEarned() + 0.5)
                        }
                    }

                    let techViewModel = TechViewModel(
                        techType: techType,
                        state: state,
                        boosted: techs.eurekaTriggered(for: techType),
                        turns: turns
                    )
                    techViewModel.delegate = self

                    tmpTechGridViewModels.append(techViewModel)
                } else {
                    let techViewModel = TechViewModel(
                        techType: .none,
                        state: .disabled,
                        boosted: false,
                        turns: -1
                    )
                    tmpTechGridViewModels.append(techViewModel)
                }
            }
        }

        self.techGridViewModels = tmpTechGridViewModels
    }

    func openTechTreeDialog() {

        self.delegate?.closeDialog()
        self.delegate?.showTechTreeDialog()
    }
}

extension TechDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}

extension TechDialogViewModel: TechViewModelDelegate {

    func selected(tech: TechType) {

        let game = self.gameEnvironment.game.value

        guard let techs = game?.humanPlayer()?.techs else {
            fatalError("cant get techs")
        }

        let nothingSelected = techs.currentTech() == nil

        do {
            try techs.setCurrent(tech: tech, in: game)

            self.rebuildTechs(for: game)
        } catch {
            print("cant select: \(tech)")
        }

        // close dialog, when user has selected a tech
        if nothingSelected {
            self.delegate?.closeDialog()
        }
    }
}
