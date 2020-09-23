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
    
    override init() {

        super.init(type: .quickColonize)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)
        
        self.moveType = .singleHex

        // Find the free civilian (that triggered this operation)
        

        if let ourCivilian = self.findBestCivilian(in: gameModel) {
            
            // Find a destination (not worrying about safe paths)
            if let targetSite = self.findBestTarget(for: ourCivilian, onlySafePaths: false, in: gameModel) {
                
                self.targetPosition = targetSite.point

                self.army = Army(of: self.player, for: self, with: self.formation(in: gameModel))
                self.army?.state = .waitingForUnitsToReinforce

                // Figure out the initial rally point - for this operation it is wherever our civilian is standing
                self.army?.goal = targetSite.point
                self.musterPosition = ourCivilian.location
                self.army?.position = ourCivilian.location
                self.army?.state = .movingToDestination
                self.area = gameModel?.area(of: ourCivilian.location)

                // Add the settler to our army
                self.army?.add(unit: ourCivilian, to: 0)
                
                self.escorted = false

                self.state = .movingToTarget;
                //LogOperationStart();
                
            } else {
                // Lost our target, abort
                self.state = .aborted(reason: .lostTarget)
            }
        }
    }
    
    override func formation(in gameModel: GameModel?) -> UnitFormationType {
        
        return .quickColonySettler // MUFORMATION_QUICK_COLONY_SETTLER
    }
    
    override func findBestCivilian(in gameModel: GameModel?) -> AbstractUnit? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let units = gameModel.units(of: player)

        for unitRef in units {

            if let unit = unitRef {

                if unit.task() == self.civilianType {

                    if unit.army() == nil {

                        return unitRef
                    }
                }
            }
        }

        return nil
    }

    /// Find the plot where we want to settle
    override func findBestTarget(for unit: AbstractUnit?, onlySafePaths: Bool, in gameModel: GameModel?) -> AbstractTile? {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        let area = gameModel?.area(of: unit.location)
        if let tile = self.player?.bestSettlePlot(for: unit, in: gameModel, escorted: false, area: area) {
            return tile
        }
        
        self.area = nil
        return self.player?.bestSettlePlot(for: unit, in: gameModel, escorted: false, area: nil)
    }
}
