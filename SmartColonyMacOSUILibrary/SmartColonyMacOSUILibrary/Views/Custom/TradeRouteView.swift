//
//  TradeRouteView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.08.21.
//

import SwiftUI
import SmartAILibrary

struct TradeRouteView: View {

    @ObservedObject
    var viewModel: TradeRouteViewModel

    public init(viewModel: TradeRouteViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center, spacing: 10) {
                
                //Image(nsImage: <#T##NSImage#>) traderoute
                
                Text(self.viewModel.title)
                    .font(.headline)
                
                // remaining turns
                
                Spacer()
            }
            .padding(.leading, 14)
            
            HStack(alignment: .center, spacing: 0) {
                
                YieldValueView(viewModel: self.viewModel.foodYieldViewModel)
                
                YieldValueView(viewModel: self.viewModel.productionYieldViewModel)
                
                YieldValueView(viewModel: self.viewModel.goldYieldViewModel)
                
                Spacer()
            }
            .padding(.leading, 10)
        }
        .frame(width: 300, height: 65)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-button-clicked"))
                .resizable(capInsets: EdgeInsets(all: 15))
                .hueRotation(Angle(degrees: 135))
        )
    }
}

#if DEBUG
struct TradeRouteView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = TradeRouteViewModel(
            tradeRoute: TradeRoute(
                start: HexPoint(x: 2, y: 2),
                posts: [],
                end: HexPoint(x: 5, y: 7)
            )
        )

        TradeRouteView(viewModel: viewModel)
    }
}
#endif
