//
//  TutorialsViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 30.06.22.
//

import SmartAssets

enum TutorialType {

    case foundFirstCity
    case gotoWar
}

protocol TutorialsViewModelDelegate: AnyObject {

    func started(tutorial: TutorialType)
    func canceled()
}

class TutorialsViewModel: ObservableObject {

    weak var delegate: TutorialsViewModelDelegate?

    init() {

    }

    func startFoundFirstCity() {

        self.delegate?.started(tutorial: .foundFirstCity)
    }

    func startGotoWar() {

        self.delegate?.started(tutorial: .gotoWar)
    }

    func cancel() {

        self.delegate?.canceled()
    }
}
