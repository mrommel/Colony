//
//  MapLoadingDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class MapLoadingDialogViewModel {
    
    let civilizationImage: String
    let leaderName: String
    let abilityName: String
    
    init(civilizationImage: String, leaderName: String, abilityName: String) {
        
        self.civilizationImage = civilizationImage
        self.leaderName = leaderName
        self.abilityName = abilityName
    }
}

class MapLoadingDialog: Dialog {
    
    // variables
    var viewModel: MapLoadingDialogViewModel
    
    // MARK: Constructors
    
    init(with viewModel: MapLoadingDialogViewModel) {
        
        self.viewModel = viewModel
        
        let uiParser = UIParser()
        guard let mapLoadingDialogConfiguration = uiParser.parse(from: "MapLoadingDialog") else {
            fatalError("cant load MapLoadingDialog configuration")
        }
        
        super.init(from: mapLoadingDialogConfiguration)
        
        // fill
        self.set(imageNamed: viewModel.civilizationImage, identifier: "civilization_image")
        self.set(text: viewModel.leaderName, identifier: "leader_name")
        self.set(text: viewModel.abilityName, identifier: "ability_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showProgress(value: Double, text: String) {
        
        self.set(progress: value, identifier: "progress")
        self.set(text: text, identifier: "text")
    }
}
