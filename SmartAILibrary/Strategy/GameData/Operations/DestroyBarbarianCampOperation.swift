//
//  DestroyBarbarianCampOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 19.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationDestroyBarbarianCamp
//!  \brief        Send out a squad of units to take out a barbarian camp
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class DestroyBarbarianCampOperation: EnemyTerritoryOperation {
    
    let civilianRescue: Bool
    let unitToRescue: Int?
    
    init() {
        
        self.civilianRescue = false
        self.unitToRescue = nil
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func formation(in gameModel: GameModel?) -> UnitFormationType {
        
        return .antiBarbarianTeam // MUFORMATION_ANTI_BARBARIAN_TEAM
    }
    
    /// How close to target do we end up?
    override func deployRange() -> Int {
        
        return 2 /* AI_OPERATIONAL_BARBARIAN_CAMP_DEPLOY_RANGE */
    }

    /// Same as default version except if just gathered forces, check to see if a better target has presented itself
    func armyInPosition(in gameModel: GameModel) -> Bool {
        
        var stateChanged = false

        switch self.state {
            // If we were gathering forces, let's make sure a better target hasn't presented itself
        case .gatheringForces:
        
            // First do base case processing
            stateChanged = super.armyInPosition(in: gameModel)

            // Now revisit target
            let possibleBetterTarget = self.findBestTarget(in: gameModel)

            // If no target left, abort
            if possibleBetterTarget == nil {
                self.state = .aborted(reason: .lostTarget);
            }

            // If target changed, reset to this new one
            else if(possibleBetterTarget != GetTargetPlot())
            {
                // If we're traveling on a single continent, set our destination to be a few plots shy of the final target
                if (pArmy->GetArea() == possibleBetterTarget->getArea())
                {
                    CvPlot* pDeployPt = GC.getStepFinder().GetXPlotsFromEnd(GetOwner(), GetEnemy(), pArmy->Plot(), possibleBetterTarget, GC.getAI_OPERATIONAL_BARBARIAN_CAMP_DEPLOY_RANGE(), false);
                    if(pDeployPt != NULL)
                    {
                        pArmy->SetGoalPlot(pDeployPt);
                        SetTargetPlot(possibleBetterTarget);
                    }
                }

                // Coming in from the sea. Just head to the camp
                else
                {
                    pArmy->SetGoalPlot(possibleBetterTarget);
                    SetTargetPlot(possibleBetterTarget);
                }
            }

        // See if reached our target, if so give control of these units to the tactical AI
        case AI_OPERATION_STATE_MOVING_TO_TARGET:
        {
            if (plotDistance(pArmy->GetX(), pArmy->GetY(), pArmy->GetGoalX(), pArmy->GetGoalY()) <= 1)
            {
                // Notify tactical AI to focus on this area
                CvTemporaryZone zone;
                zone.SetX(GetTargetPlot()->getX());
                zone.SetY(GetTargetPlot()->getY());
                zone.SetTargetType(AI_TACTICAL_TARGET_BARBARIAN_CAMP);
                zone.SetLastTurn(GC.getGame().getGameTurn() + GC.getAI_TACTICAL_MAP_TEMP_ZONE_TURNS());
                GET_PLAYER(m_eOwner).GetTacticalAI()->AddTemporaryZone(zone);

                m_eCurrentState = AI_OPERATION_STATE_SUCCESSFUL_FINISH;
            }
        }
        break;

        // In all other cases use base class version
        case AI_OPERATION_STATE_ABORTED:
        case AI_OPERATION_STATE_RECRUITING_UNITS:
        case AI_OPERATION_STATE_AT_TARGET:
            return CvAIOperation::ArmyInPosition(pArmy);
            break;
        };

        return stateChanged
    }

    /// Returns true when we should abort the operation totally (besides when we have lost all units in it)
    override func shouldAbort(in gameModel: GameModel?) -> Bool {

        CvString strMsg;

        // If parent says we're done, don't even check anything else
        bool rtnValue = CvAIOperation::ShouldAbort();

        if(!rtnValue)
        {
            // See if our target camp is still there
            if (!m_bCivilianRescue && GetTargetPlot()->getImprovementType() != GC.getBARBARIAN_CAMP_IMPROVEMENT())
            {
                // Success!  The camp is gone
                if(GC.getLogging() && GC.getAILogging())
                {
                    strMsg.Format("Barbarian camp at (x=%d y=%d) no longer exists. Aborting", GetTargetPlot()->getX(), GetTargetPlot()->getY());
                    LogOperationSpecialMessage(strMsg);
                }
                return true;
            }

            else if (m_bCivilianRescue)
            {
                // is the unit rescued?
                CvPlayerAI& BarbPlayer = GET_PLAYER(BARBARIAN_PLAYER);
                CvUnit* pUnitToRescue = BarbPlayer.getUnit(m_iUnitToRescue);
                if (!pUnitToRescue)
                {
                    if (GC.getLogging() && GC.getAILogging())
                    {
                        strMsg.Format ("Civilian can no longer be rescued from barbarians. Aborting");
                        LogOperationSpecialMessage(strMsg);
                    }
                    return true;
                }
                else
                {
                    if (pUnitToRescue->GetOriginalOwner() != m_eOwner || (pUnitToRescue->AI_getUnitAIType() != UNITAI_SETTLE && pUnitToRescue->AI_getUnitAIType() != UNITAI_WORKER))
                    {
                        if (GC.getLogging() && GC.getAILogging())
                        {
                            strMsg.Format ("Civilian can no longer be rescued from barbarians. Aborting");
                            LogOperationSpecialMessage(strMsg);
                        }
                        return true;
                    }
                }
            }

            else if(m_eCurrentState != AI_OPERATION_STATE_RECRUITING_UNITS)
            {
                // If down below strength of camp, abort
                CvArmyAI* pThisArmy = GET_PLAYER(m_eOwner).getArmyAI(m_viArmyIDs[0]);
                CvPlot* pTarget = GetTargetPlot();
                UnitHandle pCampDefender = pTarget->getBestDefender(NO_PLAYER);
                if(pCampDefender && pThisArmy->GetTotalPower() < pCampDefender->GetPower())
                {
                    if(GC.getLogging() && GC.getAILogging())
                    {
                        strMsg.Format("Barbarian camp stronger (%d) than our units (%d). Aborting", pCampDefender->GetPower(), pThisArmy->GetTotalPower());
                        LogOperationSpecialMessage(strMsg);
                    }
                    return true;
                }
            }
        }

        return rtnValue;
    }

    /// Find the barbarian camp we want to eliminate
    override func findBestTarget(in gameModel: GameModel?) -> HexPoint? {

        int iPlotLoop;
        CvPlot* pBestPlot = NULL;
        CvPlot* pPlot;
        int iBestPlotDistance = MAX_INT;
        int iCurPlotDistance;

        m_bCivilianRescue = false;

        TeamTypes eTeam = GET_PLAYER(m_eOwner).getTeam();
        ImprovementTypes eBarbCamp = (ImprovementTypes) GC.getBARBARIAN_CAMP_IMPROVEMENT();

        CvCity* pStartCity;
        pStartCity = GetOperationStartCity();
        if(pStartCity != NULL)
        {

            // look for good captured civilians of ours (settlers and workers, not missionaries)
            // these will be even more important than just a camp
            // btw - the AI will cheat here - as a human I would use a combination of memory and intuition to find these, since our current AI has neither of these...
            CvPlayerAI& BarbPlayer = GET_PLAYER(BARBARIAN_PLAYER);

            CvUnit* pLoopUnit = NULL;
            int iLoop;
            for (pLoopUnit = BarbPlayer.firstUnit(&iLoop); pLoopUnit != NULL; pLoopUnit = BarbPlayer.nextUnit(&iLoop))
            {
                if (pLoopUnit->GetOriginalOwner() == m_eOwner && (pLoopUnit->AI_getUnitAIType() == UNITAI_SETTLE || pLoopUnit->AI_getUnitAIType() == UNITAI_WORKER || pLoopUnit->AI_getUnitAIType() == UNITAI_ARCHAEOLOGIST))
                {
                    iCurPlotDistance = GC.getStepFinder().GetStepDistanceBetweenPoints(m_eOwner, m_eEnemy, pLoopUnit->plot(), pStartCity->plot());
                    if (iCurPlotDistance < iBestPlotDistance)
                    {
                        pBestPlot = pLoopUnit->plot();
                        iBestPlotDistance = iCurPlotDistance;
                        m_bCivilianRescue = true;
                        m_iUnitToRescue = pLoopUnit->GetID();
                    }
                }
            }

            if (!pBestPlot)
            {
                // Look at map for Barbarian camps
                for (iPlotLoop = 0; iPlotLoop < GC.getMap().numPlots(); iPlotLoop++)
                {
                    pPlot = GC.getMap().plotByIndexUnchecked(iPlotLoop);

                    if (pPlot->isRevealed(eTeam))
                    {
                        if (pPlot->getRevealedImprovementType(eTeam) == eBarbCamp)
                        {
                            // Make sure camp is in the same area as our start city
                            //if (pPlot->getArea() == pStartCity->getArea())
                            {
                                iCurPlotDistance = GC.getStepFinder().GetStepDistanceBetweenPoints(m_eOwner, m_eEnemy, pPlot, pStartCity->plot());

                                if (iCurPlotDistance < iBestPlotDistance)
                                {
                                    pBestPlot = pPlot;
                                    iBestPlotDistance = iCurPlotDistance;
                                }
                            }
                        }
                    }
                }
            }

        }

        return pBestPlot;
    }
}
