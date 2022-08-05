//
//  Tutorials.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 04.08.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public enum TutorialType: String, Codable {

    case none

    case movementAndExploration
    case foundFirstCity
    case improvingCity
    // trade routes?
    case combatAndConquest
    case basicDiplomacy
}

public enum Tutorials {

    // 1st tutorial
    public enum MovementAndExplorationTutorial {

        public static let userHasFinished: String = "MovementAndExplorationTutorial.userHasFinished"
        public static let tilesToDiscover: Int = 50
    }

    // 2nd tutorial
    public enum FoundFirstCityTutorial {

        public static let userHasFinished: String = "FoundFirstCityTutorial.userHasFinished"
        public static let citiesToFound: Int = 2
    }

    // 3rd tutorial
    public enum ImprovingCityTutorial {

        public static let userHasFinished: String = "ImprovingCityTutorial.userHasFinished"
        // public static let citiesToFound: Int = 2
    }

    // trade routes?

    // 4th tutorial
    public enum CombatAndConquestTutorial {

        public static let userHasFinished: String = "CombatAndConquestTutorial.userHasFinished"
        // public static let citiesToFound: Int = 2
    }

    // 5th tutorial
    public enum BasicDiplomacyTutorial {

        public static let userHasFinished: String = "BasicDiplomacyTutorial.userHasFinished"
        // public static let citiesToFound: Int = 2
    }
}
