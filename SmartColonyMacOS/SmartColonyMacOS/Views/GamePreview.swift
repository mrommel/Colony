//
//  GamePreview.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 29.04.22.
//

import SwiftUI
import SmartColonyMacOSUILibrary

struct GamePreview: View {

    @ObservedObject
    var viewModel: GamePreviewViewModel

    public init(viewModel: GamePreviewViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        self.gameInfoIconView
            .padding(.bottom, 12)
    }

    private var gameInfoIconView: some View {

        HStack(alignment: .center, spacing: 17.5) {

            Image(nsImage: self.viewModel.civilizationImage())
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .toolTip(self.viewModel.civilizationToolTip())

            Image(nsImage: self.viewModel.leaderImage())
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .toolTip(self.viewModel.leaderToolTip())

            Image(nsImage: self.viewModel.handicapImage())
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .toolTip(self.viewModel.handicapToolTip())

            Image(nsImage: self.viewModel.speedImage())
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
        }
    }
}
