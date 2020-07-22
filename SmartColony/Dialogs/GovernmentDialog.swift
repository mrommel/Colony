//
//  GovernmentDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 21.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class GovernmentDialogViewModel {
    
    let currentGovernmentName: String
    let currentGovernmentIconName: String
    let bonusSummary: String
    let legacySummary: String
    
    let cardsInMilitarySlot: [PolicyCardType]
    let cardsInEconomicSlot: [PolicyCardType]
    let cardsInDiplomaticSlot: [PolicyCardType]
    let cardsInWildcardSlot: [PolicyCardType]
    
    init(government: AbstractGovernment?, in gameModel: GameModel?) {
        
        guard let government = government else {
            fatalError("can't get government")
        }
        
        if let currentGovernment = government.currentGovernment() {
            self.currentGovernmentName = "Current Government: \(currentGovernment.name())"
            self.currentGovernmentIconName = currentGovernment.iconTexture()
            self.bonusSummary = currentGovernment.bonusSummary()
            self.legacySummary = currentGovernment.legacySummary()
            
            self.cardsInMilitarySlot = [.caravansaries, .agoge] //government.policyCardSet().cards(of: .military)
            self.cardsInEconomicSlot = [.colonization] //government.policyCardSet().cards(of: .economic)
            self.cardsInDiplomaticSlot = [.discipline] //government.policyCardSet().cards(of: .diplomatic)
            self.cardsInWildcardSlot = [.limitanei]
        } else {
            self.currentGovernmentName = "Please select government"
            self.currentGovernmentIconName = "questionmark"
            self.bonusSummary =  "-"
            self.legacySummary = "-"
            
            self.cardsInMilitarySlot = []
            self.cardsInEconomicSlot = []
            self.cardsInDiplomaticSlot = []
            self.cardsInWildcardSlot = []
        }
    }
}

class GovernmentDialog: Dialog {

    var viewModel: GovernmentDialogViewModel
    
    // nodes
    var scrollNode: ScrollNode?
    
    var militaryPolicyCardNodes: [PolicyCardNode] = []
    
    // MARK: Constructors

    init(with viewModel: GovernmentDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let governmentDialogConfiguration = uiParser.parse(from: "GovernmentDialog") else {
            fatalError("cant load GovernmentDialog configuration")
        }

        super.init(from: governmentDialogConfiguration)
        
        // fill in data from view model
        self.set(text: self.viewModel.currentGovernmentName, identifier: "current_government")
        self.set(imageNamed: self.viewModel.currentGovernmentIconName, identifier: "current_government_icon")
        
        self.set(text: self.viewModel.bonusSummary, identifier: "current_bonus")
        self.set(text: self.viewModel.legacySummary, identifier: "current_legacy")
        
        self.setupScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
        
        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 300, height: 270), contentSize: CGSize(width: 350, height: 800))
        self.scrollNode?.position = CGPoint(x: 0, y: -400)
        self.scrollNode?.zPosition = self.zPosition + 1
        self.addChild(self.scrollNode!)
        
        for card in self.viewModel.cardsInMilitarySlot {
            let cardNode = PolicyCardNode(policyCard: card)
            cardNode.zPosition = 199
            
            self.scrollNode?.addScrolling(child: cardNode)
            self.militaryPolicyCardNodes.append(cardNode)
        }
        
        self.updateLayout()
    }
    
    private func updateLayout() {

        var offsetX = -self.militaryPolicyCardNodes.count * 80 / 2
        for militaryPolicyCardNode in self.militaryPolicyCardNodes {
            militaryPolicyCardNode.position = CGPoint(x: offsetX, y: 110)
            
            offsetX += 80
        }
    }
}
