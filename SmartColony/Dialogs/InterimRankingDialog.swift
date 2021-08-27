//
//  InterimRankingDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 25.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class InterimRankingDialog: Dialog {

    let player: AbstractPlayer?
    let rankingData: RankingData

    init(for player: AbstractPlayer?, with rankingData: RankingData) {

        self.player = player
        self.rankingData = rankingData

        let uiParser = UIParser()
        guard let interimRankingDialogConfiguration = uiParser.parse(from: "InterimRankingDialog") else {
            fatalError("cant load interimRankingDialogConfiguration configuration")
        }

        super.init(from: interimRankingDialogConfiguration)

        var chartText = ""

        for data in self.rankingData.data {

            let lastScore = data.data.last!
            chart_text += "\(data.leader): \(lastScore)points\n"
        }

        self.set(text: chartText, identifier: "chart")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
