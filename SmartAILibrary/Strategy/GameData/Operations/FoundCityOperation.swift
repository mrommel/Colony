//
//  FoundCityOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationFoundCity
//!  \brief        Find a place to utilize a new settler
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class FoundCityOperation: EscortedOperation {

    init() {

        super.init(type: .foundCity, escorted: true, civilianType: .settle)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)
        
        self.moveType = .singleHex
        
        // Find the free civilian (that triggered this operation)
        pOurCivilian = FindBestCivilian();

        if(pOurCivilian != NULL && iID != -1)
        {
            // Find a destination (not worrying about safe paths)
            pTargetSite = FindBestTarget(pOurCivilian, false);

            if(pTargetSite != NULL)
            {
                SetTargetPlot(pTargetSite);

                // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
                CvArmyAI* pArmyAI = GET_PLAYER(m_eOwner).addArmyAI();
                if(pArmyAI)
                {
                    m_viArmyIDs.push_back(pArmyAI->GetID());
                    pArmyAI->Init(pArmyAI->GetID(),m_eOwner,m_iID);
                    pArmyAI->SetArmyAIState(ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE);
                    pArmyAI->SetFormationIndex(GetFormation());

                    // Figure out the initial rally point - for this operation it is wherever our civilian is standing
                    pArmyAI->SetGoalPlot(pTargetSite);
                    CvPlot* pMusterPt = pOurCivilian->plot();
                    SetMusterPlot(pMusterPt);
                    pArmyAI->SetXY(pMusterPt->getX(), pMusterPt->getY());
                    SetDefaultArea(pMusterPt->getArea());

                    // Add the settler to our army
                    pArmyAI->AddUnit(pOurCivilian->GetID(), 0);

                    // Add the escort as a unit we need to build
                    m_viListOfUnitsWeStillNeedToBuild.clear();
                    OperationSlot thisOperationSlot;
                    thisOperationSlot.m_iOperationID = m_iID;
                    thisOperationSlot.m_iArmyID = pArmyAI->GetID();
                    thisOperationSlot.m_iSlotID = 1;
                    m_viListOfUnitsWeStillNeedToBuild.push_back(thisOperationSlot);

                    // try to get the escort from existing units that are waiting around
                    GrabUnitsFromTheReserves(pMusterPt, pTargetSite);
                    if(pArmyAI->GetNumSlotsFilled() > 1)
                    {
                        pArmyAI->SetArmyAIState(ARMYAISTATE_WAITING_FOR_UNITS_TO_CATCH_UP);
                        m_eCurrentState = AI_OPERATION_STATE_GATHERING_FORCES;
                    }
                    else
                    {
                        // There was no escort immediately available.  Let's look for a "safe" city site instead
                        if (eOwner == -1 || GET_PLAYER(eOwner).getNumCities() > 1 || GET_PLAYER(eOwner).GetDiplomacyAI()->GetBoldness() > 5) // unless we'd rather play it safe
                        {
                            pNewTarget = FindBestTarget(pOurCivilian, true);
                        }

                        // If no better target, we'll wait it out for an escort
                        if(pNewTarget == NULL)
                        {
                            // Need to add it back in to list of what to build (was cleared before since marked optional)
                            m_viListOfUnitsWeStillNeedToBuild.clear();
                            OperationSlot thisOperationSlot2;
                            thisOperationSlot2.m_iOperationID = m_iID;
                            thisOperationSlot2.m_iArmyID = pArmyAI->GetID();
                            thisOperationSlot2.m_iSlotID = 1;
                            m_viListOfUnitsWeStillNeedToBuild.push_back(thisOperationSlot2);
                            m_eCurrentState = AI_OPERATION_STATE_RECRUITING_UNITS;
                        }

                        // Send the settler by himself to this safe location
                        else
                        {
                            m_bEscorted = false;

                            // Clear the list of units we need
                            m_viListOfUnitsWeStillNeedToBuild.clear();

                            // Change the muster point
                            pArmyAI->SetGoalPlot(pNewTarget);
                            SetMusterPlot(pOurCivilian->plot());
                            pArmyAI->SetXY(GetMusterPlot()->getX(), GetMusterPlot()->getY());

                            // Send the settler directly to the target
                            pArmyAI->SetArmyAIState(ARMYAISTATE_MOVING_TO_DESTINATION);
                            m_eCurrentState = AI_OPERATION_STATE_MOVING_TO_TARGET;
                        }
                    }
                    
                    //LogOperationStart();
                }
            } else {
                // Lost our target, abort
                self.state = .aborted(reason: .lostTarget)
            }
        }
    }

    /// If at target, found city; if at muster point, merge settler and escort and move out
    override func armyInPosition(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("can get gameModel")
        }

        switch self.state {

        case .none:
            // NOOP
            break
        case .aborted(_):

            // In all other cases use base class version
            return super.armyInPosition(in: gameModel)

        case .recruitingUnits:

            // In all other cases use base class version
            return super.armyInPosition(in: gameModel)

        case .gatheringForces:
            // If we were gathering forces, we have to insist that any escort is in the same plot as the settler.
            // If not we'll fall through and just stay in this state.

            // No escort, can just let base class handle it
            if !self.escorted {
                return super.armyInPosition(in: gameModel)
            }

            let settler = self.army?.unit(at: 0)
            let escort = self.army?.unit(at: 1)

            if escort == nil {
                // Escort died while gathering forces.  Abort (and return TRUE since state changed)
                self.state = .aborted(reason: .escortDied)
                return true
            }

            if escort != nil && settler != nil && escort!.location == settler!.location {

                // let's see if the target still makes sense (this is modified from RetargetCivilian)
                let betterTarget = self.findBestTarget(for: settler, in: gameModel)

                // No targets at all!  Abort
                if betterTarget == nil {
                    self.state = .aborted(reason: .noTarget)
                    return false
                }

                // If we have a target
                self.updateTarget(to: betterTarget)
                self.army?.goal = betterTarget!.point

                return super.armyInPosition(in: gameModel)
            }

        case .movingToTarget, .atTarget:

            // Call base class version and see, if it thinks we're done
            let stateChanged = super.armyInPosition(in: gameModel)

            // Now get the settler
            if let settler = self.army?.unit(at: 0) {

                guard let targetPosition = self.targetPosition else {
                    fatalError("cant get targetPosition")
                }

                let targetOwner = gameModel.tile(at: targetPosition)?.owner()

                // FIXME: || GetTargetPlot()->IsAdjacentOwnedByOtherTeam(pSettler->getTeam())
                if targetOwner != nil && targetOwner?.leader != self.player?.leader {

                    self.retarget(civilian: settler, within: self.army, in: gameModel)
                    settler.finishMoves()

                    if let escort = self.army?.unit(at: 1) {
                        escort.finishMoves()
                    }
                } else if settler.location == targetPosition && settler.canMove() && settler.canFound(at: settler.location, in: gameModel) {

                    // If the settler made it, we don't care about the entire army
                    settler.push(mission: UnitMission(type: .found), in: gameModel)
                    self.state = .successful
                } else if settler.location == targetPosition && !settler.canFound(at: settler.location, in: gameModel) {

                    // If we're at our target, but can no longer found a city, might be someone else beat us to this area
                    // So move back out, picking a new target
                    self.retarget(civilian: settler, within: self.army, in: gameModel)
                    settler.finishMoves()

                    if let escort = self.army?.unit(at: 1) {
                        escort.finishMoves()
                    }
                }
            }

            return stateChanged

        case .successful:
            // NOOP
            break
        }

        return false
    }

    /// Find the plot where we want to settle
    override func findBestTarget(for unit: AbstractUnit?, in gameModel: GameModel?) -> AbstractTile? {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        let area = gameModel?.area(of: unit.location)
        return self.player?.bestSettlePlot(for: unit, in: gameModel, escorted: self.escorted, area: area)
    }
}
