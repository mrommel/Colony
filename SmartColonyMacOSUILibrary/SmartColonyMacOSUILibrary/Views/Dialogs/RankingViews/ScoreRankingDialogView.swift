//
//  ScoreRankingDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI

struct ScoreRankingDialogView: View {

    @ObservedObject
    var viewModel: ScoreRankingDialogViewModel

    public init(viewModel: ScoreRankingDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        LazyVStack(spacing: 4) {

            ForEach(self.viewModel.scoreRankingViewModels, id: \.self) { scoreRankingViewModel in

                ScoreRankingView(viewModel: scoreRankingViewModel)
            }
        }
        .padding(.top, 8)
    }
}
