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

                        ForEach(self.viewModel.techListViewModels) { techViewModel in

                            TechView(viewModel: techViewModel)
                                .padding(0)
                                .onTapGesture {
                                    techViewModel.selectTech()
                                }
                                .id("tech-\(techViewModel.id)")
                        }
                    }
                })
            }
        }
    }
}
