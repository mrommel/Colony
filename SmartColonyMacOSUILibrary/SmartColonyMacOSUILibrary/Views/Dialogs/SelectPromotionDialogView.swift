//
//  SelectPromotionDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 31.08.21.
//

import SwiftUI

struct SelectPromotionDialogView: View {

    @ObservedObject
    var viewModel: SelectPromotionDialogViewModel

    var body: some View {

        BaseDialogView(title: "Select promotion", viewModel: self.viewModel) {
            ScrollView(.vertical, showsIndicators: true, content: {

                LazyVStack(spacing: 4) {

                    ForEach(self.viewModel.promotionViewModels, id: \.self) { promotionViewModel in

                        PromotionView(viewModel: promotionViewModel)
                            .padding(.top, 8)
                    }
                }
            })
        }
    }
}

#if DEBUG
struct SelectPromotionDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = SelectPromotionDialogViewModel()

        SelectPromotionDialogView(viewModel: viewModel)
    }
}
#endif
