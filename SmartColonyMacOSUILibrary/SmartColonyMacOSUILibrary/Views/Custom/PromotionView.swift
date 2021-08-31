//
//  PromotionView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 31.08.21.
//

import SwiftUI

struct PromotionView: View {

    
}
#if DEBUG
struct TradeRouteView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let yields = Yields(food: 1, production: 2, gold: 3)
        let viewModel = TradeRouteViewModel(title: "Paris to Berlin", yields: yields, remainingTurns: 34)

        TradeRouteView(viewModel: viewModel)
    }
}
#endif
