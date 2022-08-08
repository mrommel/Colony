//
//  TutorialsViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 30.06.22.
//

import SmartAssets
import SmartAILibrary

protocol TutorialsViewModelDelegate: AnyObject {

    func started(tutorial: TutorialType)
    func canceled()
}

class TutorialsViewModel: ObservableObject {

    weak var delegate: TutorialsViewModelDelegate?

    init() {

    }

    func canStartMovementExploration() -> Bool {

        return true // can always be started
    }

    func startMovementExploration() {

        guard self.canStartMovementExploration() else {
            return
        }

        self.delegate?.started(tutorial: .movementAndExploration)
    }

    func canStartFoundFirstCity() -> Bool {

        return UserDefaults.standard.bool(forKey: Tutorials.MovementAndExplorationTutorial.userHasFinished)
    }

    func startFoundFirstCity() {

        guard self.canStartFoundFirstCity() else {
            return
        }

        self.delegate?.started(tutorial: .foundFirstCity)
    }

    func canStartImprovingCity() -> Bool {

        return UserDefaults.standard.bool(forKey: Tutorials.FoundFirstCityTutorial.userHasFinished)
    }

    func startImprovingCity() {

        guard self.canStartImprovingCity() else {
            return
        }

        self.delegate?.started(tutorial: .improvingCity)
    }

    func canStartEstablishTradeRoute() -> Bool {

        return UserDefaults.standard.bool(forKey: Tutorials.ImprovingCityTutorial.userHasFinished)
    }

    func startEstablishTradeRoute() {

        guard self.canStartEstablishTradeRoute() else {
            return
        }

        self.delegate?.started(tutorial: .establishTradeRoute)
    }

    func canStartCombatAndConquest() -> Bool {

        return UserDefaults.standard.bool(forKey: Tutorials.EstablishTradeRouteTutorial.userHasFinished)
    }

    func startCombatAndConquest() {

        guard self.canStartCombatAndConquest() else {
            return
        }

        self.delegate?.started(tutorial: .combatAndConquest)
    }

    func canStartBasicDiplomacy() -> Bool {

        return UserDefaults.standard.bool(forKey: Tutorials.CombatAndConquestTutorial.userHasFinished)
    }

    func startBasicDiplomacy() {

        guard self.canStartBasicDiplomacy() else {
            return
        }

        self.delegate?.started(tutorial: .basicDiplomacy)
    }

    func cancel() {

        self.delegate?.canceled()
    }
}
