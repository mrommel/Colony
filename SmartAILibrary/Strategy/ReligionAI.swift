//
//  ReligionAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public class ReligionAI {

    var player: Player?

    // MARK: constructors

    init(player: Player?) {

        self.player = player
    }

    func choosePantheonType(in gameModel: GameModel?) -> PantheonType {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        let takenPantheonTypes: [PantheonType] = gameModel.religions().map {
            guard let religion = $0 else {
                fatalError("cant get religion")
            }

            return religion.pantheon()
        }
        let availablePantheons: [PantheonType] = PantheonType.all.filter { !takenPantheonTypes.contains($0) }

        let weights: WeightedList<PantheonType> = WeightedList<PantheonType>()

        for pantheonType in availablePantheons {
            let score = self.score(of: pantheonType, in: gameModel)
            weights.add(weight: score, for: pantheonType)
        }

        if let bestPantheon = weights.chooseFromTopChoices() {
            return bestPantheon
        }

        return .none
    }

    /// AI's perceived worth of a belief
    func score(of pantheon: PantheonType, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var rtnValue = 0  // Base value since everything has SOME value

        var scorePlot = 0
        var scoreCity = 0
        var scorePlayer = 0

        // Loop through each plot on map
        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                guard let tile = gameModel.tile(x: x, y: y) else {
                    continue
                }

                // Skip if not revealed or in enemy territory
                guard tile.isDiscovered(by: self.player) && (!tile.hasOwner() || tile.ownerLeader() == self.player?.leader) else {
                    continue
                }

                // Skip if closest city of ours has no chance to work the plot
                guard player.cityDistancePathLength(of: tile.point, in: gameModel) <= 3 else {
                    continue
                }

                // Score it
                var scoreAtPlot = self.score(of: pantheon, for: tile, in: gameModel)
                guard scoreAtPlot > 0 else {
                    continue
                }

                // Apply multiplier based on whether or not being worked, within culture borders, or not
                if tile.isWorked() {
                    if tile.hasAnyImprovement() {
                        scoreAtPlot *= 8 /* RELIGION_BELIEF_SCORE_WORKED_PLOT_MULTIPLIER */
                    } else {
                        scoreAtPlot *= 5 /* RELIGION_BELIEF_SCORE_OWNED_PLOT_MULTIPLIER */
                    }
                } else if tile.ownerLeader() == self.player?.leader {
                    if tile.hasAnyImprovement() {
                        scoreAtPlot *= 8 /* RELIGION_BELIEF_SCORE_WORKED_PLOT_MULTIPLIER */
                    } else {
                        scoreAtPlot *= 5 /* RELIGION_BELIEF_SCORE_OWNED_PLOT_MULTIPLIER */
                    }
                } else {
                    scoreAtPlot *= 3 /* RELIGION_BELIEF_SCORE_UNOWNED_PLOT_MULTIPLIER */
                }

                rtnValue += scoreAtPlot

                scorePlot = rtnValue
            }
        }

        // Add in value at city level
        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            var scoreAtCity = self.scoreBeliefAtCity(of: pantheon, at: city, in: gameModel)
            scoreAtCity *= 10 /* RELIGION_BELIEF_SCORE_CITY_MULTIPLIER */
            scoreCity += scoreAtCity
            rtnValue += scoreAtCity
        }

        // Add in player-level value
        scorePlayer = self.scoreBeliefForPlayer(of: pantheon, in: gameModel)
        rtnValue += scorePlayer

        // Final calculations
        /*if ((pEntry->GetRequiredCivilization() != NO_CIVILIZATION) && (pEntry->GetRequiredCivilization() == m_pPlayer->getCivilizationType()))
        {
            iRtnValue *= 5;
        }
        if (m_pPlayer->GetPlayerTraits()->IsBonusReligiousBelief() && bForBonus)
        {
            int iModifier = 0;
            if (pEntry->IsFounderBelief())
                iModifier += 5;
            else if(pEntry->IsPantheonBelief())
                iModifier += -5;
            else if (pEntry->IsEnhancerBelief())
                iModifier += 5;
            else if (pEntry->IsFollowerBelief())
            {
                bool bNoBuilding = true;
                for (int iI = 0; iI < GC.getNumBuildingClassInfos(); iI++)
                {
                    if (pEntry->IsBuildingClassEnabled(iI))
                    {
                        BuildingTypes eBuilding = (BuildingTypes)m_pPlayer->getCivilizationInfo().getCivilizationBuildings(iI);
                        CvBuildingEntry* pBuildingEntry = GC.GetGameBuildings()->GetEntry(eBuilding);

                        if (pBuildingEntry)
                        {
                            bNoBuilding = false;
                            if (m_pPlayer->GetPlayerTraits()->GetFaithCostModifier() != 0)
                            {
                                modifier += 5
                            } else {
                                modifier += 1
                            }
                            break
                        }
                    }
                }
                if noBuilding {
                    modifier += -2
                }
            }

            if modifier != 0 {
                iModifier *= 100;
                bool ShouldSpread = false;

                //Increase based on nearby cities that lack our faith.
                //Subtract the % of enhanced faiths. More enhanced = less room for spread.
                int iNumEnhancedReligions = GC.getGame().GetGameReligions()->GetNumReligionsEnhanced();
                int iReligionsEnhancedPercent = (100 * iNumEnhancedReligions) / GC.getMap().getWorldInfo().getMaxActiveReligions();

                //Let's look at all cities and get their religious status. Gives us a feel for what we can expect to gain in the near future.
                int iNumNearbyCities = GetNumCitiesWithReligionCalculator(m_pPlayer->GetReligions()->GetCurrentReligion(), pEntry->IsPantheonBelief());

                int iSpreadTemp = 100;
                //Increase based on nearby cities that lack our faith.
                iSpreadTemp *= iNumNearbyCities;
                //Divide by estimated total # of cities on map.
                iSpreadTemp /= GC.getMap().getWorldInfo().GetEstimatedNumCities();

                if (iReligionsEnhancedPercent <= 50 || iSpreadTemp >= 25)
                    ShouldSpread = true;

                iRtnValue += ShouldSpread ? iModifier : iModifier*-1;
                if (rtnValue <= 0)
                    rtnValue = 1
            }
        }*/

        return rtnValue
    }

    /// AI's evaluation of this belief's usefulness at this one plot
    private func score(of pantheon: PantheonType, for tile: AbstractTile, in gameModel: GameModel?) -> Int {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var rtnValue: Int = 0
        var totalRtnValue: Int = 0

        // Terrain
        let feature = tile.feature()
        let resource = tile.resource(for: self.player)

        if pantheon.requiresResource() && resource == .none {
            return 0
        }

        let improvement = tile.improvement()

        for yieldType in YieldType.all {

            var personFlavor: Int = 0

            switch yieldType {

            case .food:
                personFlavor = player.valueOfPersonalityFlavor(of: .growth)
            case .production:
                personFlavor = player.valueOfPersonalityFlavor(of: .production)
            case .gold:
                personFlavor = player.valueOfPersonalityFlavor(of: .gold)
            case .science:
                personFlavor = player.valueOfPersonalityFlavor(of: .science)
            case .culture:
                personFlavor = player.valueOfPersonalityFlavor(of: .culture)
            case .faith:
                personFlavor = player.valueOfPersonalityFlavor(of: .religion)

            case .tourism:
                personFlavor = 0
            case .none:
                personFlavor = 0
            }

            rtnValue = Int(tile.yields(for: player, ignoreFeature: false).value(of: yieldType))
            if rtnValue <= 0 {
                continue
            }

            totalRtnValue += rtnValue * personFlavor

            if pantheon.requiresNoImprovement() && improvement != .none {
                rtnValue *= 7
                rtnValue /= 10
            } else if pantheon.requiresImprovement() && improvement == .none {
                rtnValue *= 9
                rtnValue /= 10
            } else if pantheon.requiresNoFeature() && feature != .none {
                rtnValue *= 8
                rtnValue /= 10
            } else {
                //generally means we get the bonus instantly...
                rtnValue *= 13
                rtnValue /= 10
            }
        }

        return totalRtnValue
    }

    /// AI's evaluation of this belief's usefulness at this one plot
    private func scoreBeliefAtCity(of pantheonType: PantheonType, at city: AbstractCity, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        guard let playerReligion = player.religion else {
            fatalError("cant get religion")
        }

        guard let buildings = city.buildings else {
            fatalError("cant get buildings")
        }

        var rtnValue = 0
        var tempValue = 0
        let minPop = pantheonType.minPopulation()
        let minFollowers = pantheonType.minFollowers()
        var happinessMultiplier = 3

        let flavorOffense = player.valueOfPersonalityFlavor(of: .offense)
        let flavorDefense = player.valueOfPersonalityFlavor(of: .defense)
        let flavorCityDefense = player.valueOfPersonalityFlavor(of: .cityDefense)
        let flavorHappiness = player.valueOfPersonalityFlavor(of: .amenities)
        let flavorGP = player.valueOfPersonalityFlavor(of: .greatPeople)

        let happinessNeedFactor = flavorOffense * 2 + flavorHappiness - flavorDefense
        if happinessNeedFactor > 15 {
            happinessMultiplier = 15
        } else if happinessNeedFactor < 6 {
            happinessMultiplier = 6
        }

        // let's establish some mid-game goals for the AI.
        var idealCityPop = max(player.capitalCity(in: gameModel)?.population() ?? 0, 30)
        var idealEmpireSize = max(player.numCities(in: gameModel), gameModel.mapSize().targetNumCities())

        if player.leader.isSmaller() {
            idealCityPop += 5
            idealEmpireSize -= 1
        }
        if player.leader.isExpansionist() {
            idealCityPop -= 4
            idealEmpireSize += 5
        }
        if player.leader.isWarmonger() {
            idealCityPop -= 2
            idealEmpireSize += 3
        }

        // Simple ones
        rtnValue += player.leader.isSmaller() ? pantheonType.cityGrowthModifier() * 2 : pantheonType.cityGrowthModifier()
        if pantheonType.requiresPeace() {
            rtnValue /= (2 + (diplomacyAI.isGoingForWorldConquest() ? 1 : -1))
        }
        rtnValue += (-pantheonType.plotCultureCostModifier() / 7) * max(-pantheonType.plotCultureCostModifier() / 7, flavorDefense - flavorOffense)

        rtnValue += (pantheonType.cityRangeStrikeModifier() / 3) * max(pantheonType.cityRangeStrikeModifier() / 3, flavorCityDefense - flavorOffense)

        rtnValue += (pantheonType.friendlyHealChange() * flavorDefense) / max(1, flavorOffense)

        // Wonder production multiplier
        if pantheonType.obsoleteEra() != .none {
            if pantheonType.obsoleteEra() > gameModel.worldEra() {
                rtnValue += (pantheonType.wonderProductionModifier() * pantheonType.obsoleteEra().rawValue) / 5
            }
        } else {
            rtnValue += pantheonType.wonderProductionModifier() / 3
        }

        if player.leader.isWarmonger() || player.leader.isExpansionist() {
            rtnValue += pantheonType.unitProductionModifier()
        } else {
            rtnValue += pantheonType.unitProductionModifier() / 2
        }

        // River happiness
        if gameModel.river(at: city.location) {

            tempValue = pantheonType.riverHappiness() * happinessMultiplier

            if minPop > 0 {
                if city.population() >= minPop {
                    tempValue *= 2
                }
            }
            rtnValue += tempValue
        }

        // Happiness per city
        tempValue = pantheonType.happinessPerCity() * happinessMultiplier
        if minPop > 0 {
            if city.population() >= minPop {
                tempValue *= 3
            }
        }
        rtnValue += tempValue

        // Building class happiness
        /*for(int jJ = 0; jJ < GC.getNumBuildingClassInfos(); jJ++)
        {
            iTempValue = pEntry->GetBuildingClassHappiness(jJ) * iHappinessMultiplier;
            if(iMinFollowers > 0)
            {
                if(pCity->getPopulation() >= iMinFollowers)
                {
                    iTempValue *= 2;
                }
            }
            iRtnValue += iTempValue;
        }*/

        var totalRtnValue = rtnValue

        var religion = playerReligion.currentReligion()
        if religion == .none {
            religion = playerReligion.religionInMostCities()
        }

        ////////////////////
        // Expansion
        ///////////////////

        let culture = Int(city.culturePerTurn(in: gameModel)) * idealEmpireSize

        var isHolyCity = city.isHolyCity(for: religion, in: gameModel)

        if !isHolyCity {

            for unitRef in gameModel.units(of: player) {

                guard let unit = unitRef else {
                    continue
                }

                if unit.type.canFoundReligion() && unit.location == city.location {
                    isHolyCity = true
                    break
                }
            }
        }

        var numLuxuries = 0
        for resourceLoop in ResourceType.all {

            if resourceLoop.usage() == .luxury && (city.numLocalResources(of: resourceLoop, in: gameModel) > 0 || player.numAvailable(resource: resourceLoop) > 0) {

                numLuxuries += 1
            }
        }

        let food = max(1, Int(city.foodPerTurn(in: gameModel)) * idealCityPop)
        tempValue = 0
        for yieldType in YieldType.all {

            if pantheonType.yieldPerPopulation(of: yieldType) > 0 {
                tempValue += food / pantheonType.yieldPerPopulation(of: yieldType)
                if player.leader.isPopulationBoostReligion() {
                    tempValue *= 2
                }
            }

            /*if isHolyCity {
                if (pEntry->GetHolyCityYieldChange(iI) > 0)
                {
                    tempValue += pEntry->GetHolyCityYieldChange(iI);
                }
                int iTR = pEntry->GetYieldPerActiveTR(iI);
                if (iTR > 0)
                {
                    iTR = pEntry->GetYieldPerActiveTR(iI) *  pFlavorManager->GetPersonalityIndividualFlavor((FlavorTypes)GC.getInfoTypeForString("FLAVOR_DIPLOMACY"));
                    if (m_pPlayer->GetPlayerTraits()->IsSmaller() || m_pPlayer->GetPlayerTraits()->IsDiplomat())
                        iTR *= 5;

                    iTempValue += iTR;
                }
            }*/

            if pantheonType.yieldPerLuxuryResource(of: yieldType) > 0 {

                var modifierValue = player.leader.isExpansionist() ? 5 : 2

                /*if m_pPlayer->GetPlayerTraits()->GetLuxuryHappinessRetention() || m_pPlayer->GetPlayerTraits()->GetUniqueLuxuryQuantity() != 0 || m_pPlayer->GetPlayerTraits()->IsImportsCountTowardsMonopolies() {
                    modifierValue += 2
                }*/

                /*for (int iJ = 0; iJ < NUM_YIELD_TYPES; iJ++)
                {
                    if (m_pPlayer->GetPlayerTraits()->GetYieldFromImport((YieldTypes)iJ) != 0)
                    {
                        ModifierValue += 2;
                    }
                    if (m_pPlayer->GetPlayerTraits()->GetYieldFromExport((YieldTypes)iJ) != 0)
                    {
                        ModifierValue += 2;
                    }
                }*/

                tempValue += (pantheonType.yieldPerLuxuryResource(of: yieldType) * max(1, numLuxuries)) * modifierValue
            }

            /*if (pEntry->GetYieldPerBorderGrowth((YieldTypes)iI) > 0)
            {
                int iVal = ((pEntry->GetYieldPerBorderGrowth((YieldTypes)iI) * iCulture) / max(4, pCity->GetJONSCultureLevel() * 4));
                if player.leader.isExpansionist() {
                    val *= 2;
                } else if player.leader.isSmaller() {
                    val /= 2
                }
                tempValue += val
            }*/
        }

        totalRtnValue += tempValue

        ////////////////////
        // Great People
        ///////////////////
        tempValue = 0
        if city.isCapital() || city.isHolyCityOfAnyReligion(in: gameModel) {

            for greatPersonType in GreatPersonType.all {

                if pantheonType.greatPersonPoints(for: greatPersonType) > 0 {
                    tempValue += (pantheonType.greatPersonPoints(for: greatPersonType) * flavorGP) / 10
                }
            }
        }

        totalRtnValue += tempValue

        ////////////////////
        // Growth
        ///////////////////

        tempValue = 0

        /*for yieldType in YieldType.all {
        }
        for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
        {
            if (pEntry->GetYieldPerBirth(iI) > 0)
            {
                int iEvaluator = 400;
                if (pEntry->IsPantheonBelief())
                {
                    iEvaluator -= 50;
                }
                if (m_pPlayer->GetPlayerTraits()->IsSmaller())
                {
                    iEvaluator -= 50;
                }
                if (m_pPlayer->GetPlayerTraits()->IsExpansionist() || m_pPlayer->GetPlayerTraits()->IsWarmonger())
                {
                    iEvaluator += 50;
                }
                if (m_pPlayer->GetPlayerTraits()->IsPopulationBoostReligion())
                {
                    iTempValue -= 50;
                }
                iTempValue += (pEntry->GetYieldPerBirth(iI) * (iFood / max(1, iEvaluator)));
            }
            if (pEntry->GetYieldFromWLTKD(iI) > 0)
            {
                iTempValue = pEntry->GetYieldFromWLTKD(iI) * 2;
                if (m_pPlayer->GetPlayerTraits()->GetWLTKDGATimer() > 0)
                {
                    iTempValue += m_pPlayer->GetPlayerTraits()->GetWLTKDGATimer() * 2;
                }
                if (m_pPlayer->GetPlayerTraits()->IsGPWLTKD())
                {
                    iTempValue *= 5;
                }
                if (m_pPlayer->GetPlayerTraits()->GetWLTKDGPImprovementModifier() != 0)
                {
                    iTempValue *= 5;
                }
                if (m_pPlayer->GetPlayerTraits()->GetPermanentYieldChangeWLTKD((YieldTypes)iI) != 0)
                {
                    iTempValue *= 5;
                }
                if (m_pPlayer->GetPlayerTraits()->GetWLTKDCulture() != 0)
                {
                    iTempValue *= 5;
                }
                if (m_pPlayer->GetPlayerTraits()->IsGreatWorkWLTKD())
                {
                    iTempValue *= 5;
                }
                if (m_pPlayer->GetPlayerTraits()->IsExpansionWLTKD())
                {
                    iTempValue *= 5;
                }
                if (pCity->GetWeLoveTheKingDayCounter() > 0)
                {
                    iTempValue += pCity->GetWeLoveTheKingDayCounter();
                }
                /*if (pCity->GetYieldFromWLTKD((YieldTypes)iI) > 0)
                {
                    tempValue += pCity->GetYieldFromWLTKD((YieldTypes)iI);
                }*/
            }
        }

        totalRtnValue += tempValue
         */

        var eraBonus = (7 - player.currentEra().rawValue)
        eraBonus /= 2
        if eraBonus <= 0 {
            eraBonus = 1
        }

        tempValue = 0
        for yieldType in YieldType.all {

            rtnValue = 0

            // City yield change
            /*iTempValue = pEntry->GetCityYieldChange(iI) * (iEraBonus + pCity->getPopulation());
            if (iMinPop > 0 && pCity->getPopulation() >= iMinPop)
            {
                iTempValue *= 2;
            }
            iRtnValue += iTempValue;*/

            // Trade route yield change
            /*iTempValue = pEntry->GetYieldChangeTradeRoute(iI) * iEraBonus;
            if(iMinPop > 0)
            {
                if(pCity->getPopulation() >= iMinPop)
                {
                    iTempValue *= 5;
                }
            }
            if(pCity->IsRouteToCapitalConnected())
            {
                iTempValue *= 5;
            }
            iRtnValue += iTempValue;*/

            // Specialist yield change
            /*int iSpecialistValue = pEntry->GetYieldChangeAnySpecialist(iI) * iEraBonus;
            if (iSpecialistValue > 0)  // Like it more with large cities
            {
                iSpecialistValue += pCity->getPopulation();
            }

            if (pCity->GetCityCitizens()->GetSpecialistSlotsTotal() > 0)
            {
                iTempValue *= 2;
            }

            iRtnValue += iTempValue;*/

            // Building class yield change
            for buildingType in BuildingType.all {

                tempValue = pantheonType.yieldFor(building: buildingType, yield: yieldType) * eraBonus
                if minFollowers > 0 {
                    if city.population() < minFollowers {
                        tempValue /= 2
                    }
                }

                if buildings.has(building: buildingType) {
                    tempValue *= 2
                }

                /*if(pkBuildingClassInfo->getMaxPlayerInstances() == 1 || pkBuildingClassInfo->getMaxGlobalInstances() == 1)
                {
                    iTempValue /= 2;
                }*/

                /*if (m_pPlayer->GetPlayerTraits()->IsPermanentYieldsDecreaseEveryEra() && (YieldTypes)iI == YIELD_SCIENCE)
                {
                    iTempValue = 0;
                }*/

                rtnValue += tempValue
            }

            // World wonder change
            //iRtnValue += pEntry->GetYieldChangeWorldWonder(iI) * player.diplomacyAI?.wonderCompetitiveness()

            // Yield per follower
            /*if (pEntry->GetMaxYieldModifierPerFollower(iI) > 0)
            {
                iTempValue = pEntry->GetMaxYieldModifierPerFollower(iI) * (pCity->getPopulation() * pCity->getPopulation()) / 10;
                iRtnValue += iTempValue;
            }

            // Yield per follower
            if (pEntry->GetMaxYieldModifierPerFollowerPercent(iI) > 0)
            {
                iTempValue = pEntry->GetMaxYieldModifierPerFollowerPercent(iI) * (pCity->getPopulation() * pCity->getPopulation()) / 100;
                iRtnValue += iTempValue;
            }*/

            /*if (pEntry->GetYieldPerConstruction(iI) > 0)
            {
                iTempValue = pEntry->GetYieldPerConstruction(iI) * (pCity->getPopulation() * pCity->getYieldRate(YIELD_PRODUCTION, false)) / 10;
                rtnValue += tempValue
            }*/

            totalRtnValue += rtnValue
        }

        return totalRtnValue
    }

    /// AI's evaluation of this belief's usefulness to this player
    private func scoreBeliefForPlayer(of pantheonType: PantheonType, in gameModel: GameModel?) -> Int {

        /*
         
         int iRtnValue = 0;
             CvGameReligions* pGameReligions = GC.getGame().GetGameReligions();

             if (m_pPlayer->getCapitalCity() == NULL)
                 return 0;

             // == Grand Strategy ==
             int iDiploInterest = 0;
             int iConquestInterest = 0;
             int iScienceInterest = 0;
             int iCultureInterest = 0;

             int iGrandStrategiesLoop;
             AIGrandStrategyTypes eGrandStrategy;
             CvAIGrandStrategyXMLEntry* pGrandStrategy;
             CvString strGrandStrategyName;

             // Loop through all GrandStrategies and get priority. Since these are usually 100+, we will divide by 10 later
             for (iGrandStrategiesLoop = 0; iGrandStrategiesLoop < GC.GetGameAIGrandStrategies()->GetNumAIGrandStrategies(); iGrandStrategiesLoop++)
             {
                 eGrandStrategy = (AIGrandStrategyTypes)iGrandStrategiesLoop;
                 pGrandStrategy = GC.GetGameAIGrandStrategies()->GetEntry(iGrandStrategiesLoop);
                 strGrandStrategyName = (CvString)pGrandStrategy->GetType();

                 if (strGrandStrategyName == "AIGRANDSTRATEGY_CONQUEST")
                 {
                     iConquestInterest += m_pPlayer->GetGrandStrategyAI()->GetGrandStrategyPriority(eGrandStrategy) / 10;
                 }
                 else if (strGrandStrategyName == "AIGRANDSTRATEGY_CULTURE")
                 {
                     iCultureInterest += m_pPlayer->GetGrandStrategyAI()->GetGrandStrategyPriority(eGrandStrategy) / 10;
                 }
                 else if (strGrandStrategyName == "AIGRANDSTRATEGY_UNITED_NATIONS")
                 {
                     iDiploInterest += m_pPlayer->GetGrandStrategyAI()->GetGrandStrategyPriority(eGrandStrategy) / 10;
                 }
                 else if (strGrandStrategyName == "AIGRANDSTRATEGY_SPACESHIP")
                 {
                     iScienceInterest += m_pPlayer->GetGrandStrategyAI()->GetGrandStrategyPriority(eGrandStrategy) / 10;
                 }
             }
             CvPlayerTraits* pPlayerTraits = m_pPlayer->GetPlayerTraits();

             //let's establish some mid-game goals for the AI.
             int iIdealCityPop = max(m_pPlayer->getCapitalCity()->getPopulation(), 30);
             int iIdealEmpireSize = max(m_pPlayer->getNumCities(), GC.getMap().getWorldInfo().getTargetNumCities());
             if (pPlayerTraits->IsSmaller())
             {
                 iIdealCityPop += 5;
                 iIdealEmpireSize--;
             }
             if (pPlayerTraits->IsExpansionist())
             {
                 iIdealCityPop -= 4;
                 iIdealEmpireSize += 5;
             }
             if (pPlayerTraits->IsWarmonger())
             {
                 iIdealCityPop -= 2;
                 iIdealEmpireSize += 3;
             }


             if (pPlayerTraits->IsWarmonger())
             {
                 iConquestInterest *= 3;
                 iScienceInterest *= 2;
             }
             if (pPlayerTraits->IsExpansionist())
             {
                 iConquestInterest *= 2;
                 iCultureInterest *= 3;
             }
             if (pPlayerTraits->IsNerd())
             {
                 iCultureInterest *= 2;
                 iScienceInterest *= 3;
             }
             if (pPlayerTraits->IsDiplomat())
             {
                 iConquestInterest *= 2;
                 iDiploInterest *= 3;
             }
             if (pPlayerTraits->IsSmaller())
             {
                 iCultureInterest *= 2;
                 iScienceInterest *= 3;
             }
             if (pPlayerTraits->IsTourism())
             {
                 iCultureInterest *= 3;
                 iDiploInterest *= 2;
             }
             if (pPlayerTraits->IsReligious())
             {
                 iCultureInterest *= 2;
                 iDiploInterest *= 3;
             }

             UnitClassTypes eMissionary = (UnitClassTypes)GC.getInfoTypeForString("UNITCLASS_MISSIONARY");
             
             //Trait-specific things to consider.
             bool bNoMissionary = m_pPlayer->GetPlayerTraits()->NoTrain(eMissionary);
             bool bNoNaturalSpread = m_pPlayer->GetPlayerTraits()->IsNoNaturalReligionSpread();
             bool bForeignSpreadImmune = m_pPlayer->GetPlayerTraits()->IsForeignReligionSpreadImmune();

             int iNumEnhancedReligions = pGameReligions->GetNumReligionsEnhanced();
             int iReligionsEnhancedPercent = (100 * iNumEnhancedReligions) / GC.getMap().getWorldInfo().getMaxActiveReligions();

             //Let's look at all cities and get their religious status. Gives us a feel for what we can expect to gain in the near future.
             int iNumNearbyCities = GetNumCitiesWithReligionCalculator(m_pPlayer->GetReligions()->GetCurrentReligion(), pEntry->IsPantheonBelief());

             ReligionTypes eReligion = GC.getGame().GetGameReligions()->GetFounderBenefitsReligion(m_pPlayer->GetID());
             if (eReligion == NO_RELIGION)
             {
                 eReligion = m_pPlayer->GetReligions()->GetReligionInMostCities();
             }

             //////////////////
             //Conquest-related player bonuses.
             ///////////////////////
             int iWarTemp = 0;

             int iNumNeighbors = 0;
             for (int iPlayerLoop = 0; iPlayerLoop < MAX_MAJOR_CIVS; iPlayerLoop++)
             {
                 CvPlayer &kLoopPlayer = GET_PLAYER((PlayerTypes)iPlayerLoop);
                 if (kLoopPlayer.isAlive() && iPlayerLoop != m_pPlayer->GetID() && kLoopPlayer.isMajorCiv())
                 {
                     if (kLoopPlayer.GetProximityToPlayer(m_pPlayer->GetID()) >= PLAYER_PROXIMITY_CLOSE)
                     {
                         iNumNeighbors++;
                         if (m_pPlayer->CanCrossOcean() && m_pPlayer->GetDiplomacyAI()->GetCivApproach((PlayerTypes)iPlayerLoop) <= CIV_APPROACH_GUARDED)
                         {
                             iNumNeighbors++;
                         }
                     }
                 }
             }


             if (iNumNeighbors > 0)
             {
                 if (pEntry->GetFaithFromKills() > 0)
                 {
                     iWarTemp += ((pEntry->GetFaithFromKills() * iNumNeighbors * iNumNeighbors) / 20);

                     if (pEntry->GetMaxDistance() != 0)
                     {
                         iWarTemp -= pEntry->GetMaxDistance() * 2;
                     }
                 }

                 // Unlocks units?
                 int iNumUnlockEras = 0;
                 for (int i = (int)m_pPlayer->GetCurrentEra(); i < GC.getNumEraInfos(); i++)
                 {
                     // Add in for each era enabled
                     if (pEntry->IsFaithUnitPurchaseEra(i))
                     {
                         iNumUnlockEras++;
                     }
                 }

                 iWarTemp += (iNumUnlockEras * iNumNeighbors);

                 int iNumUnits = m_pPlayer->getNumMilitaryUnits();
                 for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
                 {
                     if (pEntry->GetYieldPerHeal(iI) > 0)
                     {
                         iWarTemp += (pEntry->GetYieldPerHeal(iI) * iNumUnits) / 3;
                     }
                     if (pEntry->GetYieldFromConquest(iI) > 0)
                     {
                         iWarTemp += (pEntry->GetYieldFromConquest(iI) * iNumNeighbors) / 4;
                     }
                     if (pEntry->GetYieldFromConquest(iI) > 0)
                     {
                         iWarTemp += (pEntry->GetYieldFromRemoveHeresy((YieldTypes)iI) * iNumNeighbors);
                     }
                     if (pEntry->GetYieldFromKills((YieldTypes)iI))
                     {
                         iWarTemp += (pEntry->GetYieldFromKills((YieldTypes)iI) * iNumNeighbors) / 2;

                         if (pEntry->GetMaxDistance() != 0)
                         {
                             iWarTemp -= pEntry->GetMaxDistance();
                         }
                         if (m_pPlayer->GetYieldFromKills((YieldTypes)iI) > 0)
                         {
                             iWarTemp *= 4;
                         }
                         if (m_pPlayer->GetYieldFromBarbarianKills((YieldTypes)iI) > 0)
                         {
                             iWarTemp *= 4;
                         }
                     }
                 }

                 if (pEntry->GetCombatModifierFriendlyCities() > 0)
                 {
                     iWarTemp += (pEntry->GetCombatModifierFriendlyCities() * iIdealEmpireSize * iNumNeighbors) / 2;
                 }

                 if (pEntry->GetCombatModifierEnemyCities() > 0)
                 {
                     iWarTemp += (pEntry->GetCombatModifierEnemyCities() * iNumNeighbors) * 2;
                 }

                 if (pEntry->GetCombatVersusOtherReligionOwnLands() > 0)
                 {
                     iWarTemp += (pEntry->GetCombatVersusOtherReligionOwnLands() * iIdealEmpireSize * iNumNeighbors) / 4;
                 }

                 if (pEntry->GetCombatVersusOtherReligionTheirLands() > 0)
                 {
                     iWarTemp += (pEntry->GetCombatVersusOtherReligionTheirLands() * iNumNeighbors) * 2;
                 }

                 MilitaryAIStrategyTypes eStrategyBarbs = (MilitaryAIStrategyTypes)GC.getInfoTypeForString("MILITARYAISTRATEGY_ERADICATE_BARBARIANS");
                 if (m_pPlayer->GetMilitaryAI()->IsUsingStrategy(eStrategyBarbs))
                 {
                     if (pEntry->ConvertsBarbarians() && !bNoMissionary)
                     {
                         iWarTemp *= 2;
                     }
                 }

                 if (eReligion != NO_RELIGION)
                 {
                     const CvReligion* pReligion = GC.getGame().GetGameReligions()->GetReligion(eReligion, m_pPlayer->GetID());
                     if (pReligion)
                     {
                         CvCity* pHolyCity = pReligion->GetHolyCity();

                         if (pReligion->m_Beliefs.GetFaithFromKills(-1, m_pPlayer->GetID(), pHolyCity) > 0)
                         {
                             iWarTemp *= 2;
                         }
                         if (pReligion->m_Beliefs.GetCombatModifierEnemyCities(m_pPlayer->GetID(), pHolyCity) > 0)
                         {
                             iWarTemp *= 2;
                         }
                         if (pReligion->m_Beliefs.GetCombatModifierFriendlyCities(m_pPlayer->GetID(), pHolyCity) > 0)
                         {
                             iWarTemp *= 2;
                         }
                         if (pReligion->m_Beliefs.GetCombatVersusOtherReligionOwnLands(m_pPlayer->GetID(), pHolyCity) > 0)
                         {
                             iWarTemp *= 2;
                         }
                         if (pReligion->m_Beliefs.GetCombatVersusOtherReligionTheirLands(m_pPlayer->GetID(), pHolyCity) > 0)
                         {
                             iWarTemp *= 2;
                         }
                         for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
                         {
                             const YieldTypes eYield = static_cast<YieldTypes>(iI);
                             if (eYield != NO_YIELD)
                             {
                                 if (pReligion->m_Beliefs.GetYieldFromKills(eYield, m_pPlayer->GetID()) > 0)
                                 {
                                     iWarTemp *= 2;
                                 }
                             }
                         }
                     }
                 }

                 if (m_pPlayer->IsAtWarAnyMajor() || m_pPlayer->GetDiplomacyAI()->GetMeanness() > 6)
                     iWarTemp *= 5;

                 if (!bForeignSpreadImmune)
                 {
                     int iForeignReligions = 0;
                     int iLoop;
                     CvCity* pLoopCity;
                     for (pLoopCity = m_pPlayer->firstCity(&iLoop); pLoopCity != NULL; pLoopCity = m_pPlayer->nextCity(&iLoop))
                     {
                         if (pLoopCity == NULL)
                             continue;

                         if (pLoopCity->GetCityReligions()->IsReligionHereOtherThan(eReligion, 1))
                             iForeignReligions++;
                     }

                     int iInquisitor = 0;
                     for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
                     {
                         iInquisitor += pEntry->GetYieldFromRemoveHeresy((YieldTypes)iI);
                         
                     }

                     if (iForeignReligions > 0 )
                         iInquisitor *= iForeignReligions;
                     
                     iWarTemp += iInquisitor;

                     iWarTemp += (pEntry->GetInquisitorCostModifier() * -1 * max(1, iForeignReligions));
                 }
             }

             ////////////////////
             // Happiness
             ///////////////////

             int iHappinessTemp = 0;
             if (pEntry->GetPlayerHappiness() > 0)
             {
                 iHappinessTemp += max(0, pEntry->GetPlayerHappiness() * iIdealEmpireSize);
             }
             if (pEntry->GetHappinessPerFollowingCity() > 0)
             {
                 int iFloatToInt = (int)((pEntry->GetHappinessPerFollowingCity() * (iNumNearbyCities + iIdealEmpireSize)) / 5);
                 iHappinessTemp += max(0, iFloatToInt);
             }

             if (pEntry->GetFullyConvertedHappiness() > 0)
             {
                 int iTemp = (pEntry->GetFullyConvertedHappiness() * iIdealEmpireSize * m_pPlayer->GetPlayerTraits()->IsReligious() ? 4 : 2);
                 iHappinessTemp += max(0, iTemp);
             }

             if (pEntry->GetHappinessPerPantheon() > 0)
             {
                 int iPantheons = 0;
                 for (int iI = 0; iI < MAX_MAJOR_CIVS; iI++)
                 {
                     // Only civs we have met
                     if (GET_TEAM(m_pPlayer->getTeam()).isHasMet(GET_PLAYER((PlayerTypes)iI).getTeam()))
                     {
                         if (GET_PLAYER((PlayerTypes)iI).GetReligions()->HasCreatedPantheon())
                         {
                             iPantheons++;
                         }
                     }
                 }

                 iHappinessTemp += (pEntry->GetHappinessPerPantheon() * max(3, iPantheons) * (15 - iIdealEmpireSize));
             }

             ////////////////////
             // Culture
             ///////////////////

             int iCultureTemp = 0;

             int iCulture = m_pPlayer->GetTotalJONSCulturePerTurn() * iIdealEmpireSize;
             iCulture /= 5;

             for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
             {
                 if (pEntry->GetYieldFromPolicyUnlock(iI) > 0)
                 {
                     iCultureTemp += ((pEntry->GetYieldFromPolicyUnlock(iI)) / max(1, iCulture));

                     if ((YieldTypes)iI == YIELD_SCIENCE && m_pPlayer->GetPlayerTraits()->IsPermanentYieldsDecreaseEveryEra())
                     {
                         iCultureTemp /= 2;
                     }
                 }
             }

             ////////////////////
             // Science
             ///////////////////

             int iScienceTemp = 0;
             int iScience = m_pPlayer->GetScience() * 100 * iIdealEmpireSize;
             iScience /= 10;

             for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
             {
                 if (pEntry->GetYieldPerScience(iI) > 0)
                 {
                     iScienceTemp += (iScience / pEntry->GetYieldPerScience(iI));
                 }
                 if (pEntry->GetYieldFromEraUnlock(iI) > 0)
                 {
                     iScienceTemp += (pEntry->GetYieldFromEraUnlock(iI) * (GC.getNumEraInfos() - m_pPlayer->GetCurrentEra()));
                     //Big numbers skew value.
                     iScienceTemp /= ((m_pPlayer->GetCurrentEra() +1) * 2);
                 }
                 if (m_pPlayer->GetPlayerTraits()->IsPermanentYieldsDecreaseEveryEra())
                 {
                     iScienceTemp /= 2;
                 }
             }
             ////////////////////
             // Gold
             ///////////////////

             int iGoldTemp = 0;
             int iGrossGold = max(15, (m_pPlayer->GetTreasury()->CalculateGrossGold() * iIdealEmpireSize));
             for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
             {
                 if (pEntry->GetYieldPerGPT(iI) > 0)
                 {
                     iGoldTemp += (iGrossGold / pEntry->GetYieldPerGPT(iI));
                 }
                 if (pEntry->GetYieldFromRemoveHeresy(YIELD_GOLD) > 0)
                 {
                     iGoldTemp += pEntry->GetYieldFromRemoveHeresy(YIELD_GOLD) / 25;
                 }
             }

             ////////////////////
             // Spread
             ///////////////////

             int iSpreadTemp = 0;
             int iMissionary = 0;

             if (!bNoNaturalSpread)
             {
                 if (pEntry->GetPressureChangeTradeRoute() != 0 && !m_pPlayer->GetPlayerTraits()->IsNoOpenTrade())
                 {
                     iSpreadTemp += (pEntry->GetPressureChangeTradeRoute() * m_pPlayer->GetTrade()->GetNumTradeRoutesPossible()) / 2;
                     if (m_pPlayer->GetPlayerTraits()->GetNumTradeRoutesModifier() != 0)
                     {
                         iSpreadTemp *= 2;
                     }
                 }

                 if (m_pPlayer->GetDiplomacyAI()->GetMeanness() <= 6)
                 {
                     iSpreadTemp += (pEntry->GetHappinessPerXPeacefulForeignFollowers()) * 5;
                 }

                 iSpreadTemp += (pEntry->GetSciencePerOtherReligionFollower()) * 2;

                 iSpreadTemp += (pEntry->GetGoldPerFollowingCity()) * 2;

                 iSpreadTemp += (pEntry->GetGoldPerXFollowers()) * 3;

                 iSpreadTemp += (pEntry->GetGoldWhenCityAdopts()) / 2;

                 iSpreadTemp += (pEntry->GetSpreadDistanceModifier()) / 2;

                 iSpreadTemp += (pEntry->GetSpreadStrengthModifier()) / 2;

                 if (pEntry->GetSpreadModifierDoublingTech() != NO_TECH && GET_TEAM(m_pPlayer->getTeam()).GetTeamTechs()->HasTech(pEntry->GetSpreadModifierDoublingTech()))
                 {
                     iSpreadTemp *= 2;
                 }

                 iMissionary += (pEntry->GetMissionaryStrengthModifier()) / 2;
                 iMissionary += (-1 * pEntry->GetMissionaryCostModifier()) / 2;
                 iMissionary += pEntry->GetMissionaryInfluenceCS();

                 for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
                 {
                     iMissionary += pEntry->GetYieldFromSpread(iI) / 5;

                     iMissionary += pEntry->GetYieldFromForeignSpread(iI) / 5;

                     iMissionary += pEntry->GetYieldFromConversion(iI) / 5;

                     iMissionary += pEntry->GetYieldFromConversionExpo(iI) / 5;

                     if ((YieldTypes)iI == YIELD_SCIENCE && m_pPlayer->GetPlayerTraits()->IsPermanentYieldsDecreaseEveryEra())
                     {
                         iMissionary /= 2;
                     }
                 }

                 //Best for high faith civs.
                 if (iMissionary > 0)
                     iMissionary += ((m_pPlayer->GetTotalFaithPerTurn() * iIdealEmpireSize) / 2);

                 if (m_pPlayer->GetDiplomacyAI()->GetMeanness() > 6)
                 {
                     iMissionary /= 2;
                 }

                 iSpreadTemp += iMissionary;

                 if (pEntry->GetProphetStrengthModifier() != 0 || pEntry->GetProphetCostModifier() != 0)
                 {
                     int iProphet = 0;
                     iProphet += (pEntry->GetProphetStrengthModifier()) / 2;
                     iProphet += (-1 * pEntry->GetProphetCostModifier()) / 2;

                     for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
                     {
                         iProphet += pEntry->GetYieldFromSpread(iI) / 4;

                         iProphet += pEntry->GetYieldFromForeignSpread(iI) / 5;

                         iProphet += pEntry->GetYieldFromConversion(iI) / 4;

                         iProphet += pEntry->GetYieldFromConversionExpo(iI) / 4;

                         if ((YieldTypes)iI == YIELD_SCIENCE && m_pPlayer->GetPlayerTraits()->IsPermanentYieldsDecreaseEveryEra())
                         {
                             iProphet = 0;
                         }
                     }

                     //Best for high faith civs.
                     if (iProphet > 0)
                         iProphet += m_pPlayer->GetTotalFaithPerTurn() * iIdealEmpireSize;

                     iSpreadTemp += iProphet;
                 }

                 if (pEntry->GetFriendlyCityStateSpreadModifier() != 0)
                 {
                     int iSpreadTempCS = (pEntry->GetFriendlyCityStateSpreadModifier() * (m_pPlayer->GetNumCSAllies() + m_pPlayer->GetNumCSFriends() + GC.getGame().GetNumMinorCivsAlive())) / 2;

                     iSpreadTemp += iSpreadTempCS;

                 }

                 if (pEntry->GetSpyPressure() != 0)
                 {
                     iSpreadTemp += (pEntry->GetSpyPressure() * m_pPlayer->GetEspionage()->GetNumSpies());
                     iSpreadTemp /= 2;

                     if (m_pPlayer->GetEspionageModifier() != 0)
                     {
                         iSpreadTemp *= 2;
                     }

                     if (m_pPlayer->GetFreeSpy() != 0)
                     {
                         iSpreadTemp *= 2;
                     }
                 }

                 if (!bForeignSpreadImmune)
                 {
                     iSpreadTemp += (pEntry->GetInquisitorPressureRetention() / 5);
                     iSpreadTemp += (pEntry->GetOtherReligionPressureErosion() / 5);
                 }

                 int iSpreadYields = 0;
                 int iSpreadYieldsLocal = 0;
                 // Yields for followers and follower cities
                 for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
                 {
                     iSpreadYieldsLocal += pEntry->GetYieldFromFaithPurchase(iI) * 2;

                     iSpreadYields += pEntry->GetYieldChangePerForeignCity(iI) * 2;

                     iSpreadYields += pEntry->GetYieldChangePerXForeignFollowers(iI) * 2;

                     if (pEntry->GetMaxYieldPerFollowerPercent(iI) > 0)
                     {
                         iSpreadYieldsLocal += pEntry->GetMaxYieldPerFollowerPercent(iI) * 25 / max(1, 100 - pEntry->GetMaxYieldPerFollower((YieldTypes)iI));
                     }
                     else
                     {
                         if (pEntry->GetYieldPerXFollowers((YieldTypes)iI) > 0)
                         {
                             int iVal = iIdealCityPop / pEntry->GetYieldPerXFollowers((YieldTypes)iI);
                             iVal *= 100;
                             iVal /= (100 + max(0, (2 * (iIdealCityPop - m_pPlayer->getCapitalCity()->getPopulation()))));

                             if (iVal > pEntry->GetMaxYieldPerFollower(iI))
                             {
                                 iVal = pEntry->GetMaxYieldPerFollower(iI);
                             }
                             if (pEntry->IsPantheonBelief())
                                 iVal /= 4;

                             iSpreadYieldsLocal += iVal;
                         }
                     }

                     if ((YieldTypes)iI == YIELD_SCIENCE && m_pPlayer->GetPlayerTraits()->IsPermanentYieldsDecreaseEveryEra())
                     {
                         iSpreadYields /= 2;
                         iSpreadYieldsLocal /= 2;
                     }
                 }


                 iSpreadYieldsLocal = (iSpreadYieldsLocal * max(m_pPlayer->getNumCities(), (iIdealCityPop / iIdealEmpireSize))) / 2;

                 if (bNoNaturalSpread)
                     iSpreadYields = 0;

                 iSpreadTemp += iSpreadYields;

                 if (iSpreadTemp > 0)
                 {
                     //Subtract the % of enhanced faiths. More enhanced = less room for spread.
                     iSpreadTemp *= (100 - iReligionsEnhancedPercent);
                     iSpreadTemp /= 100;

                     //Increase based on nearby cities that lack our faith.
                     iSpreadTemp *= max(1, iNumNearbyCities);
                     //Divide by estimated total # of cities on map.
                     iSpreadTemp /= GC.getMap().getWorldInfo().GetEstimatedNumCities();
                 }

                 iSpreadTemp += iSpreadYieldsLocal;
             }

             ////////////////////
             // Great People
             ///////////////////

             int iGPTemp = 0;

             for (int iJ = 0; iJ < GC.getNumGreatPersonInfos(); iJ++)
             {
                 GreatPersonTypes eGP = (GreatPersonTypes)iJ;
                 if (eGP == -1 || eGP == NULL || !eGP)
                     continue;

                 if (pEntry->GetGoldenAgeGreatPersonRateModifier(eGP) > 0)
                 {
                     iGPTemp += pEntry->GetGoldenAgeGreatPersonRateModifier(eGP) * 2;
                 }

                 for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
                 {
                     if (pEntry->GetGreatPersonExpendedYield(eGP, iI) > 0)
                     {
                         iGPTemp += pEntry->GetGreatPersonExpendedYield(eGP, iI) * 2;
                     }
                 }
             }
             for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
             {
                 if (pEntry->GetYieldFromGPUse(iI) > 0)
                 {
                     iGPTemp += pEntry->GetYieldFromGPUse(iI) * 2;
                 }

                 for (int iJ = 0; iJ < GC.getNumSpecialistInfos(); iJ++)
                 {
                     if (pEntry->GetSpecialistYieldChange((SpecialistTypes)iJ, iI) > 0)
                     {
                         iGPTemp += (pEntry->GetSpecialistYieldChange((SpecialistTypes)iJ, iI) * 5);
                     }
                 }
             }

             iGPTemp += pEntry->GetGreatPersonExpendedFaith();

             if (iGPTemp != 0 && m_pPlayer->getGreatPeopleRateModifier() != 0)
             {
                 iGPTemp += m_pPlayer->getGreatPeopleRateModifier() * 2;
             }

             if (pEntry->FaithPurchaseAllGreatPeople())
             {
                 // Count number of GP branches we have still to open and score based on that
                 int iTemp = 0;
         #if defined(MOD_RELIGION_POLICY_BRANCH_FAITH_GP)
                 if (MOD_RELIGION_POLICY_BRANCH_FAITH_GP)
                 {
                     // Count the number of policies we DON'T have that unlock Great People, for the time being we won't worry about multiple policies unlocking the same GP
                     for (int iPolicyLoop = 0; iPolicyLoop < m_pPlayer->GetPlayerPolicies()->GetPolicies()->GetNumPolicies(); iPolicyLoop++)
                     {
                         const PolicyTypes eLoopPolicy = static_cast<PolicyTypes>(iPolicyLoop);
                         CvPolicyEntry* pkLoopPolicyInfo = GC.getPolicyInfo(eLoopPolicy);
                         if (pkLoopPolicyInfo && !m_pPlayer->HasPolicy(eLoopPolicy))
                         {
                             // We don't have this policy, but does it permit any GP to be bought with faith
                             if (pkLoopPolicyInfo->HasFaithPurchaseUnitClasses())
                             {
                                 iTemp++;
                             }
                         }
                     }

                     CUSTOMLOG("FaithPurchaseAllGreatPeople unlocks %i GPs for %s", iTemp, m_pPlayer->getCivilizationDescription());
                 }
                 else
                 {
         #endif
                     PolicyBranchTypes eBranch;
                     eBranch = (PolicyBranchTypes)GC.getInfoTypeForString("POLICY_BRANCH_TRADITION", true /*bHideAssert*/);
                     if (eBranch != NO_POLICY_BRANCH_TYPE && (!m_pPlayer->GetPlayerPolicies()->IsPolicyBranchFinished(eBranch) || m_pPlayer->GetPlayerPolicies()->IsPolicyBranchBlocked(eBranch)))
                     {
                         iTemp++;
                     }
                     eBranch = (PolicyBranchTypes)GC.getInfoTypeForString("POLICY_BRANCH_HONOR", true /*bHideAssert*/);
                     if (eBranch != NO_POLICY_BRANCH_TYPE && (!m_pPlayer->GetPlayerPolicies()->IsPolicyBranchFinished(eBranch) || m_pPlayer->GetPlayerPolicies()->IsPolicyBranchBlocked(eBranch)))
                     {
                         iTemp++;
                     }
                     eBranch = (PolicyBranchTypes)GC.getInfoTypeForString("POLICY_BRANCH_AESTHETICS", true /*bHideAssert*/);
                     if (eBranch != NO_POLICY_BRANCH_TYPE && (!m_pPlayer->GetPlayerPolicies()->IsPolicyBranchFinished(eBranch) || m_pPlayer->GetPlayerPolicies()->IsPolicyBranchBlocked(eBranch)))
                     {
                         iTemp++;
                     }
                     eBranch = (PolicyBranchTypes)GC.getInfoTypeForString("POLICY_BRANCH_COMMERCE", true /*bHideAssert*/);
                     if (eBranch != NO_POLICY_BRANCH_TYPE && (!m_pPlayer->GetPlayerPolicies()->IsPolicyBranchFinished(eBranch) || m_pPlayer->GetPlayerPolicies()->IsPolicyBranchBlocked(eBranch)))
                     {
                         iTemp++;
                     }
                     eBranch = (PolicyBranchTypes)GC.getInfoTypeForString("POLICY_BRANCH_EXPLORATION", true /*bHideAssert*/);
                     if (eBranch != NO_POLICY_BRANCH_TYPE && (!m_pPlayer->GetPlayerPolicies()->IsPolicyBranchFinished(eBranch) || m_pPlayer->GetPlayerPolicies()->IsPolicyBranchBlocked(eBranch)))
                     {
                         iTemp++;
                     }
                     eBranch = (PolicyBranchTypes)GC.getInfoTypeForString("POLICY_BRANCH_RATIONALISM", true /*bHideAssert*/);
                     if (eBranch != NO_POLICY_BRANCH_TYPE && (!m_pPlayer->GetPlayerPolicies()->IsPolicyBranchFinished(eBranch) || m_pPlayer->GetPlayerPolicies()->IsPolicyBranchBlocked(eBranch)))
                     {
                         iTemp++;
                     }
         #if defined(MOD_RELIGION_POLICY_BRANCH_FAITH_GP)
                 }
         #endif

                 iGPTemp += (iTemp * 10);
             }

             if (eReligion != NO_RELIGION)
             {
                 const CvReligion* pReligion = GC.getGame().GetGameReligions()->GetReligion(eReligion, m_pPlayer->GetID());
                 if (pReligion)
                 {
                     CvCity* pHolyCity = pReligion->GetHolyCity();

                     if (pReligion->m_Beliefs.GetGreatPersonExpendedFaith(m_pPlayer->GetID(), pHolyCity) > 0)
                     {
                         iGPTemp += (pReligion->m_Beliefs.GetGreatPersonExpendedFaith(m_pPlayer->GetID(), pHolyCity) / 2);
                     }
                     for (int iJ = 0; iJ < GC.getNumGreatPersonInfos(); iJ++)
                     {
                         GreatPersonTypes eGP = (GreatPersonTypes)iJ;
                         if (eGP == -1 || eGP == NULL || !eGP)
                             continue;

                         if (pReligion->m_Beliefs.GetGoldenAgeGreatPersonRateModifier(eGP, m_pPlayer->GetID(), pHolyCity) > 0)
                         {
                             iGPTemp += pReligion->m_Beliefs.GetGoldenAgeGreatPersonRateModifier(eGP, m_pPlayer->GetID(), pHolyCity);
                         }

                         for (uint ui = 0; ui < NUM_YIELD_TYPES; ui++)
                         {
                             YieldTypes yield = (YieldTypes)ui;

                             if (yield == NO_YIELD)
                                 continue;

                             if (pReligion->m_Beliefs.GetGreatPersonExpendedYield(eGP, yield, m_pPlayer->GetID(), pHolyCity) > 0)
                             {
                                 iGPTemp += (pReligion->m_Beliefs.GetGreatPersonExpendedYield(eGP, yield, m_pPlayer->GetID(), pHolyCity) / 2);
                             }
                         }
                     }
                 }
             }
             
             ////////////////////
             // Buildings
             ///////////////////

             int iBuildingTemp = 0;
             BuildingClassTypes eFaithBuildingClass = NO_BUILDINGCLASS;

             if (eReligion != NO_RELIGION)
             {
                 const CvReligion* pReligion = GC.getGame().GetGameReligions()->GetReligion(eReligion, m_pPlayer->GetID());
                 if (pReligion != NULL)
                 {
                     CvCity* pHolyCity = pReligion->GetHolyCity();

                     eFaithBuildingClass = FaithBuildingAvailable(eReligion, pHolyCity);
                     for (int iI = 0; iI < GC.getNumBuildingClassInfos(); iI++)
                     {
                         if (pEntry->IsBuildingClassEnabled(iI))
                         {
                             BuildingTypes eBuilding = (BuildingTypes)m_pPlayer->getCivilizationInfo().getCivilizationBuildings(iI);
                             CvBuildingEntry* pBuildingEntry = GC.GetGameBuildings()->GetEntry(eBuilding);

                             if (pBuildingEntry)
                             {
                                 ////Sanity and AI Optimization Check

                                 //stats to decide whether to disband a unit
                                 int iWaterPriority = m_pPlayer->getCapitalCity()->GetTradePrioritySea();
                                 int iLandPriority = m_pPlayer->getCapitalCity()->GetTradePriorityLand();

                                 int iWaterRoutes = -1;
                                 int iLandRoutes = -1;

                                 if (iWaterPriority >= 0)
                                 {
                                     //0 is best, and 1+ = 100% less valuable than top. More routes from better cities, please!
                                     iWaterRoutes = 1000 - min(1000, (iWaterPriority * 50));
                                 }
                                 if (iLandPriority >= 0)
                                 {
                                     iLandRoutes = 1000 - min(1000, (iLandPriority * 50));
                                 }

                                 int iSanity = pEntry->IsFollowerBelief() ? 6 : 1;

                                 if (FaithBuildingAvailable(eReligion, pHolyCity == NULL ? m_pPlayer->getCapitalCity() : pHolyCity) == NO_BUILDINGCLASS)
                                 {
                                     iSanity = pEntry->IsFollowerBelief() ? 25 : 2;
                                 }

                                 if (pHolyCity != NULL)
                                 {
                                     iBuildingTemp += pHolyCity->GetCityStrategyAI()->GetBuildingProductionAI()->CheckBuildingBuildSanity(eBuilding, iSanity, iLandRoutes, iWaterRoutes, false, true, true);
                                 }
                                 else
                                 {
                                     iBuildingTemp += m_pPlayer->getCapitalCity()->GetCityStrategyAI()->GetBuildingProductionAI()->CheckBuildingBuildSanity(eBuilding, iSanity, iLandRoutes, iWaterRoutes, true, true, true);
                                 }

                                 //Do we already have a faith building? Let's not double down.
                                 //If the byzantines, let's get two national wonders!
                                 if (m_pPlayer->GetPlayerTraits()->IsBonusReligiousBelief())
                                 {
                                     if (pBuildingEntry->IsReformation())
                                     {
                                         iBuildingTemp *= 10;
                                     }
                                 }
                                 else if (eFaithBuildingClass != NO_BUILDINGCLASS)
                                 {
                                     //Only penalize if we're considering getting a second faith building.
                                     if (!pBuildingEntry->IsReformation())
                                     {
                                         iBuildingTemp /= 5;
                                     }
                                 }

                                 //special case for Orders...we really only want this if we're a warmonger.
                                 if (pBuildingEntry->GetFreePromotion() != NO_PROMOTION)
                                 {
                                     if (!m_pPlayer->GetPlayerTraits()->IsWarmonger())
                                         iBuildingTemp /= 10;
                                 }
                             }
                         }
                         if (pEntry->GetBuildingClassTourism(iI) > 0)
                         {
                             int iLoop;
                             CvCity* pLoopCity;
                             for (pLoopCity = m_pPlayer->firstCity(&iLoop); pLoopCity != NULL; pLoopCity = m_pPlayer->nextCity(&iLoop))
                             {
                                 iBuildingTemp += max(1, (pEntry->GetBuildingClassTourism(iI) * pLoopCity->GetCityBuildings()->GetNumBuildingClass((BuildingClassTypes)iI) * 5));
                             }
                         }
                     }

                     if (pEntry->GetFaithBuildingTourism() > 0)
                     {
                         int iLoop;
                         CvCity* pLoopCity;
                         for (pLoopCity = m_pPlayer->firstCity(&iLoop); pLoopCity != NULL; pLoopCity = m_pPlayer->nextCity(&iLoop))
                         {
                             if (pLoopCity->GetCityBuildings()->GetNumBuildingsFromFaith() > 0)
                             {
                                 iBuildingTemp += max(1, (pEntry->GetFaithBuildingTourism() * pLoopCity->GetCityBuildings()->GetNumBuildingsFromFaith() * 5));
                             }
                         }
                     }

                     int iLoop;
                     CvCity* pLoopCity;
                     for (pLoopCity = m_pPlayer->firstCity(&iLoop); pLoopCity != NULL; pLoopCity = m_pPlayer->nextCity(&iLoop))
                     {
                         if (pLoopCity == NULL)
                             continue;

                         int iEraBonus = (GC.getNumEraInfos() - (int)m_pPlayer->GetCurrentEra());
                         int iGW = pLoopCity->GetCityBuildings()->GetNumAvailableGreatWorkSlots() + iEraBonus + 1;
                         if (iGW > 0)
                         {
                             for (uint ui = 0; ui < NUM_YIELD_TYPES; ui++)
                             {
                                 YieldTypes yield = (YieldTypes)ui;

                                 if (yield == NO_YIELD)
                                     continue;

                                 if (pEntry->GetGreatWorkYieldChange(yield) > 0)
                                 {
                                     iBuildingTemp += (pEntry->GetGreatWorkYieldChange(yield) *iGW);
                                 }
                             }
                         }
                     }
                     
                     if (pEntry->IsFollowerBelief())
                         iBuildingTemp += iIdealEmpireSize * 10;
                 }
             }

             ////////////////////
             // Diplomacy
             ///////////////////
             // Minimum influence with city states

             int iDiploTemp = 0;
             if (!m_pPlayer->GetPlayerTraits()->IsBullyAnnex() && !m_pPlayer->GetPlayerTraits()->IsNoAnnexing())
             {
                 int iNumCS = 0;

                 for (int iPlayerLoop = 0; iPlayerLoop < MAX_CIV_PLAYERS; iPlayerLoop++)
                 {
                     CvPlayer &kLoopPlayer = GET_PLAYER((PlayerTypes)iPlayerLoop);
                     if (kLoopPlayer.isAlive() && kLoopPlayer.isMinorCiv())
                     {
                         iNumCS++;
                         if (kLoopPlayer.GetProximityToPlayer(m_pPlayer->GetID()) >= PLAYER_PROXIMITY_CLOSE)
                         {
                             iNumCS++;
                         }
                     }
                 }

                 for (int iJ = 0; iJ < GC.getNumImprovementInfos(); iJ++)
                 {
                     if (pEntry->GetImprovementVoteChange((ImprovementTypes)iJ) > 0)
                     {
                         iDiploTemp += (pEntry->GetImprovementVoteChange((ImprovementTypes)iJ) * max(5, m_pPlayer->CountAllImprovement((ImprovementTypes)iJ)));
                     }
                 }

                 iDiploTemp += (pEntry->GetCityStateMinimumInfluence() * GC.getGame().GetNumMinorCivsAlive()) / 10;

                 iDiploTemp += pEntry->GetHappinessFromForeignSpies() * max(2, m_pPlayer->GetEspionage()->GetNumSpies() * 25);

                 for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
                 {
                     if (!bForeignSpreadImmune && !bNoNaturalSpread)
                         iDiploTemp += pEntry->GetYieldPerOtherReligionFollower(iI) * 2;

                     if (pEntry->GetYieldFromKnownPantheons(iI) > 0)
                     {
                         int iPantheonValue = (GC.getGame().GetGameReligions()->GetNumPantheonsCreated() * pEntry->GetYieldFromKnownPantheons(iI)) / 100;
                         iDiploTemp += iPantheonValue * (GC.getGame().GetGameReligions()->GetNumPantheonsCreated() / 2);
                     }
                     if (pEntry->GetYieldFromHost(iI) > 0)
                     {
                         CvLeague* pLeague = GC.getGame().GetGameLeagues()->GetActiveLeague();
                         if (pLeague != NULL)
                         {
                             if (pEntry->GetYieldFromHost(iI) != 0)
                             {
                                 iDiploTemp += (pEntry->GetYieldFromHost(iI) * pLeague->CalculateStartingVotesForMember(m_pPlayer->GetID())) / 2;
                             }
                             if (pLeague->GetHostMember() == m_pPlayer->GetID())
                             {
                                 iDiploTemp *= 10;
                             }
                         }
                         else
                         {
                             if (pEntry->GetYieldFromHost(iI) != 0)
                             {
                                 iDiploTemp += (pEntry->GetYieldFromHost(iI) * m_pPlayer->GetNumCSFriends());
                             }
                         }
                     }
                     if (pEntry->GetYieldFromProposal(iI) > 0)
                     {
                         CvLeague* pLeague = GC.getGame().GetGameLeagues()->GetActiveLeague();
                         if (pLeague != NULL)
                         {
                             iDiploTemp += ((pEntry->GetYieldFromProposal(iI) / 2) * pLeague->CalculateStartingVotesForMember(m_pPlayer->GetID())) / 2;
                         }
                         else
                         {
                             iDiploTemp += ((pEntry->GetYieldFromProposal(iI) / 2)  * m_pPlayer->GetNumCSFriends());
                         }
                     }
                 }
                 if (pEntry->GetCSYieldBonus() > 0)
                 {
                     iDiploTemp += (pEntry->GetCSYieldBonus() * m_pPlayer->GetNumCSFriends()) / 2;
                 }

                 int iNumImprovementInfos = GC.getNumImprovementInfos();
                 for (int jJ = 0; jJ < iNumImprovementInfos; jJ++)
                 {
                     int potentialVotes = pEntry->GetImprovementVoteChange((ImprovementTypes)jJ);
                     if (potentialVotes > 0)
                     {
                         int numImprovements = m_pPlayer->getImprovementCount((ImprovementTypes)jJ);
                         iDiploTemp += potentialVotes * (max(1, numImprovements) * 20);
                     }
                 }

                 if (pEntry->GetCityStateInfluenceModifier() > 0)
                 {
                     iDiploTemp += (pEntry->GetCityStateInfluenceModifier() * m_pPlayer->GetNumCSFriends()) / 2;
                 }

                 if (pEntry->GetExtraVotes() > 0)
                 {
                     CvLeague* pLeague = GC.getGame().GetGameLeagues()->GetActiveLeague();
                     if (pLeague != NULL)
                     {
                         iDiploTemp += (pEntry->GetExtraVotes() * pLeague->CalculateStartingVotesForMember(m_pPlayer->GetID()) * 2);
                     }
                     else
                     {
                         iDiploTemp += (pEntry->GetExtraVotes() * m_pPlayer->GetNumCSFriends() * 2);
                     }
                 }

                 DomainTypes eDomain;
                 for (int iI = 0; iI < NUM_DOMAIN_TYPES; iI++)
                 {
                     eDomain = (DomainTypes)iI;

                     for (int i = 0; i < NUM_YIELD_TYPES; i++)
                     {
                         YieldTypes eYield = (YieldTypes)i;
                         if (pEntry->GetTradeRouteYieldChange(eDomain, eYield) != 0)
                         {
                             if (pPlayerTraits->IsExpansionist())
                             {
                                 iDiploTemp += pEntry->GetTradeRouteYieldChange(eDomain, eYield) * 4;
                             }
                             else
                             {
                                 iDiploTemp += pEntry->GetTradeRouteYieldChange(eDomain, eYield) * 2;
                             }
                         }
                     }
                 }
             }

             ////////////////////
             // Other
             ///////////////////

             int iPolicyGainTemp = 0;

             bool bHasPolicyBelief = false;

             CvBeliefXMLEntries* pkBeliefs = GC.GetGameBeliefs();

             for (int iI = 0; iI < pkBeliefs->GetNumBeliefs(); iI++)
             {
                 if (GC.getGame().GetGameReligions()->IsInSomeReligion((BeliefTypes)iI, m_pPlayer->GetID()))
                 {
                     if (GC.GetGameBeliefs()->GetEntry((BeliefTypes)iI)->GetPolicyReductionWonderXFollowerCities() != 0)
                     {
                         bHasPolicyBelief = true;
                         break;
                     }
                     else if (GC.GetGameBeliefs()->GetEntry((BeliefTypes)iI)->GetIgnorePolicyRequirementsAmount() != 0)
                     {
                         bHasPolicyBelief = true;
                         break;
                     }
                 }
             }
             if (pEntry->GetIgnorePolicyRequirementsAmount() != 0 && !bHasPolicyBelief)
             {
                 iPolicyGainTemp += m_pPlayer->getWonderProductionModifier() + m_pPlayer->GetPlayerTraits()->GetWonderProductionModifier();
                 if (m_pPlayer->getCapitalCity() != NULL)
                 {
                     iPolicyGainTemp += m_pPlayer->getCapitalCity()->getProduction();
                 }
             }

             if (!bHasPolicyBelief && pEntry->GetPolicyReductionWonderXFollowerCities() != 0)
             {
                 iPolicyGainTemp += m_pPlayer->getWonderProductionModifier() + m_pPlayer->GetPlayerTraits()->GetWonderProductionModifier();
                 if (m_pPlayer->getCapitalCity() != NULL)
                 {
                     iPolicyGainTemp += m_pPlayer->getCapitalCity()->getProduction();
                 }
             }

             int iGoldenAgeTemp = 0;

             for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
             {
                 if (pEntry->GetYieldBonusGoldenAge(iI) > 0)
                 {
                     iGoldenAgeTemp += pEntry->GetYieldBonusGoldenAge(iI) * 5;

                     ReligionTypes eReligion = GC.getGame().GetGameReligions()->GetFounderBenefitsReligion(m_pPlayer->GetID());
                     if (eReligion == NO_RELIGION)
                     {
                         eReligion = m_pPlayer->GetReligions()->GetReligionInMostCities();
                     }
                     if (eReligion != NO_RELIGION)
                     {
                         const CvReligion* pReligion = GC.getGame().GetGameReligions()->GetReligion(eReligion, m_pPlayer->GetID());
                         if (pReligion)
                         {
                             CvCity* pHolyCity = pReligion->GetHolyCity();

                             for (int iJ = 0; iJ < GC.getNumGreatPersonInfos(); iJ++)
                             {
                                 GreatPersonTypes eGP = (GreatPersonTypes)iJ;
                                 if (eGP == -1 || eGP == NULL || !eGP)
                                     continue;

                                 if (pReligion->m_Beliefs.GetGoldenAgeGreatPersonRateModifier(eGP, m_pPlayer->GetID(), pHolyCity) > 0)
                                 {
                                     iGoldenAgeTemp += pReligion->m_Beliefs.GetGoldenAgeGreatPersonRateModifier(eGP, m_pPlayer->GetID(), pHolyCity) * 2;
                                 }
                             }
                             for (uint ui = 0; ui < NUM_YIELD_TYPES; ui++)
                             {
                                 YieldTypes yield = (YieldTypes)ui;

                                 if (yield == NO_YIELD)
                                     continue;

                                 if (pReligion->m_Beliefs.GetYieldBonusGoldenAge(yield, m_pPlayer->GetID(), pHolyCity) > 0)
                                 {
                                     iGoldenAgeTemp += pReligion->m_Beliefs.GetYieldBonusGoldenAge(yield, m_pPlayer->GetID(), pHolyCity) * 5;
                                 }
                             }
                         }
                     }
                 }
             }

             //sanity check - we don't want buildings to be the sole reason we get a founder.
             if (pEntry->IsFounderBelief() && (iWarTemp + iHappinessTemp + iGoldenAgeTemp + iScienceTemp + iGPTemp + iCultureTemp + iPolicyGainTemp + iGoldTemp + iSpreadTemp + iDiploTemp) <= 250)
                 iBuildingTemp /= 100;

             if (pPlayerTraits->IsWarmonger())
             {
                 iWarTemp *= 3;
                 iHappinessTemp *= 2;
             }
             if (pPlayerTraits->IsNerd())
             {
                 iScienceTemp *= 3;
                 iGoldenAgeTemp *= 2;
             }
             if (pPlayerTraits->IsTourism())
             {
                 iCultureTemp *= 3;
                 iGoldenAgeTemp *= 2;
             }
             if (pPlayerTraits->IsDiplomat())
             {
                 iSpreadTemp *= pEntry->IsPantheonBelief() ? 1 : 3;
                 iGoldTemp *= 3;
             }
             if (pPlayerTraits->IsReligious())
             {
                 iSpreadTemp *= pEntry->IsPantheonBelief() ? 2 : 3;
                 iGPTemp *= 2;
             }
             if (pPlayerTraits->IsExpansionist())
             {
                 iSpreadTemp *= pEntry->IsPantheonBelief() ? 2 : 3;
                 iHappinessTemp *= 3;
                 iPolicyGainTemp *= 2;
             }
             if (pPlayerTraits->IsSmaller())
             {
                 iGoldenAgeTemp *= 2;
                 iGPTemp *= 3;
             }

             //add in the existing modifier values of our other beliefs to influence this one.
             if (!bReturnConquest && !bReturnCulture && !bReturnDiplo && !bReturnScience)
             {
                 ReligionTypes eReligion = m_pPlayer->GetReligions()->GetCurrentReligion();
                 if (eReligion != NO_RELIGION)
                 {
                     const CvReligion* pReligion = GC.getGame().GetGameReligions()->GetReligion(eReligion, m_pPlayer->GetID());
                     if (pReligion)
                     {
                         CvReligionBeliefs beliefs = pReligion->m_Beliefs;
                         for (int iI = 0; iI < beliefs.GetNumBeliefs(); iI++)
                         {
                             iWarTemp += ScoreBeliefForPlayer(GC.getBeliefInfo(beliefs.GetBelief(iI)), true) / 5;
                             iCultureTemp += ScoreBeliefForPlayer(GC.getBeliefInfo(beliefs.GetBelief(iI)), false, true) / 5;
                             iScienceTemp += ScoreBeliefForPlayer(GC.getBeliefInfo(beliefs.GetBelief(iI)), false, false, true) / 5;
                             iGoldTemp += ScoreBeliefForPlayer(GC.getBeliefInfo(beliefs.GetBelief(iI)), false, false, false, true) / 5;
                         }
                     }
                 }
             }

             //Take the bonus from above and multiply it by the priority value / 10 (as most are 100+, so we're getting a % interest here).

             iWarTemp *= (100 + (iConquestInterest / 10));
             iWarTemp /= 100;

             iHappinessTemp *= (100 + (iConquestInterest / 10));
             iHappinessTemp /= 100;

             iGoldenAgeTemp *= (100 + (iConquestInterest / 10));
             iGoldenAgeTemp /= 100;

             if (bReturnConquest)
                 return(iWarTemp + iHappinessTemp + iGoldenAgeTemp + iBuildingTemp) / 2;

             iCultureTemp *= (100 + (iCultureInterest / 10));
             iCultureTemp /= 100;

             iGPTemp *= (100 + (iCultureInterest / 10));
             iGPTemp /= 100;

             iPolicyGainTemp *= (100 + (iCultureInterest / 10));
             iPolicyGainTemp /= 100;

             iGoldenAgeTemp *= (100 + (iCultureInterest / 10));
             iGoldenAgeTemp /= 100;

             if (bReturnCulture)
                 return(iCultureTemp + iGPTemp + iPolicyGainTemp + iGoldenAgeTemp + iBuildingTemp) / 3;

             iGoldTemp *= (100 + (iDiploInterest / 10));
             iGoldTemp /= 100;

             iDiploTemp *= (100 + (iDiploInterest / 10));
             iDiploTemp /= 100;

             iSpreadTemp *= (100 + (iDiploInterest / 10));
             iSpreadTemp /= 100;

             if (bReturnDiplo)
                 return(iGoldTemp + iDiploTemp + iSpreadTemp + iBuildingTemp) / 4;

             iScienceTemp *= (100 + (iScienceInterest / 10));
             iScienceTemp /= 100;

             iBuildingTemp *= (100 + (iScienceInterest / 10));
             iBuildingTemp /= 100;

             iGoldenAgeTemp *= (100 + (iScienceInterest / 10));
             iGoldenAgeTemp /= 100;

             if (bReturnScience)
                 return(iGoldTemp + iScienceTemp + iBuildingTemp + iGPTemp + iGoldenAgeTemp) / 2;

             iRtnValue = (iWarTemp + iHappinessTemp + iGoldenAgeTemp + iScienceTemp + iGPTemp + iCultureTemp + iPolicyGainTemp + iGoldTemp + iSpreadTemp +  iBuildingTemp + iDiploTemp);

             if (iMissionary > 0 && bNoMissionary)
                 iRtnValue /= 100;

             if (GC.getLogging() && GC.getAILogging())
             {
                 CvString strOutBuf;
                 CvString strBaseString;
                 CvString strTemp;
                 CvString playerName;
                 CvString strDesc;

                 // Find the name of this civ
                 playerName = m_pPlayer->getCivilizationShortDescription();

                 // Open the log file
                 FILogFile* pLog;
                 pLog = LOGFILEMGR.GetLog("PlayerBeliefReligionLog.csv", FILogFile::kDontTimeStamp);

                 // Get the leading info for this line
                 strBaseString.Format("%03d, %d, ", GC.getGame().getElapsedGameTurns(), GC.getGame().getGameTurnYear());
                 strBaseString += playerName + ", ";

                 strDesc = GetLocalizedText(pEntry->getShortDescription());
                 strTemp.Format("Belief, %s, War: %d, Happiness: %d, Culture: %d, Science: %d, Gold: %d, Spread: %d, GP: %d, Diplo: %d, Building: %d, Policies: %d, Golden Ages: %d", strDesc.GetCString(), iWarTemp, iHappinessTemp, iCultureTemp, iScienceTemp, iGoldTemp, iSpreadTemp, iGPTemp, iDiploTemp, iBuildingTemp, iPolicyGainTemp, iGoldenAgeTemp);
                 strOutBuf = strBaseString + strTemp;
                 strTemp.Format(" --- Total Value: %d. Conquest Interest: %d, Culture Interest: %d, SS Interest: %d, WC Interest: %d", iRtnValue, iConquestInterest, iCultureInterest, iScienceInterest, iDiploInterest);
                 strOutBuf += strTemp;
                 pLog->Msg(strOutBuf);
             }

             return iRtnValue;
         
         */
        return 0
    }

    /// What religion should this AI civ be spreading?
    func religionToSpread() -> ReligionType {

        guard let playerReligion = self.player?.religion else {
            fatalError("cant get play religion")
        }

        let currentReligion: ReligionType = playerReligion.currentReligion()

        if currentReligion != .none {
            return currentReligion
        }

        let religionInMostCities: ReligionType = playerReligion.religionInMostCities()

        if religionInMostCities != .none {
            return religionInMostCities
        }

        return .none
    }
}
