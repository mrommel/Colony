//
//  ChangePoliciesDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class ChangePoliciesDialogViewModel {
    
}

class ChangePoliciesDialog: Dialog {
    
    var viewModel: ChangePoliciesDialogViewModel
    
    // MARK: Constructors

    init(with viewModel: ChangePoliciesDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let changePoliciesDialogConfiguration = uiParser.parse(from: "ChangePoliciesDialog") else {
            fatalError("cant load ChangePoliciesDialog configuration")
        }

        super.init(from: changePoliciesDialogConfiguration)

        // fill in data from view model
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
