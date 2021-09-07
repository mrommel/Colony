//
//  TradeRoutesDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.08.21.
//

import SwiftUI

struct TradeRoutesDialogView: View {

    @ObservedObject
    var viewModel: TradeRoutesDialogViewModel

    private var gridItemLayout = [GridItem(.fixed(300))]

    public init(viewModel: TradeRoutesDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            VStack(spacing: 10) {
                HStack {

                    Spacer()

                    Text("Trade Routes")
                        .font(.title2)
                        .bold()
                        .padding(.top, 14)

                    Spacer()
                }

                self.headerView

                self.contentView

                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Okay")
                })
                .buttonStyle(DialogButtonStyle())
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 400, height: 450, alignment: .top)
        .dialogBackground()
    }

    private var headerView: AnyView {

        AnyView(
            HStack(alignment: .center, spacing: 10) {
                Button("my routes") {
                    self.viewModel.select(viewType: .myRoutes)
                }
                .buttonStyle(DialogButtonStyle(state: self.viewModel.viewType == .myRoutes ? .highlighted : .normal))

                Button("foreign") {
                    self.viewModel.select(viewType: .foreign)
                }
                .buttonStyle(DialogButtonStyle(state: self.viewModel.viewType == .foreign ? .highlighted : .normal))

                Button("available") {
                    self.viewModel.select(viewType: .available)
                }
                .buttonStyle(DialogButtonStyle(state: self.viewModel.viewType == .available ? .highlighted : .normal))
            }
        )
    }

    private var contentView: AnyView {

        AnyView(
            VStack(alignment: .leading, spacing: 6) {

                if self.viewModel.viewType == .available {

                    DataPicker(title: "Choose Start City",
                               data: self.viewModel.startCities,
                               selection: $viewModel.selectedStartCityIndex)
                }

                ScrollView(.vertical, showsIndicators: true, content: {

                    if self.viewModel.tradeRouteViewModels.isEmpty {
                        Text("no trade routes yet")
                            .padding(.top, 50)
                    } else {
                        LazyVGrid(columns: gridItemLayout, spacing: 10) {

                            ForEach(self.viewModel.tradeRouteViewModels, id: \.self) { tradeRouteViewModel in

                                TradeRouteView(viewModel: tradeRouteViewModel)
                                    .padding(.top, 8)
                            }
                        }
                    }
                })
                .frame(width: 340, height: self.viewModel.viewType == .available ? 270 : 300, alignment: .center)
                .border(Color.gray)
            }
            .frame(width: 340, height: 300, alignment: .center)
        )
    }
}

#if DEBUG
struct TradeRoutesDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = TradeRoutesDialogViewModel()

        TradeRoutesDialogView(viewModel: viewModel)
    }
}
#endif
