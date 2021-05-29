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
            
            let scoreAtCity = self.scoreBeliefAtCity(of: pantheon, at: city, in: gameModel)
            scoreAtCity *= 10 /* RELIGION_BELIEF_SCORE_CITY_MULTIPLIER */
            scoreCity += scoreAtCity
            rtnValue += scoreAtCity
        }

        // Add in player-level value
        scorePlayer = self.scoreBeliefForPlayer(of: pantheon)
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
    func score(of pantheon: PantheonType, for tile: AbstractTile, in gameModel: GameModel?) -> Int {
     
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
        let flavorManager = player.valueOfPersonalityFlavor(of: .growth)
        
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
    
    func religionToSpread() -> ReligionType {
        
        return self.player?.religion.
    }
}
