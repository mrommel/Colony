//
//  SelectItemsDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.09.21.
//

import SwiftUI
import SmartAILibrary

struct SelectItemsDialogView: View {

    @ObservedObject
    var viewModel: SelectItemsDialogViewModel

    public init(viewModel: SelectItemsDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: self.viewModel.title, mode: .portrait, viewModel: self.viewModel) {

            VStack {
                Text("Choose item:")

                ScrollView(.vertical, showsIndicators: true, content: {

                    LazyVStack(spacing: 4) {

                        ForEach(self.viewModel.itemViewModels, id: \.self) { itemViewModel in

                            SelectItemView(viewModel: itemViewModel)
                                .onTapGesture {
                                    itemViewModel.selected()
                                }
                                .padding(.top, 8)
                        }
                    }
                })
            }
        }
    }
}

#if DEBUG
struct SelectItemsDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = SelectItemsDialogViewModel()
        SelectItemsDialogView(viewModel: viewModel)
    }
}
#endif
