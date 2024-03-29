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

            HStack(alignment: .top, spacing: 4) {

                self.yieldButtons

                self.tradeRouteButton

                self.envoysButton

                self.resourceButtons
                    .padding(.top, 1)

                #if DEBUG
                if #available(macOS 12.0, *) {
                    Text("Debug")
                        .frame(width: 60, height: 16)
                        .padding(.leading, 40)
                        .padding(.top, 2)
                        .onTapGesture {
                            print("show debug menu")
                        }
                }
                #endif

                Spacer()

                Text(self.viewModel.turnYearText)
                    .padding(.trailing, 3)

                // ?

                Image(nsImage: ImageCache.shared.image(for: "menu"))
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .onTapGesture {
                        self.viewModel.menuClicked()
                    }
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
                .onTapGesture {
                    self.viewModel.tradeRoutesClicked()
                }
        )
    }

    private var envoysButton: AnyView {

        AnyView(
            HStack(alignment: .center, spacing: 4) {
                Image(nsImage: Globals.Icons.envoy)
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .center)

                Text(self.viewModel.envoysLabelText)
                    .foregroundColor(Color.white)
                    .font(.caption)
            }
                .padding(.leading, 8)
                .padding(.trailing, 8)
                .padding(.top, 4)
                .padding(.bottom, 4)
                .onTapGesture {
                    self.viewModel.envoysClicked()
                }
        )
    }

    private var resourceButtons: AnyView {

        if self.viewModel.showResources {
            return AnyView(
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

                    if self.viewModel.aluminumValueViewModel.value > 0 {
                        ResourceValueView(viewModel: self.viewModel.aluminumValueViewModel)
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
        } else {
            return AnyView(EmptyView())
        }
    }
}

#if DEBUG
struct TopBarView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = TopBarViewModel()

        TopBarView(viewModel: viewModel)
    }
}
#endif
