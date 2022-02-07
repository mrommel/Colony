//
//  HaltGrowthBuildingsEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 06.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// ECONOMICAISTRATEGY_HALT_GROWTH_BUILDINGS
/// "Halt Growth Buildings" Player Strategy: Stop building granaries if working on a wonder that provides them for free
class HaltGrowthBuildingsEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            noMinorCivs: true,
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 1,
            firstTurnExecuted: 20,
            advisor: .economic,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_HALT_GROWTH_BUILDINGS",
            advisorCounselImportance: 2,
            flavors: [
                Flavor(type: .growth, value: -15)
            ],
            flavorThresholdModifiers: []
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
/*
        guard let (nextDesiredWonderType, _) = player?.citySpecializationAI?.nextWonderDesired() else {
            fatalError("cant get wonder type")
        }

        // Is average income below desired threshold over past X turns?
        if nextDesiredWonderType != .none {


                    BuildingClassTypes eBuildingClass = (BuildingClassTypes)pkBuildingInfo->GetFreeBuildingClass();
                    if(eBuildingClass != NO_BUILDINGCLASS)
                    {
                        CvBuildingClassInfo* pkBuildingClassInfo = GC.getBuildingClassInfo(eBuildingClass);
                        {
                            if(pkBuildingClassInfo)
                            {
                                BuildingTypes eBuilding = (BuildingTypes)pkBuildingClassInfo->getDefaultBuildingIndex();
                                if(eBuilding != NO_BUILDING)
                                {
                                    CvBuildingEntry* pkFreeBuildingInfo = pkGameBuildings->GetEntry(eBuilding);
                                    if(pkFreeBuildingInfo)
                                    {
                                        if(pkFreeBuildingInfo->GetYieldChange(YIELD_FOOD) > 0)
                                        {
                                            return true;
                                        }
                                    }
                                }
                            }
                        }
                    }

            }
*/
        return false
    }
}
