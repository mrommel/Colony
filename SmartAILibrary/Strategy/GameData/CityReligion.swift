//
//  CityReligion.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum ReligiousFollowChangeReasonType {

    case followerChangeHolyCity // FOLLOWER_CHANGE_HOLY_CITY
    case followerChangeAdoptFully // FOLLOWER_CHANGE_ADOPT_FULLY
    case followerChangeMissionary // FOLLOWER_CHANGE_MISSIONARY
    case followerChangeAdjacentPressure // FOLLOWER_CHANGE_ADJACENT_PRESSURE
}

public class ReligiousWeightList: WeightedList<ReligionType> {

    override func fill() {

        self.add(weight: 0.0, for: .atheism)

        for religionType in ReligionType.all {
            self.add(weight: 0.0, for: religionType)
        }
    }

    func removeZeroEntries() {

        self.items.removeAll(where: { item in
            item.weight == 0.0
        })
    }
}

public protocol AbstractCityReligion {

    // func turn(with gameModel: GameModel?)

    // func pressurePerTurn(in gameModel: GameModel?) -> ReligiousWeightList

    func religiousMajority() -> ReligionType
    func numFollowers(following religion: ReligionType) -> Int
    func citizens() -> ReligiousWeightList

    func resetNumTradeRoutePressure()
    func isHolyCityAnyReligion() -> Bool
    func addHolyCityPressure(in gameModel: GameModel?)
    func religiousPressureModifier(for religionType: ReligionType) -> Int

    func addReligiousPressure(
        reason: ReligiousFollowChangeReasonType,
        pressure: Int,
        for religionType: ReligionType,
        in gameModel: GameModel?
    )

    func incrementNumTradeRouteConnections(by numTradeRoutes: Int, for religionType: ReligionType)
}

class ReligionInCity: Codable {

    enum CodingKeys: String, CodingKey {

        case religionType
        case foundedHere
        case followers
        case pressure
        case numTradeRoutesApplyingPressure
        case temp
    }

    var religionType: ReligionType
    var foundedHere: Bool
    var followers: Int
    var pressure: Int
    var numTradeRoutesApplyingPressure: Int
    var temp: Int

    init() {

        self.religionType = .none
        self.foundedHere = false
        self.followers = 0
        self.pressure = 0
        self.numTradeRoutesApplyingPressure = 0
        self.temp = 0
    }

    init(religionType: ReligionType, foundedHere: Bool, followers: Int, pressure: Int) {

        self.religionType = religionType
        self.foundedHere = foundedHere
        self.followers = followers
        self.pressure = pressure
        self.numTradeRoutesApplyingPressure = 0
        self.temp = 0
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.religionType = try container.decode(ReligionType.self, forKey: .religionType)
        self.foundedHere = try container.decode(Bool.self, forKey: .foundedHere)
        self.followers = try container.decode(Int.self, forKey: .followers)
        self.pressure = try container.decode(Int.self, forKey: .pressure)
        self.numTradeRoutesApplyingPressure = try container.decode(Int.self, forKey: .numTradeRoutesApplyingPressure)
        self.temp = try container.decode(Int.self, forKey: .temp)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.religionType, forKey: .religionType)
        try container.encode(self.foundedHere, forKey: .foundedHere)
        try container.encode(self.followers, forKey: .followers)
        try container.encode(self.pressure, forKey: .pressure)
        try container.encode(self.numTradeRoutesApplyingPressure, forKey: .numTradeRoutesApplyingPressure)
        try container.encode(self.temp, forKey: .temp)
    }
}

public class CityReligion: AbstractCityReligion, Codable {

    enum CodingKeys: String, CodingKey {

        case pressure
        case majorityCityReligion
        case religionStatus
    }

    var city: AbstractCity?
    let pressure: ReligiousWeightList
    var majorityCityReligion: ReligionType

    var religionStatus: [ReligionInCity]

    init(city: AbstractCity?) {

        self.city = city

        self.pressure = ReligiousWeightList()
        self.pressure.fill()

        self.majorityCityReligion = .atheism
        self.religionStatus = []
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.city = nil
        self.pressure = try container.decode(ReligiousWeightList.self, forKey: .pressure)

        self.majorityCityReligion = try container.decode(ReligionType.self, forKey: .majorityCityReligion)
        self.religionStatus = try container.decode([ReligionInCity].self, forKey: .religionStatus)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.pressure, forKey: .pressure)
        try container.encode(self.majorityCityReligion, forKey: .majorityCityReligion)
        try container.encode(self.religionStatus, forKey: .religionStatus)
    }

    // MARK: methods

    /*public func turn(with gameModel: GameModel?) {
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        // update pressure
        
        // Atheist pressure is 50 * population
        let atheismPressure: Double = 50.0 * Double(city.population())
        self.pressure.set(weight: atheismPressure, for: .atheism)
        
        let pressurePerTurnValue = self.pressurePerTurn(in: gameModel)
        
        for religionType in ReligionType.all {
            self.pressure.add(weight: pressurePerTurnValue.weight(of: religionType), for: religionType)
        }
        
        // find majority
        self.pressure.sort()
        if let bestReligion = self.pressure.items.first {
        
            if bestReligion.weight < self.pressure.totalWeights() / 2.0 {
                self.majorityCityReligion = .atheism
                return
            }
            
            if bestReligion.itemType != self.majorityCityReligion {
            
                // trigger event to user
                if city.player?.isHuman() ?? false {
                    gameModel?.userInterface?.showPopup(popupType: .religionAdopted, with: PopupData(religionType: self.majorityCityReligion, for: city.name))
                }
            }
            
            self.majorityReligion = bestReligion.itemType
        }
    }
    
    public func pressurePerTurn(in gameModel: GameModel?) -> ReligiousWeightList {
        
        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        let pressures: ReligiousWeightList = ReligiousWeightList()
        pressures.fill()
        
        for player in gameModel.players {
            for foreignCityRef in gameModel.cities(of: player) {
                
                guard let foreignCity = foreignCityRef else {
                    fatalError("cant get foreign city")
                }
                
                guard let foreignCityDistricts = foreignCity.districts else {
                    fatalError("cant get foreign city district")
                }
                
                guard foreignCity.location != city.location else {
                    // we dont want to process our city
                    continue
                }
                
                guard foreignCity.location.distance(to: city.location) <= 10 else {
                    // Religious pressure values for each city are calculated cumulatively for all other cities with Majority Religions within 10 tiles.
                    continue
                }
                
                guard let foreignCityDominantReligion = foreignCity.cityReligion?.dominantReligion() else {
                    fatalError("cant get majority religion of foreign city")
                }
                
                var pressure: Double = 0.0
                
                // No pressure if the city does not have a Majority Religion.
                if foreignCityDominantReligion == .atheism {
                    pressure = 0.0
                } else if foreignCityDistricts.has(district: .holySite) {
                    // +2 Pressure exerted by the Majority Religion of the city if it also has a Holy Site.
                    pressure = 2.0
                } else {
                    // +1 Pressure exerted by the Majority Religion of the city.
                    pressure = 1.0
                }
                
                // TODO: +4 Pressure exerted by the Majority Religion of the city if it is also the Holy City.
                
                pressures.add(weight: pressure, for: foreignCityDominantReligion)
            }
        }
        
        // trade routes
        
        return pressures
    }*/

    public func numFollowers(following religion: ReligionType) -> Int {

        guard let city = self.city else {
            fatalError("cant get city")
        }

        let sum: Double = self.pressure.totalWeights()

        if sum == 0.0 {
            return 0
        }

        let ratio: Double = self.pressure.weight(of: religion) / sum

        return Int((Double(city.population()) * ratio).rounded())
    }

    public func citizens() -> ReligiousWeightList {

        let citizensVal: ReligiousWeightList = ReligiousWeightList()

        for religionType in ReligionType.all {

            let citizen = self.numFollowers(following: religionType)
            if citizen > 0 {
                citizensVal.add(weight: citizen, for: religionType)
            }
        }

        citizensVal.removeZeroEntries()

        return citizensVal
    }

    /// Resets the number of trade routes pressuring a city
    public func resetNumTradeRoutePressure() {

        for religionInCityListIterator in self.religionStatus {

            religionInCityListIterator.numTradeRoutesApplyingPressure = 0
        }
    }

    /// Is this the holy city for any religion?
    public func isHolyCityAnyReligion() -> Bool {

        for religionInCityListIterator in self.religionStatus where religionInCityListIterator.foundedHere {

            return true
        }

        return false
    }

    public func religiousMajority() -> ReligionType {

        return self.majorityCityReligion
    }

    /// Add pressure to recruit followers to a religion
    public func addHolyCityPressure(in gameModel: GameModel?) {

        var recompute = false
        let oldMajorityReligion = self.religiousMajority()

        for religionInCityListIterator in self.religionStatus where religionInCityListIterator.foundedHere {

            var pressure = 150 /*GC.getGame().getGameSpeedInfo().getReligiousPressureAdjacentCity();*/
            pressure *= 5 /* GC.getRELIGION_PER_TURN_FOUNDING_CITY_PRESSURE();*/
            religionInCityListIterator.pressure += pressure

            // Found it, so we're done
            recompute = true
        }

        // Didn't find it, add new entry
        if recompute {
            self.recomputeFollowers(reason: .followerChangeHolyCity, oldMajorityReligion: oldMajorityReligion, in: gameModel)
        }
    }

    public func religiousPressureModifier(for religionType: ReligionType) -> Int {

        return 0
    }

    /// Add pressure to recruit followers to a religion
    public func addReligiousPressure(reason: ReligiousFollowChangeReasonType, pressure: Int, for religionType: ReligionType, in gameModel: GameModel?) {

        var foundIt: Bool = false

        let oldMajorityReligion = self.religiousMajority()

        for status in self.religionStatus {

            if status.religionType == religionType {

                status.pressure += pressure
                foundIt = true

            } else if status.religionType == .pantheon {

                // If this is pressure from a real religion, reduce presence of pantheon by the same amount
                status.pressure = max(0, (status.pressure - pressure))

            } else if reason == .followerChangeMissionary {

                let pressureErosion = 0 // pReligion->m_Beliefs.GetOtherReligionPressureErosion();  // Normally 0
                if pressureErosion > 0 {
                    let erosionAmount = pressureErosion * pressure / 100
                    status.pressure = max(0, (status.pressure - erosionAmount))
                }
            }
        }

        // Didn't find it, add new entry
        if !foundIt {
            let newReligion = ReligionInCity(religionType: religionType, foundedHere: false, followers: 0, pressure: pressure)
            self.religionStatus.append(newReligion)
        }

        self.recomputeFollowers(reason: reason, oldMajorityReligion: oldMajorityReligion, in: gameModel)
    }

    /// Increment the number of trade connections a city has
    public func incrementNumTradeRouteConnections(by numTradeRoutes: Int, for religionType: ReligionType) {

        for status in self.religionStatus where status.religionType == religionType {

            status.numTradeRoutesApplyingPressure += numTradeRoutes
        }
    }

    /// Calculate the number of followers for each religion
    private func recomputeFollowers(reason: ReligiousFollowChangeReasonType, oldMajorityReligion: ReligionType/*, PlayerTypes eResponsibleParty*/, in gameModel: GameModel?) {

        guard let city = self.city else {
            fatalError("cant get city")
        }

        let oldFollowers = self.numFollowers(following: oldMajorityReligion)
        var unassignedFollowers: Int = self.city?.population() ?? 0
        var pressurePerFollower: Int = 0

        // Safety check to avoid divide by zero
        if unassignedFollowers < 1 {
            fatalError("Invalid city population when recomputing followers")
            return
        }

        // Find total pressure
        var totalPressure = 0
        for religionInCityListIterator in self.religionStatus {

            totalPressure += religionInCityListIterator.pressure
        }

        // safety check - if pressure was wiped out somehow, just rebuild pressure of 1 atheist
        if totalPressure <= 0 {

            let religion = ReligionInCity()

            religion.foundedHere = false
            religion.religionType = .none

            for religionInCityListIterator in self.religionStatus where religionInCityListIterator.foundedHere {

                religion.foundedHere = true
                religion.religionType = religionInCityListIterator.religionType
                break
            }

            self.religionStatus.removeAll()

            if reason == .followerChangeAdoptFully {
                religion.followers = 0
                religion.pressure = 0
            } else {
                religion.followers = 1
                religion.pressure = 100 // GC.getRELIGION_ATHEISM_PRESSURE_PER_POP();
            }

            self.religionStatus.append(religion)

            totalPressure = 100 // GC.getRELIGION_ATHEISM_PRESSURE_PER_POP();
        }

        pressurePerFollower = totalPressure / unassignedFollowers

        // Loop through each religion
        for religionInCityListIterator in self.religionStatus {

            religionInCityListIterator.followers = religionInCityListIterator.pressure / pressurePerFollower
            unassignedFollowers -= religionInCityListIterator.followers
            religionInCityListIterator.temp = religionInCityListIterator.pressure - (religionInCityListIterator.followers * pressurePerFollower)  // Remainder
        }

        // Assign out the remainder
        for unassignedFollower in 0..<unassignedFollowers {

            var itLargestRemainder: ReligionInCity = ReligionInCity()
            var largestRemainder: Int = 0

            for religionInCityListIterator in self.religionStatus where religionInCityListIterator.temp > largestRemainder {

                largestRemainder = religionInCityListIterator.temp
                itLargestRemainder = religionInCityListIterator
            }

            if largestRemainder > 0 {
                itLargestRemainder.followers += 1
                itLargestRemainder.temp = 0
            }
        }

        self.computeReligiousMajority(notifications: true, in: gameModel)

        let majority = self.religiousMajority()
        let followers = self.numFollowers(following: majority)

        if majority != oldMajorityReligion || followers != oldFollowers {

            // CityConvertsReligion(eMajority, eOldMajorityReligion, eResponsibleParty);
            // trigger event to user
            if city.player?.isHuman() ?? false {

                gameModel?.userInterface?.showPopup(popupType: .religionByCityAdopted(religion: self.majorityCityReligion, location: city.location))
            }

            // GC.GetEngineUserInterface()->setDirty(CityInfo_DIRTY_BIT, true);
            // LogFollowersChange(eReason);
        }
    }

    @discardableResult
    private func computeReligiousMajority(notifications: Bool, in gameModel: GameModel?) -> Bool {

        var totalFollowers: Int = 0
        var mostFollowerPressure: Int = 0
        var mostFollowers: Int = -1
        var mostFollowersType: ReligionType = .none
        // ReligionInCityList::iterator religionIt;

        for religionIt in self.religionStatus {

            totalFollowers += religionIt.followers

            if religionIt.followers > mostFollowers || religionIt.followers == mostFollowers && religionIt.pressure > mostFollowerPressure {

                mostFollowers = religionIt.followers
                mostFollowerPressure = religionIt.pressure
                mostFollowersType = religionIt.religionType
            }
        }

        // update local majority
        let oldMajority: ReligionType = self.majorityCityReligion

        self.majorityCityReligion = (mostFollowers * 2 >= totalFollowers) ? mostFollowersType : .none

        // update player majority
        if self.majorityCityReligion != oldMajority {

            //m_pMajorityReligionCached = NULL; //reset this
            self.city?.player?.religion?.computeMajority(notifications: notifications, in: gameModel)
        }

        return self.majorityCityReligion != .none
    }
}
