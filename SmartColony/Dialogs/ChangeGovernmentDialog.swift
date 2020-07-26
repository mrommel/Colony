//
//  ChangeGovernmentDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class ChangeGovernmentDialogViewModel {

    let selectedGovernmentType: GovernmentType?
    let activeGovernmentTypes: [GovernmentType]
    
    var choosenGovernmentType: GovernmentType?
    
    init(government: AbstractGovernment?) {
        
        guard let government = government else {
            fatalError("cant get government")
        }
        
        let currentGovernmentType = government.currentGovernment()
        let possibleGovernments = government.possibleGovernments()
        
        self.selectedGovernmentType = currentGovernmentType
        self.activeGovernmentTypes = possibleGovernments
        
        self.choosenGovernmentType = selectedGovernmentType
    }
}

class ChangeGovernmentDialog: Dialog {

    var viewModel: ChangeGovernmentDialogViewModel
    
    // nodes
    var scrollNode: ScrollNode?
    var governmentNodes: [GovernmentNode] = []

    // MARK: Constructors

    init(with viewModel: ChangeGovernmentDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let changeGovernmentDialogConfiguration = uiParser.parse(from: "ChangeGovernmentDialog") else {
            fatalError("cant load ChangeGovernmentDialog configuration")
        }

        super.init(from: changeGovernmentDialogConfiguration)

        // fill in data from view model
        self.setupScrollView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupScrollView() {

        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 310, height: 370), contentSize: CGSize(width: 310, height: GovernmentType.all.count * 205 + 10))
        self.scrollNode?.position = CGPoint(x: 0, y: -400)
        self.scrollNode?.zPosition = self.zPosition + 1
        self.addChild(self.scrollNode!)
        
        for governmentType in GovernmentType.all {
            
            var state: GovernmentState = GovernmentState.disabled
            
            if governmentType == self.viewModel.choosenGovernmentType {
                state = .selected
            } else if self.viewModel.activeGovernmentTypes.contains(governmentType) {
                state = .active
            }
            
            let governmentNode = GovernmentNode(governmentType: governmentType, with: state)
            governmentNode.zPosition = 199
            governmentNode.delegate = self

            self.scrollNode?.addScrolling(child: governmentNode)
            self.governmentNodes.append(governmentNode)
        }
        
        self.updateLayout()
    }
    
    private func updateLayout() {

        var offsetY = self.scrollNode!.size.halfHeight - 10
        for governmentNode in self.governmentNodes {
            governmentNode.position = CGPoint(x: -150, y: offsetY)
            offsetY -= 205
            
            var state: GovernmentState = GovernmentState.disabled
            
            if governmentNode.governmentType == self.viewModel.choosenGovernmentType {
                state = .selected
            } else if self.viewModel.activeGovernmentTypes.contains(governmentNode.governmentType) {
                state = .active
            }
            governmentNode.state = state
            
            governmentNode.updateLayout()
        }
    }
}

extension ChangeGovernmentDialog: GovernmentNodeDelegate {
    
    func clicked(on governmentType: GovernmentType) {
        
        self.viewModel.choosenGovernmentType = governmentType
        self.updateLayout()
    }
}
