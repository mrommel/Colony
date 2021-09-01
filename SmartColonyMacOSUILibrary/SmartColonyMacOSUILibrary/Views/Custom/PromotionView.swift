//
//  PromotionView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 31.08.21.
//

import SwiftUI
import SmartAILibrary

struct PromotionView: View {

    @ObservedObject
    var viewModel: PromotionViewModel

    public init(viewModel: PromotionViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(alignment: .top, spacing: 4) {

            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.leading, 8)

            VStack(alignment: .leading, spacing: 4) {

                Text(self.viewModel.name)
                    .font(.headline)

                Text(self.viewModel.effect)
            }
            .padding(.leading, 4)
            .padding(.trailing, 8)

            Spacer()
        }
        .frame(width: 300, height: 65)
        .onTapGesture {
            self.viewModel.selectPromotion()
        }
        .background(
            Image(nsImage: self.viewModel.background())
                .resizable(capInsets: EdgeInsets(all: 15))
        )
    }
}

#if DEBUG
struct PromotionView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModelAlpine = PromotionViewModel(promotionType: .alpine, state: .possible)
        PromotionView(viewModel: viewModelAlpine)

        let viewModelCamouflage = PromotionViewModel(promotionType: .camouflage, state: .gained)
        PromotionView(viewModel: viewModelCamouflage)

        let viewModelCommando = PromotionViewModel(promotionType: .commando, state: .disabled)
        PromotionView(viewModel: viewModelCommando)
    }
}
#endif
