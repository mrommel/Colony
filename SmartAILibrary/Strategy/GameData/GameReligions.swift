//
//  GameReligions.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractGameReligions {

    func doTurn(in gameModel: GameModel?)

    // pantheons
    func foundPantheon(for player: AbstractPlayer?, with pantheonType: PantheonType, in gameModel: GameModel?)

    func availablePantheons(in gameModel: GameModel?) -> [PantheonType]
    func numPantheonsCreated(in gameModel: GameModel?) -> Int

    // religions
    func availableReligions(in gameModel: GameModel?) -> [ReligionType]

    func religions(in gameModel: GameModel?) -> [AbstractPlayerReligion?]
    func religion(of type: ReligionType, for player: AbstractPlayer?) -> AbstractPlayerReligion?
}

class GameReligions: AbstractGameReligions, Codable {

    enum CodingKeys: String, CodingKey {

        case pressure
    }

    public init() {

    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        /*self.city = nil
        self.pressure = try container.decode(ReligiousWeightList.self, forKey: .pressure)
        self.majorityReligion = try container.decode(ReligionType.self, forKey: .majorityReligion)*/
        // fatalError("not implemented")
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        //try container.encode(self.pressure, forKey: .pressure)
        // fatalError("not implemented")
    }

    /// Handle turn-by-turn religious updates
    public func doTurn(in gameModel: GameModel?) {

        self.spreadReligion(in: gameModel)
    }

    func foundPantheon(for player: AbstractPlayer?, with pantheonType: PantheonType, in gameModel: GameModel?) {

        player?.religion?.foundPantheon(with: pantheonType, in: gameModel)
    }

    // MARK: religion methods

    func availableReligions(in gameModel: GameModel?) -> [ReligionType] {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        var availableReligionList: [ReligionType] = ReligionType.all

        for player in gameModel.players {

            guard let playerReligion = player.religion else {
                continue
            }

            availableReligionList.removeAll(where: { $0 == playerReligion.currentReligion() })
        }

        return availableReligionList
    }

    func religions(in gameModel: GameModel?) -> [AbstractPlayerReligion?] {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        var religionsArray: [AbstractPlayerReligion?] = []

        for player in gameModel.players {

            religionsArray.append(player.religion)
        }

        return religionsArray
    }

    func religion(of type: ReligionType, for player: AbstractPlayer?) -> AbstractPlayerReligion? {

        if player?.religion?.currentReligion() == type {
            return player?.religion
        }

        return nil
    }

    // MARK: private methods

    /// Spread religious pressure into adjacent cities
    private func spreadReligion(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        // Loop through all the players
        for player in gameModel.players {

            guard player.isAlive() && !player.isBarbarian() && !player.isFreeCity() else {
                continue
            }

            // Loop through each of their cities
            for cityRef in gameModel.cities(of: player) {

                self.spreadReligion(to: cityRef, in: gameModel)
            }
        }
    }

    /// Spread religious pressure to one city
    private func spreadReligion(to cityRef: AbstractCity?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let city = cityRef else {
            fatalError("cant get city ref")
        }

        // print("spread religion for \(city.name)")

        // Used to calculate how many trade routes are applying pressure to this city. This resets the value so we get a true count every turn.
        city.cityReligion?.resetNumTradeRoutePressure()

        // Is this a city where a religion was founded?
        if city.cityReligion?.isHolyCityAnyReligion() ?? false {
            city.cityReligion?.addHolyCityPressure(in: gameModel)
        }

        // Loop through all the players
        for player in gameModel.players {

            guard player.isAlive() && !player.isBarbarian() && !player.isFreeCity() else {
                continue
            }

            /* int iSpyPressure = kPlayer.GetReligions()->GetSpyPressure((PlayerTypes)iI);
             if (iSpyPressure > 0)
             {
                 if (kPlayer.GetEspionage()->GetSpyIndexInCity(pCity) != -1)
                 {
                     ReligionTypes eReligionFounded = kPlayer.GetReligions()->GetCurrentReligion(false);
                     if(eReligionFounded == NO_RELIGION)
                     {
                         eReligionFounded = kPlayer.GetReligions()->GetReligionInMostCities();
                     }
                     if(eReligionFounded != NO_RELIGION && eReligionFounded > RELIGION_PANTHEON)
                     {
                         pCity->GetCityReligions()->AddSpyPressure(eReligionFounded, iSpyPressure);
                     }
                 }
             }  */

            // Loop through each of their cities
            for loopCityRef in gameModel.cities(of: player) {

                guard let loopCity = loopCityRef else {
                    continue
                }

                // Ignore the same city
                guard city.location != loopCity.location else {
                    continue
                }

                guard let loopCityReligion = loopCity.cityReligion else {
                    continue
                }

                for religionType in ReligionType.all {

                    guard self.isValidTarget(for: religionType, fromCity: loopCity, toCity: city) else {
                        continue
                    }

                    if loopCityReligion.numFollowers(following: religionType) > 0 {

                        var connectedWithTrade = false
                        var relativeDistancePercent = 0

                        if !self.isConnected(
                            by: religionType,
                            from: loopCity,
                            to: city,
                            withTrade: &connectedWithTrade,
                            percent: &relativeDistancePercent,
                            in: gameModel) {

                            continue
                        }

                        let (pressure, numTradeRoutes) = self.adjacentCityReligiousPressure(
                            for: religionType,
                            from: loopCity,
                            to: city,
                            actualValue: true,
                            pretendTradeConnection: false,
                            connectedWithTrade: connectedWithTrade,
                            relativeDistancePercent: relativeDistancePercent
                        )

                        if pressure > 0 {
                            city.cityReligion?.addReligiousPressure(
                                reason: .followerChangeAdjacentPressure,
                                pressure: pressure,
                                for: religionType,
                                in: gameModel
                            )

                            if numTradeRoutes > 0 {
                                city.cityReligion?.incrementNumTradeRouteConnections(by: numTradeRoutes, for: religionType)
                            }
                        }
                    }
                }
            }
        }
    }

    /// How much pressure is exerted between these cities?
    private func adjacentCityReligiousPressure(
        for religionType: ReligionType,
        from fromCityRef: AbstractCity?,
        to toCityRef: AbstractCity?,
        actualValue: Bool,
        pretendTradeConnection: Bool,
        connectedWithTrade: Bool,
        relativeDistancePercent: Int) -> (Int, Int) {

        guard let fromCity = fromCityRef else {
            fatalError("cant get from city")
        }

        guard let fromCityReligion = fromCity.cityReligion else {
            fatalError("cant get from city religion")
        }

        guard let toCity = toCityRef else {
            fatalError("cant get to city")
        }

        var numTradeRoutesInfluencing = 0

        guard self.religion(of: religionType, for: fromCity.player) != nil else {
            return (0, 0)
        }

        var basePressure = 150 // ReligiousPressureAdjacentCity
        var pressureMod = 0

        // Does this city have a majority religion?
        let majorityReligion = fromCity.cityReligion?.religiousMajority()
        if majorityReligion != religionType {
            return (0, 0)
        }

        // do we have a trade route or pretend to have one
        if connectedWithTrade || pretendTradeConnection {

            if actualValue {
                numTradeRoutesInfluencing += 1
            }

            var tradeReligionModifer = 50 // GET_PLAYER(pFromCity->getOwner()).GetPlayerTraits()->GetTradeReligionModifier();
            tradeReligionModifer += 0 // GET_PLAYER(pFromCity->getOwner()).GetTradeReligionModifier();
            tradeReligionModifer += fromCity.religiousTradeRouteModifier()

            pressureMod += tradeReligionModifer
        } else {

            // if there is no traderoute, base pressure falls off with distance
            let pressurePercent = max(100 - relativeDistancePercent, 1)
            // make the scaling quadratic - four times as many cities in range if we double the radius!
            basePressure = (basePressure * pressurePercent * pressurePercent) / (100 * 100)
        }

        // Building that boosts pressure from originating city?
        pressureMod += fromCityReligion.religiousPressureModifier(for: religionType)

        let pressure = basePressure * (100 + pressureMod)

        print("AdjacentCityReligiousPressure for \(religionType) from \(fromCity.name) to \(toCity.name) is \(pressure)")
        return (max(0, pressure / 100), numTradeRoutesInfluencing)
}

    func isValidTarget(for religionType: ReligionType, fromCity fromCityRef: AbstractCity?, toCity toCityRef: AbstractCity?) -> Bool {

        guard let fromCity = fromCityRef else {
            fatalError("cant get from city")
        }

        guard let toCity = toCityRef else {
            fatalError("cant get to city")
        }

        if fromCity.player?.leader != toCity.player?.leader {

            /*if fromCity.player.is (GET_PLAYER(pFromCity->getOwner()).GetPlayerTraits()->IsNoNaturalReligionSpread())
                {
                    ReligionTypes ePantheon = GET_PLAYER(pFromCity->getOwner()).GetReligions()->GetReligionCreatedByPlayer(true);
                    const CvReligion* pReligion2 = GetReligion(ePantheon, pFromCity->getOwner());
                    if (pReligion2 && (pFromCity->GetCityReligions()->GetNumFollowers(ePantheon) > 0) && pReligion2->m_Beliefs.GetUniqueCiv() == GET_PLAYER(pFromCity->getOwner()).getCivilizationType())
                    {
                        return false;
                    }
                }
            */

            /*if (GET_PLAYER(pToCity->getOwner()).GetPlayerTraits()->IsNoNaturalReligionSpread())
                {
                    ReligionTypes ePantheon = GET_PLAYER(pToCity->getOwner()).GetReligions()->GetReligionCreatedByPlayer(true);
                    const CvReligion* pReligion2 = GetReligion(ePantheon, pToCity->getOwner());
                    if (pReligion2 && (pToCity->GetCityReligions()->GetNumFollowers(ePantheon) > 0) && pReligion2->m_Beliefs.GetUniqueCiv() == GET_PLAYER(pToCity->getOwner()).getCivilizationType())
                    {
                        return false;
                    }
                }*/
        } else { // if (pFromCity->getOwner() == pToCity->getOwner())

            /*if (GET_PLAYER(pFromCity->getOwner()).GetPlayerTraits()->IsNoNaturalReligionSpread())
            {
                ReligionTypes ePantheon = GET_PLAYER(pFromCity->getOwner()).GetReligions()->GetReligionCreatedByPlayer(true);
                const CvReligion* pReligion2 = GetReligion(ePantheon, pFromCity->getOwner());
                if (ePantheon != eReligion && pReligion2 && (pFromCity->GetCityReligions()->GetNumFollowers(ePantheon) > 0) && pReligion2->m_Beliefs.GetUniqueCiv() == GET_PLAYER(pFromCity->getOwner()).getCivilizationType())
                {
                    return false;
                }
            }
            if (GET_PLAYER(pToCity->getOwner()).GetPlayerTraits()->IsNoNaturalReligionSpread())
            {
                ReligionTypes ePantheon = GET_PLAYER(pToCity->getOwner()).GetReligions()->GetReligionCreatedByPlayer(true);
                const CvReligion* pReligion2 = GetReligion(ePantheon, pToCity->getOwner());
                if (ePantheon != eReligion && pReligion2 && (pToCity->GetCityReligions()->GetNumFollowers(ePantheon) > 0) && pReligion2->m_Beliefs.GetUniqueCiv() == GET_PLAYER(pToCity->getOwner()).getCivilizationType())
                {
                    return false;
                }
            }*/
        }

        /*if (!GET_PLAYER(pToCity->getOwner()).isMinorCiv() && GET_PLAYER(pToCity->getOwner()).GetPlayerTraits()->IsForeignReligionSpreadImmune())
        {
            ReligionTypes eToCityReligion = GET_PLAYER(pToCity->getOwner()).GetReligions()->GetReligionCreatedByPlayer(false);
            if ((eToCityReligion != NO_RELIGION) && (eReligion != eToCityReligion))
            {
                return false
            }
            eToCityReligion = GET_PLAYER(pToCity->getOwner()).GetReligions()->GetReligionInMostCities();
            if ((eToCityReligion != NO_RELIGION) && (eReligion > RELIGION_PANTHEON) && (eReligion != eToCityReligion))
            {
                return false
            }
        }*/

        /*if (GET_PLAYER(pToCity->getOwner()).isMinorCiv())
        {
            PlayerTypes eAlly = GET_PLAYER(pToCity->getOwner()).GetMinorCivAI()->GetAlly();
            if (eAlly != NO_PLAYER)
            {
                if (GET_PLAYER(eAlly).GetPlayerTraits()->IsForeignReligionSpreadImmune())
                {
                    ReligionTypes eToCityReligion = GET_PLAYER(eAlly).GetReligions()->GetReligionCreatedByPlayer(false);
                    if ((eToCityReligion != NO_RELIGION) && (eReligion != eToCityReligion))
                    {
                        return false
                    }
                    eToCityReligion = GET_PLAYER(eAlly).GetReligions()->GetReligionInMostCities();
                    if ((eToCityReligion != NO_RELIGION) && (eReligion > RELIGION_PANTHEON) && (eReligion != eToCityReligion))
                    {
                        return false
                    }
                }
            }
        }*/

/*        #if defined(MOD_RELIGION_LOCAL_RELIGIONS)
            if (MOD_RELIGION_LOCAL_RELIGIONS && GC.getReligionInfo(eReligion)->IsLocalReligion())
            {
                // Can only spread a local religion to our own cities or City States
                if (pToCity->getOwner() < MAX_MAJOR_CIVS && pFromCity->getOwner() != pToCity->getOwner()) {
                    return false;
                }

                // Cannot spread if either city is occupied or a puppet
                if ((pFromCity->IsOccupied() && !pFromCity->IsNoOccupiedUnhappiness()) || pFromCity->IsPuppet() ||
                    (pToCity->IsOccupied() && !pToCity->IsNoOccupiedUnhappiness()) || pToCity->IsPuppet()) {
                    return false;
                }
            }
        #endif*/
            return true
    }

    private func isConnected(by religionType: ReligionType, from fromCityRef: AbstractCity?, to toCityRef: AbstractCity?, withTrade connectedWithTrade: inout Bool, percent relativeDistancePercent: inout Int, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let fromCity = fromCityRef else {
            fatalError("cant get from city")
        }

        /*guard let toCity = toCityRef else {
            fatalError("cant get to city")
        }*/

        guard let pReligion = fromCity.cityReligion?.religiousMajority() else {
            return false
        }

        guard let fromCityPlayerReligion = fromCity.player?.religion else {
            return false
        }

        connectedWithTrade = false
        relativeDistancePercent = Int.max

        if religionType == pReligion {

            connectedWithTrade = gameModel.citiesHaveTradeConnection(from: fromCityRef, to: toCityRef)

            if connectedWithTrade {

                relativeDistancePercent = 1 // very close
                return true
            }
        }

        // Boost to distance due to belief?
        let distanceMod = fromCityPlayerReligion.spreadDistanceModifier()

        fatalError("not implemented")
        /*      //Boost from policy of other player?
             if (GET_PLAYER(pToCity->getOwner()).GetReligionDistance() != 0)
             {
                 if (pToCity->GetCityReligions()->GetReligiousMajority() <= RELIGION_PANTHEON)
                 {
                     //Do we have a religion?
                     ReligionTypes ePlayerReligion = GetReligionCreatedByPlayer(pToCity->getOwner());

                     if (ePlayerReligion <= RELIGION_PANTHEON)
                     {
                         //No..but did we adopt one?
                         ePlayerReligion = GET_PLAYER(pToCity->getOwner()).GetReligions()->GetReligionInMostCities();
                         //Nope, so full power.
                         if (ePlayerReligion <= RELIGION_PANTHEON)
                         {
                             iDistanceMod += GET_PLAYER(pToCity->getOwner()).GetReligionDistance();
                         }
                         //Yes, so only apply distance bonus to adopted faith.
                         else if (eReligion == ePlayerReligion)
                         {
                             iDistanceMod += GET_PLAYER(pToCity->getOwner()).GetReligionDistance();
                         }
                     }
                     //We did! Only apply bonuses if we founded this faith or it is the religion we have in most of our cities.
                     else if ((pReligion->m_eFounder == pToCity->getOwner()) || (eReligion == GET_PLAYER(pToCity->getOwner()).GetReligions()->GetReligionInMostCities()))
                     {
                         iDistanceMod += GET_PLAYER(pToCity->getOwner()).GetReligionDistance();
                     }
                 }
             }

             int iMaxDistanceLand = GET_PLAYER(pFromCity->getOwner()).GetTrade()->GetTradeRouteRange(DOMAIN_LAND, pFromCity)*SPath::getNormalizedDistanceBase();
             int iMaxDistanceSea = GET_PLAYER(pFromCity->getOwner()).GetTrade()->GetTradeRouteRange(DOMAIN_SEA, pFromCity)*SPath::getNormalizedDistanceBase();

             if (iDistanceMod > 0)
             {
                 iMaxDistanceLand *= (100 + iDistanceMod);
                 iMaxDistanceLand /= 100;
                 iMaxDistanceSea *= (100 + iDistanceMod);
                 iMaxDistanceSea /= 100;
             }

             //estimate the distance between the cities from the traderoute cost.
             //will be influences by terrain features, routes, open borders etc
             //note: trade routes are not necessarily symmetric in case of of unrevealed tiles etc
             SPath path;
             if (GC.getGame().GetGameTrade()->HavePotentialTradePath(false, pFromCity, pToCity, &path))
             {
                 int iPercent = (path.iNormalizedDistanceRaw * 100) / iMaxDistanceLand;
                 iRelativeDistancePercent = min(iRelativeDistancePercent, iPercent);
             }
             if (GC.getGame().GetGameTrade()->HavePotentialTradePath(false, pToCity, pFromCity, &path))
             {
                 int iPercent = (path.iNormalizedDistanceRaw * 100) / iMaxDistanceLand;
                 iRelativeDistancePercent = min(iRelativeDistancePercent, iPercent);
             }
             if (GC.getGame().GetGameTrade()->HavePotentialTradePath(true, pFromCity, pToCity, &path))
             {
                 int iPercent = (path.iNormalizedDistanceRaw * 100) / iMaxDistanceSea;
                 iRelativeDistancePercent = min(iRelativeDistancePercent, iPercent);
             }
             if (GC.getGame().GetGameTrade()->HavePotentialTradePath(true, pToCity, pFromCity, &path))
             {
                 int iPercent = (path.iNormalizedDistanceRaw * 100) / iMaxDistanceSea;
                 iRelativeDistancePercent = min(iRelativeDistancePercent, iPercent);
             }

             return (iRelativeDistancePercent<100);
         */

        return false
    }

    func availablePantheons(in gameModel: GameModel?) -> [PantheonType] {

        var pantheons: [PantheonType] = PantheonType.all

        for religionRef in self.religions(in: gameModel) {

            guard let religion = religionRef else {
                continue
            }

            if religion.pantheon() != .none {
                pantheons.removeAll(where: { $0 == religion.pantheon() })
            }
        }

        return pantheons
    }

    func numPantheonsCreated(in gameModel: GameModel?) -> Int {

        var pantheons: Int = 0

        for religionRef in self.religions(in: gameModel) {

            guard let religion = religionRef else {
                continue
            }

            if religion.pantheon() != .none {
                pantheons += 1
            }
        }

        return pantheons
    }
}
