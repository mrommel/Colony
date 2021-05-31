//
//  PlayerReligion.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum PantheonFoundingType {
    
    case invalidPlayer
    case alreadyCreatedPantheon
    case notEnoughFaith
    case okay
    case religionEnhanced // FOUNDING_RELIGION_ENHANCED;
    case noPantheonAvailable // FOUNDING_NO_BELIEFS_AVAILABLE
}

public protocol AbstractPlayerReligion: AnyObject, Codable {
    
    var player: AbstractPlayer? { get set }
    
    func change(faith faithDelta: Double)
    func faith() -> Double
    
    // pantheon
    func pantheon() -> PantheonType
    func canCreatePantheon(checkFaithTotal: Bool, in gameModel: GameModel?) -> PantheonFoundingType
    func foundPantheon(with pantheonType: PantheonType)
    
    func computeMajority(notifications: Bool, in gameModel: GameModel?) -> Bool
    func canAffordFaithPurchase(with faith: Double, in gameModel: GameModel?) -> Bool
    
    func isEnhanced() -> Bool
    
    func currentReligion() -> ReligionType
    func religionInMostCities() -> ReligionType
    
    func holyCityLocation() -> HexPoint
    
    // belief effects
    func spreadDistanceModifier() -> Int
}

class PlayerReligion: AbstractPlayerReligion {
    
    enum CodingKeys: CodingKey {

        case faith
        case pantheon
        case religionFounded
        case belief0
        case belief1
        case belief2
        case belief3
        case majorityPlayerReligion
        case holyCityLocation
    }
    
    // user properties / values
    var player: AbstractPlayer?
    
    var faithVal: Double
    var pantheonVal: PantheonType
    var religionFounded: ReligionType
    var beliefVal0: BeliefType
    var beliefVal1: BeliefType
    var beliefVal2: BeliefType
    var beliefVal3: BeliefType
    var majorityPlayerReligion: ReligionType
    var holyCityLocationVal: HexPoint
    
    // MARK: constructor
    
    init(player: Player?) {
        
        self.player = player
        
        self.faithVal = 0.0
        self.pantheonVal = .none
        self.religionFounded = .none
        self.beliefVal0 = .none
        self.beliefVal1 = .none
        self.beliefVal2 = .none
        self.beliefVal3 = .none
        self.majorityPlayerReligion = .none
        self.holyCityLocationVal = .invalid
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.faithVal = try container.decode(Double.self, forKey: .faith)
        self.pantheonVal = try container.decode(PantheonType.self, forKey: .pantheon)
        self.religionFounded = try container.decode(ReligionType.self, forKey: .religionFounded)
        self.beliefVal0 = try container.decode(BeliefType.self, forKey: .belief0)
        self.beliefVal1 = try container.decode(BeliefType.self, forKey: .belief1)
        self.beliefVal2 = try container.decode(BeliefType.self, forKey: .belief2)
        self.beliefVal3 = try container.decode(BeliefType.self, forKey: .belief3)
        self.majorityPlayerReligion = try container.decode(ReligionType.self, forKey: .majorityPlayerReligion)
        self.holyCityLocationVal = try container.decode(HexPoint.self, forKey: .holyCityLocation)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.faithVal, forKey: .faith)
        try container.encode(self.pantheonVal, forKey: .pantheon)
        try container.encode(self.religionFounded, forKey: .religionFounded)
        try container.encode(self.beliefVal0, forKey: .belief0)
        try container.encode(self.beliefVal1, forKey: .belief1)
        try container.encode(self.beliefVal2, forKey: .belief2)
        try container.encode(self.beliefVal3, forKey: .belief3)
        try container.encode(self.majorityPlayerReligion, forKey: .majorityPlayerReligion)
        try container.encode(self.holyCityLocationVal, forKey: .holyCityLocation)
    }
    
    func change(faith faithDelta: Double) {
        
        self.faithVal += faithDelta
    }
    
    public func faith() -> Double {
        
        return self.faithVal
    }
    
    func pantheon() -> PantheonType {
        
        return self.pantheonVal
    }
    
    func canCreatePantheon(checkFaithTotal: Bool, in gameModel: GameModel?) -> PantheonFoundingType {
        
        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }
        
        let faith = self.faith()
        
        if self.hasCreatedPantheon() || self.hasCreatedReligion() {
            return .alreadyCreatedPantheon
        }
        
        if checkFaithTotal && faith < self.minimumFaithNextPantheon() {
            return .notEnoughFaith
        }
        
        // Has another religion been enhanced yet (and total number of religions/pantheons is equal to number of religions allowed)?
        var religionAlreadyEnhanced: Bool = false
        for religionRef in gameModel.religions() {
            
            guard let religion = religionRef else {
                continue
            }
            
            if religion.isEnhanced() {
                religionAlreadyEnhanced = true
            }
        }
        
        let maxActiveReligions: Int = gameModel.maxActiveReligions()
        if religionAlreadyEnhanced && gameModel.numPantheonsCreated() >= maxActiveReligions {
            return .religionEnhanced
        }

        if gameModel.availablePantheons().count == 0 {
            return .noPantheonAvailable
        }

        return .okay
    }
    
    func foundPantheon(with pantheonType: PantheonType) {
        
        self.pantheonVal = pantheonType
    }
    
    func hasCreatedPantheon() -> Bool {
        
        return self.pantheonVal != .none
    }
    
    func hasCreatedReligion() -> Bool {
        
        return self.religionFounded != .none
    }
    
    func minimumFaithNextPantheon() -> Double {
        
        return 25.0 // RELIGION_MIN_FAITH_FIRST_PANTHEON
    }
    
    func holyCityLocation() -> HexPoint {
        
        return self.holyCityLocationVal
    }
    
    /// What religion is followed in a majority of our cities?
    func computeMajority(notifications: Bool, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }
        
        for religionType in ReligionType.all {
            
            if self.hasReligionInMostCities(relitionType: religionType, in: gameModel) {
                
                // New state faith? Let's announce this.
                if notifications && self.majorityPlayerReligion != religionType && self.majorityPlayerReligion != .none {
                    
                    // Message slightly different for founder player
                    if humanPlayer.leader == self.player?.leader {
                        gameModel.userInterface?.showPopup(popupType: .religionNewMajority(religion: religionType))
                    }
                }
                
                self.majorityPlayerReligion = religionType
                return true
            }
        }
        
        self.majorityPlayerReligion = .none
        return false
    }
    
    /// Does this player have enough faith to buy a religious unit or building?
    func canAffordFaithPurchase(with faith: Double, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if let capital = gameModel.capital(of: player) {
            
            for unitType in UnitType.all {
                
                if player.canPurchaseInAnyCity(unit: unitType, with: .faith, in: gameModel) {
                    let cost = capital.faithPurchaseCost(of: unitType)
                    
                    if cost != 0 && faith > cost {
                        return true
                    }
                }
            }
            
            for buildingType in BuildingType.all {
                
                if player.canPurchaseInAnyCity(building: buildingType, with: .faith, in: gameModel) {
                    
                    let cost = capital.faithPurchaseCost(of: buildingType)
                    
                    if cost != 0 && faith > cost {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    /// Do a majority of this player's cities follow a specific religion?
    func hasReligionInMostCities(relitionType: ReligionType, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if relitionType == .none {
            return false
        }

        var numFollowingCities: Int = 0
        let numPlayerCities: Int = gameModel.cities(of: player).count
        
        for cityRef in gameModel.cities(of: player) {
            
            guard let city = cityRef else {
                continue
            }
            
            if city.cityReligion?.religiousMajority() == relitionType {
                numFollowingCities += 1
            }
        }

        // Need at least one
        if numFollowingCities <= 0 {
            return false
        }

        // Over half? Equal to make OCC/Venice possible.
        return numFollowingCities * 2 >= numPlayerCities
    }
    
    func isEnhanced() -> Bool {
        
        return self.beliefVal2 != .none || self.beliefVal3 != .none
    }
    
    func currentReligion() -> ReligionType {
        
        return self.religionFounded
    }
    
    func religionInMostCities() -> ReligionType {
        
        return self.majorityPlayerReligion
    }
}

extension PlayerReligion {
    
    func spreadDistanceModifier() -> Int {
        
        return 0
    }
}
