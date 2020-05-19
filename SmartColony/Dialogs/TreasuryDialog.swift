//
//  TreasuryDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class TreasuryDialogViewModel {
    
    // MARK: properties
    
    let goldFromCitiesValue: String
    let goldFromDiplomacyValue: String
    let goldForCityMaintenanceValue: String
    let goldForUnitMaintenanceValue: String
    let goldForDiplomacyValue: String
    let incomeValue: String
    
    // MARK: constructors
    
    init(treasury: AbstractTreasury?, in gameModel: GameModel?) {
        
        guard let treasury = treasury else {
            fatalError("can't get treasury")
        }
            
        // in
        self.goldFromCitiesValue = String(format: "%.1", treasury.goldFromCities(in: gameModel))
        self.goldFromDiplomacyValue = String(format: "%.1", treasury.goldPerTurnFromDiplomacy(in: gameModel))
        
        // out
        self.goldForCityMaintenanceValue = String(format: "%.1", treasury.goldForBuildingMaintenance(in: gameModel))
        self.goldForUnitMaintenanceValue = String(format: "%.1", treasury.goldForUnitMaintenance(in: gameModel))
        self.goldForDiplomacyValue = String(format: "%.1", treasury.goldPerTurnForDiplomacy(in: gameModel))
        
        // saldo
        self.incomeValue = String(format: "%.1", treasury.calculateGrossGold(in: gameModel))
    }
}

class TreasuryDialog: Dialog {
    
    // MARK: properties
    
    let viewModel: TreasuryDialogViewModel
    
    // MARK: constructors
    
    init(with viewModel: TreasuryDialogViewModel) {
        
        self.viewModel = viewModel
        
        let uiParser = UIParser()
        guard let treasuryDialogConfiguration = uiParser.parse(from: "TreasuryDialog") else {
            fatalError("cant load TreasuryDialog configuration")
        }

        super.init(from: treasuryDialogConfiguration)

        // in
        self.set(text: self.viewModel.goldFromCitiesValue, identifier: "gold_from_cities_value")
        self.set(text: self.viewModel.goldFromDiplomacyValue, identifier: "gold_from_deals_value")
        
        // out
        self.set(text: self.viewModel.goldForCityMaintenanceValue, identifier: "gold_for_cities_value")
        self.set(text: self.viewModel.goldForUnitMaintenanceValue, identifier: "gold_for_units_value")
        self.set(text: self.viewModel.goldForDiplomacyValue, identifier: "gold_for_deals_value")
        
        // sum
        self.set(text: self.viewModel.incomeValue, identifier: "income_value")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
