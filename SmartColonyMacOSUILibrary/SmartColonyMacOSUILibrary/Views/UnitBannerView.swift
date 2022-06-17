//
//  UnitBannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 09.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct UnitGroupBoxStyle: GroupBoxStyle {

    func makeBody(configuration: Configuration) -> some View {

        VStack(alignment: .leading) {
            configuration.content
        }
        .padding(.top, 2)
        .padding(.bottom, 2)
        .padding(.leading, 6)
        .padding(.trailing, 6)
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }
}

struct UnitBannerView: View {

    @ObservedObject
    public var viewModel: UnitBannerViewModel

    @State
    var showBanner: Bool = false

    public var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            Spacer()

            HStack(alignment: .center, spacing: 0) {

                Spacer()

                VStack(alignment: .center, spacing: 0) {

                    self.commandsView

                    self.bannerView
                }
                .frame(width: 300)
                .offset(x: 0, y: self.showBanner ? 0 : 150)
                .onReceive(self.viewModel.$showBanner, perform: { value in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.showBanner = value
                    }
                })

                Spacer()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }

    private var commandsView: some View {

        HStack(alignment: .bottom, spacing: 1) {

            Image(nsImage: self.viewModel.listImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .onTapGesture {
                    self.viewModel.listClicked()
                }
                .tooltip(self.viewModel.unitListTooltip(), side: .top)

            Spacer()
                .frame(minHeight: 0, maxHeight: 50)

            UnitCommandView(viewModel: self.viewModel.command6ViewModel)

            UnitCommandView(viewModel: self.viewModel.command5ViewModel)

            UnitCommandView(viewModel: self.viewModel.command4ViewModel)

            UnitCommandView(viewModel: self.viewModel.command3ViewModel)

            UnitCommandView(viewModel: self.viewModel.command2ViewModel)

            UnitCommandView(viewModel: self.viewModel.command1ViewModel)

            UnitCommandView(viewModel: self.viewModel.command0ViewModel)

        }
        .frame(width: 280, height: 32)
    }

    private var bannerView: some View {

        ZStack(alignment: .bottom) {

            Image(nsImage: ImageCache.shared.image(for: "unit-banner"))
                .resizable()
                .scaledToFit()
                .frame(width: 340, height: 106)

            ProgressCircle(value: self.$viewModel.unitHealthValue,
                           maxValue: 1.0,
                           style: .line,
                           backgroundColor: Color(Globals.Colors.progressBackground),
                           foregroundColor: Color(.green),
                           lineWidth: 5)
                .frame(height: 52)
                .offset(x: -122.3, y: -26.5)

            Image(nsImage: self.viewModel.unitTypeImage())
                .resizable()
                .scaledToFit()
                .frame(width: 46, height: 46)
                .background(Color(Globals.Colors.dialogBackground))
                .clipShape(Circle())
                .offset(x: -122.3, y: -29.5)

            GroupBox(content: {
                Text(self.viewModel.unitName())
                    .frame(width: 120, alignment: .leading)
            })
            .groupBoxStyle(UnitGroupBoxStyle())
            .offset(x: 25, y: -76)

            GroupBox(content: {
                Text(self.viewModel.unitMoves())
                    .frame(width: 120, alignment: .leading)
            })
            .groupBoxStyle(UnitGroupBoxStyle())
            .offset(x: 25, y: -54)

            GroupBox(content: {
                Text(self.viewModel.unitHealth())
                    .frame(width: 120, alignment: .leading)
            })
            .groupBoxStyle(UnitGroupBoxStyle())
            .offset(x: 25, y: -32)

            if !self.viewModel.unitCharges().isEmpty {
                GroupBox(content: {
                    Text(self.viewModel.unitCharges())
                    .frame(width: 120, alignment: .leading)
                })
                .groupBoxStyle(UnitGroupBoxStyle())
                .offset(x: 25, y: -10)
            }

            self.promotionsView
                .frame(width: 120, height: 20, alignment: .leading)
                .offset(x: 20, y: -4)
        }
    }

    private var promotionsView: some View {

        LazyHStack(spacing: 4) {

            ForEach(self.viewModel.promotionViewModels, id: \.self) { promotionViewModel in

                Image(nsImage: promotionViewModel.icon())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .tooltip(promotionViewModel.toolTip(), side: .top)
            }
        }
    }
}

#if DEBUG
struct UnitBannerView_Previews: PreviewProvider {

    static func viewModel(gameModel: GameModel?) -> UnitBannerViewModel {

        let pt = HexPoint(x: 1, y: 2)
        let commands = [
            Command(type: .rename, location: pt),
            Command(type: .found, location: pt),
            Command(type: .buildFarm, location: pt),
            Command(type: .buildMine, location: pt),
            Command(type: .buildCamp, location: pt),
            Command(type: .attack, location: pt)
        ]

        let player = Player(leader: .alexander, isHuman: false)
        let unit = Unit(at: pt, type: UnitType.warrior, owner: player)
        unit.doPromote(with: .tortoise, in: gameModel)
        let viewModel = UnitBannerViewModel(selectedUnit: unit, commands: commands, in: gameModel)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let gameModel = DemoGameModel()
        let environment = GameEnvironment(game: gameModel)

        let viewModel = UnitBannerView_Previews.viewModel(gameModel: gameModel)
        UnitBannerView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
