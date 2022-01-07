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
    func foundPantheon(with pantheonType: PantheonType, in gameModel: GameModel?)

    @discardableResult
    func computeMajority(notifications: Bool, in gameModel: GameModel?) -> Bool
    func canAffordFaithPurchase(with faith: Double, in gameModel: GameModel?) -> Bool

    func isEnhanced() -> Bool

    func currentReligion() -> ReligionType
    func religionInMostCities() -> ReligionType
    func found(religion religionType: ReligionType, at city: AbstractCity?, in gameModel: GameModel?)
    func holyCityLocation() -> HexPoint

    // beliefs
    func hasSelected(beliefType: BeliefMainType) -> Bool
    func select(founderBelief: BeliefType)
    func select(followerBelief: BeliefType)
    func spreadDistanceModifier() -> Int
}

class PlayerReligion: AbstractPlayerReligion {

    enum CodingKeys: CodingKey {

        case faith
        case pantheon
        case religionFounded
        case founderBelief
        case followerBelief
        case worshipBelief
        case enhancerBelief
        case majorityPlayerReligion
        case holyCityLocation
    }

    // user properties / values
    var player: AbstractPlayer?

    var faithVal: Double
    var pantheonVal: PantheonType
    var religionFounded: ReligionType
    var founderBeliefVal: BeliefType
    var followerBeliefVal: BeliefType
    var worshipBeliefVal: BeliefType
    var enhancerBeliefVal: BeliefType
    var majorityPlayerReligion: ReligionType
    var holyCityLocationVal: HexPoint

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.faithVal = 0.0
        self.pantheonVal = .none
        self.religionFounded = .none
        self.founderBeliefVal = .none
        self.followerBeliefVal = .none
        self.worshipBeliefVal = .none
        self.enhancerBeliefVal = .none
        self.majorityPlayerReligion = .none
        self.holyCityLocationVal = .invalid
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.faithVal = try container.decode(Double.self, forKey: .faith)
        self.pantheonVal = try container.decode(PantheonType.self, forKey: .pantheon)
        self.religionFounded = try container.decode(ReligionType.self, forKey: .religionFounded)
        self.founderBeliefVal = try container.decode(BeliefType.self, forKey: .founderBelief)
        self.followerBeliefVal = try container.decode(BeliefType.self, forKey: .followerBelief)
        self.worshipBeliefVal = try container.decode(BeliefType.self, forKey: .worshipBelief)
        self.enhancerBeliefVal = try container.decode(BeliefType.self, forKey: .enhancerBelief)
        self.majorityPlayerReligion = try container.decode(ReligionType.self, forKey: .majorityPlayerReligion)
        self.holyCityLocationVal = try container.decode(HexPoint.self, forKey: .holyCityLocation)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.faithVal, forKey: .faith)
        try container.encode(self.pantheonVal, forKey: .pantheon)
        try container.encode(self.religionFounded, forKey: .religionFounded)
        try container.encode(self.founderBeliefVal, forKey: .founderBelief)
        try container.encode(self.followerBeliefVal, forKey: .followerBelief)
        try container.encode(self.worshipBeliefVal, forKey: .worshipBelief)
        try container.encode(self.enhancerBeliefVal, forKey: .enhancerBelief)
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

        if gameModel.availablePantheons().isEmpty {
            return .noPantheonAvailable
        }

        return .okay
    }

    func foundPantheon(with pantheonType: PantheonType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let civics = self.player?.civics else {
            fatalError("cant get civics")
        }

        let numPantheonsFounded: Int = gameModel.religions()
            .count(where: { $0?.pantheon() != PantheonType.none })
        if numPantheonsFounded == 0 {
            self.player?.addMoment(of: .worldsFirstPantheon, in: gameModel.currentTurn)
        }

        self.pantheonVal = pantheonType

        if !civics.eurekaTriggered(for: .mysticism) {
            civics.triggerEureka(for: .mysticism, in: gameModel)
        }
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

        return self.worshipBeliefVal != .none || self.enhancerBeliefVal != .none
    }

    func currentReligion() -> ReligionType {

        return self.religionFounded
    }

    func religionInMostCities() -> ReligionType {

        return self.majorityPlayerReligion
    }

    func found(religion religionType: ReligionType, at cityRef: AbstractCity?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let city = cityRef else {
            fatalError("cant get religion found city")
        }

        let numReligionsFounded: Int = gameModel.religions()
            .count(where: { $0?.currentReligion() != ReligionType.none })
        if numReligionsFounded == 0 {
            self.player?.addMoment(of: .worldsFirstReligion, in: gameModel.currentTurn)
        }

        self.religionFounded = religionType
        self.holyCityLocationVal = city.location
    }

    func hasSelected(beliefType: BeliefMainType) -> Bool {

        switch beliefType {

        case .followerBelief:
            return self.followerBeliefVal != .none
        case .worshipBelief:
            return self.worshipBeliefVal != .none
        case .founderBelief:
            return self.founderBeliefVal != .none
        case .enhancerBelief:
            return self.enhancerBeliefVal != .none
        }
    }

    func select(founderBelief: BeliefType) {

        self.founderBeliefVal = founderBelief
    }

    func select(followerBelief: BeliefType) {

        self.followerBeliefVal = followerBelief
    }

    func has(belief beliefType: BeliefType) -> Bool {

        return self.founderBeliefVal == beliefType ||
            self.followerBeliefVal == beliefType ||
            self.worshipBeliefVal == beliefType ||
            self.enhancerBeliefVal == beliefType
    }
}

extension PlayerReligion {

    func spreadDistanceModifier() -> Int {

        // Religion spreads to cities 30% further away.
        if self.has(belief: .itinerantPreachers) {
            return 30
        }

        return 0
    }
}
