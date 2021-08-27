//
//  GoodyHutRewardPopup.swift
//  SmartColony
//
//  Created by Michael Rommel on 20.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class GoodyHutRewardPopupViewModel {

    let iconTexture: String
    let titleText: String
    let summaryText: String

    init(goodyType: GoodyType, in cityName: String?) {

        self.iconTexture = "questionmark" // goodyType.iconTexture()
        self.titleText = "The people from a tribal village gave you a present."
        self.summaryText = goodyType.effect()
    }
}

class GoodyHutRewardPopup: Dialog {

    let viewModel: GoodyHutRewardPopupViewModel

    init(viewModel: GoodyHutRewardPopupViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let goodyHutRewardPopupConfiguration = uiParser.parse(from: "GoodyHutRewardPopup") else {
            fatalError("cant load GoodyHutRewardPopup configuration")
        }

        super.init(from: goodyHutRewardPopupConfiguration)

        self.set(imageNamed: self.viewModel.iconTexture, identifier: "popup_image")
        self.set(text: self.viewModel.titleText, identifier: "popup_title")
        self.set(text: self.viewModel.summaryText, identifier: "popup_summary")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
