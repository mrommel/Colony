//
//  ChangePoliciesDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class ChangePoliciesDialogViewModel {

    var selectedPolicyCards: [PolicyCardType]
    let possiblePolicyCards: [PolicyCardType]

    var choosenPolicyCardSet: AbstractPolicyCardSet
    let slots: PolicyCardSlots

    init(government: AbstractGovernment?) {

        guard let government = government else {
            fatalError("cant get government")
        }

        self.choosenPolicyCardSet = government.policyCardSet()
        self.slots = government.policyCardSlots()

        self.selectedPolicyCards = government.policyCardSet().cards()
        self.possiblePolicyCards = government.possiblePolicyCards()
    }

    func isSelected(policyCardType: PolicyCardType) -> Bool {

        return self.selectedPolicyCards.contains(policyCardType)
    }

    func select(policyCardType: PolicyCardType) {

        self.choosenPolicyCardSet.add(card: policyCardType)
        self.selectedPolicyCards = self.choosenPolicyCardSet.cards()
    }

    func unselect(policyCardType: PolicyCardType) {

        self.choosenPolicyCardSet.remove(card: policyCardType)
        self.selectedPolicyCards = self.choosenPolicyCardSet.cards()
    }

    func verify() -> Bool {

        return self.choosenPolicyCardSet.filled(in: self.slots)
    }
}

class ChangePoliciesDialog: Dialog {

    // variables
    var viewModel: ChangePoliciesDialogViewModel

    // nodes
    var scrollNode: ScrollNode?
    var policyCardNodes: [PolicyCardNode] = []

    // MARK: Constructors

    init(with viewModel: ChangePoliciesDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let changePoliciesDialogConfiguration = uiParser.parse(from: "ChangePoliciesDialog") else {
            fatalError("cant load ChangePoliciesDialog configuration")
        }

        super.init(from: changePoliciesDialogConfiguration)

        // fill in data from view model
        self.setupScrollView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupScrollView() {

        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 310, height: 370), contentSize: CGSize(width: 310, height: PolicyCardType.all.count / 3 * 105 + 10))
        self.scrollNode?.position = CGPoint(x: 0, y: -400)
        self.scrollNode?.zPosition = self.zPosition + 1
        self.addChild(self.scrollNode!)

        for policyCardType in PolicyCardType.all {

            var state: PolicyCardState = PolicyCardState.disabled

            if self.viewModel.selectedPolicyCards.contains(policyCardType) {
                state = .selected
            } else if self.viewModel.possiblePolicyCards.contains(policyCardType) {
                state = .active
            }

            let policyCardNode = PolicyCardNode(policyCardType: policyCardType, state: state)
            policyCardNode.zPosition = 199
            policyCardNode.delegate = self

            self.scrollNode?.addScrolling(child: policyCardNode)
            self.policyCardNodes.append(policyCardNode)
        }

        // make bottom buttons appear above scrollview
        self.item(with: "okay_button")?.zPosition = 500

        self.updateLayout()
    }

    override func handleOkay() {

        if self.viewModel.verify() {
            super.handleOkay()
        }
    }

    private func updateLayout() {

        let offsetY = self.scrollNode!.size.halfHeight - 10
        for (index, policyCardNode) in self.policyCardNodes.enumerated() {

            let dx: CGFloat = -150.0 + CGFloat(index % 3) * 100.0
            let dy: CGFloat = offsetY - CGFloat(index / 3) * 105.0
            policyCardNode.position = CGPoint(x: dx, y: dy)

            policyCardNode.updateLayout()
        }

        if self.viewModel.verify() {
            self.set(text: self.viewModel.slots.hint(), identifier: "policies_warning")
        } else {
            self.set(text: "Invalid combination", identifier: "policies_warning")
        }
    }
}

extension ChangePoliciesDialog: PolicyCardNodeDelegate {

    func clicked(on policyCardType: PolicyCardType) {

        if self.viewModel.isSelected(policyCardType: policyCardType) {
            self.viewModel.unselect(policyCardType: policyCardType)
        } else {
            self.viewModel.select(policyCardType: policyCardType)
        }

        self.updateLayout()
    }
}
