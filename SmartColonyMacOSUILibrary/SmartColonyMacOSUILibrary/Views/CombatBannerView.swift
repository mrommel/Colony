//
//  CombatBannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 30.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CombatBannerView: View {

    @StateObject
    var viewModel: CombatBannerViewModel

    @State
    var showBanner: Bool = false

    /*init(viewModel: CombatBannerViewModel) {

        self.viewModel = viewModel
    }*/

    public var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            Spacer()

            HStack(alignment: .center, spacing: 0) {

                Spacer()

                ZStack(alignment: .bottom) {

                    Rectangle()
                        .fill(Color(self.viewModel.combatPredictionColor))
                        .frame(width: 100, height: 50)
                        .offset(x: 0.0, y: -62.0)

                    Image(nsImage: ImageCache.shared.image(for: "combat-view"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 391, height: 112)

                    self.defenderView

                    self.attackerView

                    Text(self.viewModel.combatPredictionText)
                        .font(.caption)
                        .frame(width: 80, height: 24, alignment: .top)
                        // .background(Color.red)
                        .offset(x: 0.0, y: -88.0)
                }
                .frame(width: 391, height: 112, alignment: .bottomTrailing)
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

    private var defenderView: some View {
        // defender
        Group {

            Text("Defender")
                .font(.caption)
                .frame(width: 110, height: 12, alignment: .center)
                // .background(Color.red)
                .offset(x: -110.0, y: -96.0)

            Text(self.viewModel.defenderViewModel.name)
                .font(.caption)
                .frame(width: 110, height: 12, alignment: .center)
                // .background(Color.red)
                .offset(x: -110.0, y: -82.0)

            Image(nsImage: self.viewModel.defenderViewModel.typeIcon())
                .resizable()
                .frame(width: 42, height: 42)
                // .background(Color.red)
                .clipShape(Circle())
                .offset(x: -32.0, y: -28.0)

            Image(nsImage: self.viewModel.defenderViewModel.healthIcon())
                .resizable()
                .frame(width: 64, height: 64)
                .padding(EdgeInsets(top: 0, leading: -32, bottom: 0, trailing: 0))
                .clipShape(Rectangle())
                .offset(x: -15.0, y: -15.0)

            Text("\(self.viewModel.defenderViewModel.strength)")
                .font(.caption)
                .frame(width: 20, height: 12, alignment: .center)
                // .background(Color.red)
                .offset(x: -42.5, y: -80.0)

            ScrollView {
                LazyVStack(spacing: 2) {

                    ForEach(self.viewModel.defenderViewModel.modifierViewModels,
                            id: \.self) { modifierViewModel in

                        HStack(spacing: 2) {
                            Text("\(modifierViewModel.value)")
                                .font(.system(size: 9))
                                .frame(width: 18, alignment: .center)

                            Text(modifierViewModel.text)
                                .font(.system(size: 9))
                                .frame(width: 100, alignment: .leading)
                        }
                    }
                }
            }
            .frame(width: 120, height: 60, alignment: .leading)
            // .background(Color.red)
            .offset(x: -130.0, y: -20.0)

            ScrollView {
                LazyHStack(spacing: 2) {

                    ForEach(self.viewModel.defenderViewModel.promotionViewModels,
                            id: \.self) { promotionViewModel in

                        Image(nsImage: promotionViewModel.icon())
                            .resizable()
                            .frame(width: 12, height: 12)
                            .tooltip(promotionViewModel.toolTip(), side: .top)
                    }
                }
            }
            .frame(width: 120, height: 12, alignment: .leading)
            // .background(Color.red)
            .offset(x: -130.0, y: -6.0)
        }
    }

    private var attackerView: some View {
        // attacker
        Group {
            Text("Attacker")
                .font(.caption)
                .frame(width: 110, height: 12, alignment: .center)
                // .background(Color.red)
                .offset(x: 110.0, y: -96.0)

            Text(self.viewModel.attackerViewModel.name)
                .font(.caption)
                .frame(width: 110, height: 12, alignment: .center)
                // .background(Color.red)
                .offset(x: 110.0, y: -82.0)

            Image(nsImage: self.viewModel.attackerViewModel.typeIcon())
                .resizable()
                .frame(width: 42, height: 42)
                // .background(Color.red)
                .clipShape(Circle())
                .offset(x: 32.0, y: -28.0)

            Image(nsImage: self.viewModel.attackerViewModel.healthIcon())
                .resizable()
                .frame(width: 64, height: 64)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -32))
                .clipShape(Rectangle())
                .offset(x: 15.0, y: -15.0)

            Text("\(self.viewModel.attackerViewModel.strength)")
                .font(.caption)
                .frame(width: 20, height: 12, alignment: .center)
                // .background(Color.red)
                .offset(x: 42.5, y: -80.0)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 2) {

                    ForEach(self.viewModel.attackerViewModel.modifierViewModels,
                            id: \.self) { modifierViewModel in

                        HStack(spacing: 2) {
                            Text("\(modifierViewModel.value)")
                                .font(.system(size: 9))
                                .frame(width: 18, alignment: .center)

                            Text(modifierViewModel.text)
                                .font(.system(size: 9))
                                .frame(width: 100, alignment: .leading)
                        }
                    }
                }
            }
            .frame(width: 120, height: 60, alignment: .leading)
            // .background(Color.red)
            .offset(x: 130.0, y: -20.0)

            ScrollView {
                LazyHStack(spacing: 2) {

                    ForEach(self.viewModel.attackerViewModel.promotionViewModels,
                            id: \.self) { promotionViewModel in

                        Image(nsImage: promotionViewModel.icon())
                            .resizable()
                            .frame(width: 12, height: 12)
                            .tooltip(promotionViewModel.toolTip(), side: .top)
                    }
                }
            }
            .frame(width: 120, height: 12, alignment: .leading)
            // .background(Color.red)
            .offset(x: 130.0, y: -6.0)
        }
    }
}

#if DEBUG
struct CombatBannerView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        // attacker unit
        let playerAttacker = Player(leader: .alexander, isHuman: true)
        let locationAttacker = HexPoint(x: 1, y: 2)
        let unitAttacker = Unit(at: locationAttacker, type: UnitType.spearman, owner: playerAttacker)

        // attacker city
        let cityAttacker = City(name: "Berlin", at: HexPoint(x: 2, y: 3), owner: playerAttacker)

        // defender
        let playerDefender = Player(leader: .barbarossa, isHuman: false)
        let locationDefender = HexPoint(x: 1, y: 3)
        let unitDefender = Unit(at: locationDefender, type: UnitType.warrior, owner: playerDefender)

        // views and viewModels

        let unitToUnitViewModel = CombatBannerViewModel(attacker: unitAttacker, defender: unitDefender)

        CombatBannerView(viewModel: unitToUnitViewModel)
            .previewDisplayName("Unit => Unit Combat")

        let cityToUnitViewModel = CombatBannerViewModel(attacker: cityAttacker, defender: unitDefender)

        CombatBannerView(viewModel: cityToUnitViewModel)
            .previewDisplayName("City => Unit Range Combat")
    }
}
#endif
