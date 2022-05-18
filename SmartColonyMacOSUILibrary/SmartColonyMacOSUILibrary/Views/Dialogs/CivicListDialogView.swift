//
//  CivicListDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.09.21.
//

import SwiftUI

struct CivicListDialogView: View {

    @ObservedObject
    var viewModel: CivicDialogViewModel

    public init(viewModel: CivicDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: "Civics", mode: .portrait, viewModel: self.viewModel) {

            VStack(alignment: .center, spacing: 0) {

                Button("Open Civic Tree") {
                    self.viewModel.openCivicTreeDialog()
                }
                .buttonStyle(DialogButtonStyle(state: .normal))

                ScrollView(.vertical, showsIndicators: true, content: {

                    LazyVStack(spacing: 4) {

                        ForEach(Array(self.viewModel.civicListViewModels.enumerated()), id: \.element) { index, civicViewModel in

                            CivicView(viewModel: civicViewModel, zIndex: 500 - Double(index))
                                .padding(0)
                                .onTapGesture {
                                    civicViewModel.selectCivic()
                                }
                        }

                        Spacer(minLength: 100)
                    }
                })
            }
        }
    }
}
