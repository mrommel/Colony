//
//  ChangeGovernmentDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class ChangeGovernmentDialogViewModel {
    
}

class ChangeGovernmentDialog: Dialog {
    
    var viewModel: ChangeGovernmentDialogViewModel
    
    // MARK: Constructors

    init(with viewModel: ChangeGovernmentDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let changeGovernmentDialogConfiguration = uiParser.parse(from: "ChangeGovernmentDialog") else {
            fatalError("cant load ChangeGovernmentDialog configuration")
        }

        super.init(from: changeGovernmentDialogConfiguration)

        // fill in data from view model
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
