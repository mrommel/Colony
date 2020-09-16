//
//  QuickColonizeOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 16.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationQuickColonize
//!  \brief        Send a settler alone to a nearby island
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class QuickColonizeOperation: FoundCityOperation {
    
    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)
        
        self.moveType = .singleHex
        m_iID = iID;
        m_eOwner = eOwner;
        m_iTargetArea = iDefaultArea;

        // Find the free civilian (that triggered this operation)
        pOurCivilian = FindBestCivilian();

        if(pOurCivilian != NULL && iID != -1)
        {
            // Find a destination (not worrying about safe paths)
            pTargetSite = FindBestTarget(pOurCivilian, false);

            if(pTargetSite != NULL)
            {
                SetTargetPlot(pTargetSite);

                CvArmyAI* pArmyAI = GET_PLAYER(m_eOwner).addArmyAI();
                if(pArmyAI)
                {
                    m_viArmyIDs.push_back(pArmyAI->GetID());
                    pArmyAI->Init(pArmyAI->GetID(),m_eOwner,m_iID);
                    pArmyAI->SetFormationIndex(GetFormation());MUFORMATION_QUICK_COLONY_SETTLER

                    // Figure out the initial rally point - for this operation it is wherever our civilian is standing
                    pArmyAI->SetGoalPlot(pTargetSite);
                    CvPlot* pMusterPt = pOurCivilian->plot();
                    SetMusterPlot(pMusterPt);
                    pArmyAI->SetXY(pMusterPt->getX(), pMusterPt->getY());
                    pArmyAI->SetArmyAIState(ARMYAISTATE_MOVING_TO_DESTINATION);
                    SetDefaultArea(pMusterPt->getArea());

                    // Add the settler to our army
                    pArmyAI->AddUnit(pOurCivilian->GetID(), 0);
                    m_bEscorted = false;

                    m_eCurrentState = AI_OPERATION_STATE_MOVING_TO_TARGET;
                    LogOperationStart();
                }
            }

            else
            {
                // Lost our target, abort
                m_eCurrentState = AI_OPERATION_STATE_ABORTED;
                m_eAbortReason = AI_ABORT_LOST_TARGET;
            }
        }
    }
    
    /// Find the civilian we want to use
    CvUnit* CvAIOperationQuickColonize::FindBestCivilian()
    {
        int iUnitLoop;
        CvUnit* pLoopUnit;

        for(pLoopUnit = GET_PLAYER(m_eOwner).firstUnit(&iUnitLoop); pLoopUnit != NULL; pLoopUnit = GET_PLAYER(m_eOwner).nextUnit(&iUnitLoop))
        {
            if(pLoopUnit != NULL)
            {
                if(pLoopUnit->AI_getUnitAIType() == m_eCivilianType)
                {
                    if(pLoopUnit->getArmyID() == FFreeList::INVALID_INDEX)
                    {
                        return pLoopUnit;
                    }
                }
            }
        }
        return NULL;
    }

    /// Find the plot where we want to settle
    CvPlot* CvAIOperationQuickColonize::FindBestTarget(CvUnit* pUnit, bool /*bOnlySafePaths*/)
    {
        CvPlot* pResult = GET_PLAYER(m_eOwner).GetBestSettlePlot(pUnit, false, m_iTargetArea);
        if (pResult == NULL)
        {
            m_iTargetArea = -1;
            pResult = GET_PLAYER(m_eOwner).GetBestSettlePlot(pUnit, false, -1);
        }
        return pResult;
    }
}
