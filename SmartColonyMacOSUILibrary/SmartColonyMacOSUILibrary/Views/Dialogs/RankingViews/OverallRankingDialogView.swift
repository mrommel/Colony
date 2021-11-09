//
//  OverallRankingDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI

struct OverallRankingDialogView: View {

    @ObservedObject
    var viewModel: OverallRankingDialogViewModel

    public init(viewModel: OverallRankingDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        LazyVStack(spacing: 4) {

            ForEach(self.viewModel.overallRankingViewModels, id: \.self) { overallRankingViewModel in

                OverallRankingView(viewModel: overallRankingViewModel)
            }
        }
        .padding(.top, 8)
    }
}
