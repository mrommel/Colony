//
//  ConfirmationDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 02.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class ConfirmationDialogViewModel {
    
    let question: String
    
    init(question: String) {
        
        self.question = question
    }
}

class ConfirmationDialog: Dialog {

    var viewModel: ConfirmationDialogViewModel

    init(with viewModel: ConfirmationDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let confirmationDialogConfiguration = uiParser.parse(from: "ConfirmationDialog") else {
            fatalError("cant load ConfirmationDialog configuration")
        }

        super.init(from: confirmationDialogConfiguration)
        
        self.set(text: self.viewModel.question, identifier: "summary")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
