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

    func startCombatAndConquest() {

        self.delegate?.started(tutorial: .combatAndConquest)
    }

    func startBasicDiplomacy() {

        self.delegate?.started(tutorial: .basicDiplomacy)
    }

    func cancel() {

        self.delegate?.canceled()
    }
}
