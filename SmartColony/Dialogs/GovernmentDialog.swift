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
    let bonus1Summary: String
    let bonus2Summary: String

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
            self.bonus1Summary = currentGovernment.bonus1Summary().replaceIcons()
            self.bonus2Summary = currentGovernment.bonus2Summary().replaceIcons()

            self.cardsInMilitarySlot = GovernmentDialogViewModel.cardsFilling(slot: .military, in: government)
            self.cardsInEconomicSlot = GovernmentDialogViewModel.cardsFilling(slot: .economic, in: government)
            self.cardsInDiplomaticSlot = GovernmentDialogViewModel.cardsFilling(slot: .diplomatic, in: government)
            self.cardsInWildcardSlot = GovernmentDialogViewModel.cardsFilling(slot: .wildcard, in: government)
        } else {
            self.currentGovernmentName = "Please select government"
            self.currentGovernmentIconName = "questionmark"
            self.bonus1Summary = ""
            self.bonus2Summary = ""

            self.cardsInMilitarySlot = []
            self.cardsInEconomicSlot = []
            self.cardsInDiplomaticSlot = []
            self.cardsInWildcardSlot = []
        }
    }

    static func cardsFilling(slot slotType: PolicyCardSlotType, in government: AbstractGovernment?) -> [PolicyCardType] {

        guard let government = government else {
            fatalError("can't get government")
        }

        let cardSetSlots = government.policyCardSlots()
        var cards: [PolicyCardType] = government.policyCardSet().cardsFilled(in: slotType, of: cardSetSlots)

        while cards.count < cardSetSlots.numberOfSlots(in: slotType) {
            cards.append(.slot)
        }

        return cards
    }
}

class GovernmentDialog: Dialog {

    var viewModel: GovernmentDialogViewModel

    // nodes
    var scrollNode: ScrollNode?

    var militaryPolicyCardNodes: [PolicyCardNode] = []
    var economicPolicyCardNodes: [PolicyCardNode] = []
    var diplomaticPolicyCardNodes: [PolicyCardNode] = []
    var wildcardPolicyCardNodes: [PolicyCardNode] = []

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

        self.set(text: self.viewModel.bonus1Summary, identifier: "current_bonus1")
        self.set(text: self.viewModel.bonus2Summary, identifier: "current_bonus2")

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
            let cardNode = PolicyCardNode(policyCardType: card, state: .none)
            cardNode.zPosition = 199

            self.scrollNode?.addScrolling(child: cardNode)
            self.militaryPolicyCardNodes.append(cardNode)
        }
        
        for card in self.viewModel.cardsInEconomicSlot {
            let cardNode = PolicyCardNode(policyCardType: card, state: .none)
            cardNode.zPosition = 199

            self.scrollNode?.addScrolling(child: cardNode)
            self.economicPolicyCardNodes.append(cardNode)
        }
        
        for card in self.viewModel.cardsInDiplomaticSlot {
            let cardNode = PolicyCardNode(policyCardType: card, state: .none)
            cardNode.zPosition = 199

            self.scrollNode?.addScrolling(child: cardNode)
            self.diplomaticPolicyCardNodes.append(cardNode)
        }
        
        for card in self.viewModel.cardsInWildcardSlot {
            let cardNode = PolicyCardNode(policyCardType: card, state: .none)
            cardNode.zPosition = 199

            self.scrollNode?.addScrolling(child: cardNode)
            self.wildcardPolicyCardNodes.append(cardNode)
        }

        self.updateLayout()
    }

    private func updateLayout() {

        var offsetX = -self.militaryPolicyCardNodes.count * 80 / 2
        for militaryPolicyCardNode in self.militaryPolicyCardNodes {
            militaryPolicyCardNode.position = CGPoint(x: offsetX, y: 110)

            offsetX += 80
        }
        
        offsetX = -self.economicPolicyCardNodes.count * 80 / 2
        for economicPolicyCardNode in self.economicPolicyCardNodes {
            economicPolicyCardNode.position = CGPoint(x: offsetX, y: 0)

            offsetX += 80
        }
        
        offsetX = -self.diplomaticPolicyCardNodes.count * 80 / 2
        for diplomaticPolicyCardNode in self.diplomaticPolicyCardNodes {
            diplomaticPolicyCardNode.position = CGPoint(x: offsetX, y: -110)

            offsetX += 80
        }
        
        offsetX = -self.wildcardPolicyCardNodes.count * 80 / 2
        for wildcardPolicyCardNode in self.wildcardPolicyCardNodes {
            wildcardPolicyCardNode.position = CGPoint(x: offsetX, y: -220)

            offsetX += 80
        }
    }
}
