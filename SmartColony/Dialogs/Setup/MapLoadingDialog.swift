//
//  MapLoadingDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class MapLoadingDialogViewModel {
    
    let leaderImage: String
    let leaderName: String
    let leaderIntro: String
    let leaderAbilityName: String
    let leaderAbilities: [String]
    let civilizationImage: String
    let civilizationAbilityName: String
    let civilizationAbilities: [String]
    
    init(from leader: LeaderType) {
        
        self.leaderImage = leader.iconTexture()
        self.leaderName = leader.name()
        self.leaderIntro = leader.intro()
        self.leaderAbilityName = leader.ability().name()
        self.leaderAbilities = leader.ability().effects()
        
        self.civilizationImage = leader.civilization().iconTexture()
        self.civilizationAbilityName = leader.civilization().ability().name()
        self.civilizationAbilities = leader.civilization().ability().effects()
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
        self.set(imageNamed: viewModel.leaderImage, identifier: "leader_image")
        self.set(text: viewModel.leaderName, identifier: "leader_name")
        self.set(text: viewModel.leaderIntro, identifier: "leader_intro")
        
        self.set(text: viewModel.leaderAbilityName, identifier: "leader_ability_name")
        self.set(text: viewModel.leaderAbilities.joined(separator: " "), identifier: "leader_abilities")
        
        self.set(text: viewModel.civilizationAbilityName, identifier: "civilization_ability_name")
        self.set(text: viewModel.civilizationAbilities.joined(separator: " "), identifier: "civilization_abilities")
        
        self.item(with: "okay_button")?.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showBeginGameButton() {
        
        self.item(with: "progress")?.isHidden = true
        self.item(with: "progress_text")?.isHidden = true
        self.item(with: "okay_button")?.isHidden = false
    }
    
    func showProgress(value: Double, text: String) {
        
        self.set(progress: value, identifier: "progress")
        self.set(text: text, identifier: "progress_text")
    }
}
