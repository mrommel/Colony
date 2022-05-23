//
//  TechListDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.09.21.
//

import SwiftUI

struct TechListDialogView: View {

    @ObservedObject
    var viewModel: TechDialogViewModel

    public init(viewModel: TechDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: "Techs", mode: .portrait, viewModel: self.viewModel) {

            VStack(alignment: .center, spacing: 0) {

                Button("Open Tech Tree") {
                    self.viewModel.openTechTreeDialog()
                }
                .buttonStyle(DialogButtonStyle(state: .normal))

                ScrollView(.vertical, showsIndicators: true, content: {

                    LazyVStack(spacing: 4) {

                        ForEach(Array(self.viewModel.techListViewModels.enumerated()), id: \.element) { index, techViewModel in

                            TechView(viewModel: techViewModel, zIndex: 50 - Double(index))
                                .padding(0)
                                .onTapGesture {
                                    techViewModel.selectTech()
                                }
                        }

                        Spacer(minLength: 100)
                    }
                })
            }
        }
    }
}
