//
//  TopBarView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.05.21.
//

import SwiftUI
import SmartAssets

public struct TopBarView: View {

    @ObservedObject
    public var viewModel: TopBarViewModel

    private let cornerRadius: CGFloat = 10

    public var body: some View {

        VStack(alignment: .trailing) {

            HStack(alignment: .top, spacing: 10) {

                self.yieldButtons

                self.tradeRouteButton

                self.resourceButtons
                    .padding(.top, 1)

                Spacer()

                Text(self.viewModel.turnYearText)
                    .padding(.trailing, 3)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 24, maxHeight: 24, alignment: .topLeading)
            .background(
                Image(nsImage: ImageCache.shared.image(for: "top-bar"))
                    .resizable()
            )

            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }

    private var yieldButtons: AnyView {

        AnyView(
            HStack(alignment: .center, spacing: 0) {

                YieldValueView(viewModel: self.viewModel.scienceYieldValueViewModel)

                YieldValueView(viewModel: self.viewModel.cultureYieldValueViewModel)

                YieldValueView(viewModel: self.viewModel.faithYieldValueViewModel)

                YieldValueView(viewModel: self.viewModel.goldYieldValueViewModel)

                YieldValueView(viewModel: self.viewModel.tourismYieldValueViewModel)
            }
        )
    }

    private var tradeRouteButton: AnyView {

        AnyView(
            HStack(alignment: .center, spacing: 4) {
                Image(nsImage: Globals.Icons.tradeRoute)
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .center)

                Text(self.viewModel.tradeRoutesLabelText)
                    .foregroundColor(Color.white)
                    .font(.caption)
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
            .padding(.top, 4)
            .padding(.bottom, 4)
        )
    }

    private var resourceButtons: AnyView {

        AnyView(
            HStack(alignment: .center, spacing: 0) {

                Spacer()
                    .frame(width: 4, height: 12)

                if self.viewModel.horsesValueViewModel.value > 0 {
                    ResourceValueView(viewModel: self.viewModel.horsesValueViewModel)
                }

                if self.viewModel.ironValueViewModel.value > 0 {
                    ResourceValueView(viewModel: self.viewModel.ironValueViewModel)
                }

                if self.viewModel.niterValueViewModel.value > 0 {
                    ResourceValueView(viewModel: self.viewModel.niterValueViewModel)
                }

                if self.viewModel.coalValueViewModel.value > 0 {
                    ResourceValueView(viewModel: self.viewModel.coalValueViewModel)
                }

                if self.viewModel.oilValueViewModel.value > 0 {
                    ResourceValueView(viewModel: self.viewModel.oilValueViewModel)
                }

                if self.viewModel.aluminiumValueViewModel.value > 0 {
                    ResourceValueView(viewModel: self.viewModel.aluminiumValueViewModel)
                }

                if self.viewModel.uraniumValueViewModel.value > 0 {
                    ResourceValueView(viewModel: self.viewModel.uraniumValueViewModel)
                }

                Spacer()
                    .frame(width: 4, height: 12)
            }
                .background(
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .strokeBorder(Color.black)
                        .background(Color.gray.opacity(0.2))
                )
                .cornerRadius(self.cornerRadius)
        )
    }
}

struct TopBarView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = TopBarViewModel()

        TopBarView(viewModel: viewModel)
    }
}
