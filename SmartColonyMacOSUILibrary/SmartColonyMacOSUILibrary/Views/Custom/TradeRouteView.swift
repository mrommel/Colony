//
//  TradeRouteView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct TradeRouteView: View {

    @ObservedObject
    var viewModel: TradeRouteViewModel

    public init(viewModel: TradeRouteViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {

            HStack(alignment: .center, spacing: 4) {

                Image(nsImage: Globals.Icons.tradeRoute)
                    .resizable()
                    .frame(width: 16, height: 16)

                Text(self.viewModel.title)
                    .font(.headline)

                Spacer()

                Text("6")

                Image(nsImage: Globals.Icons.turns)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .padding(.leading, 14)
            .padding(.trailing, 14)

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

        let player = Player(leader: .alexander)
        let unit = Unit(at: HexPoint(x: 4, y: 4), type: .trader, owner: player)
        let viewModel = TradeRouteViewModel(unit: unit)

        TradeRouteView(viewModel: viewModel)
    }
}
#endif
