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

    func startMovementExploration() {

        self.delegate?.started(tutorial: .movementAndExploration)
    }

    func startFoundFirstCity() {

        self.delegate?.started(tutorial: .foundFirstCity)
    }

    func startImprovingCity() {

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
