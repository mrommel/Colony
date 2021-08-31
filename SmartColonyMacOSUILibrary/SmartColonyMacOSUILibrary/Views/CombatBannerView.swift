//
//  CombatBannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 30.08.21.
//

import SwiftUI
import SmartAILibrary

struct CombatBannerView: View {

    @ObservedObject
    public var viewModel: CombatBannerViewModel

    @State
    var showBanner: Bool = false

    init(viewModel: CombatBannerViewModel) {

        self.viewModel = viewModel
    }

    public var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            Spacer()

            HStack(alignment: .center, spacing: 0) {

                Spacer()

                ZStack(alignment: .bottom) {

                    Image(nsImage: ImageCache.shared.image(for: "combat-view"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 391, height: 112)

                    // attacker
                    Group {

                        Text("Defender")
                            .font(.caption)
                            .frame(width: 110, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: -110.0, y: -96.0)

                        Text(self.viewModel.defenderViewModel.name)
                            .font(.caption)
                            .frame(width: 110, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: -110.0, y: -82.0)

                        Image(nsImage: self.viewModel.defenderViewModel.typeIcon())
                            .resizable()
                            .frame(width: 84, height: 84)
                            .offset(x: -32.0, y: -15.0)

                        Text("\(self.viewModel.defenderViewModel.strength)")
                            .font(.caption)
                            .frame(width: 20, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: -42.5, y: -80.0)

                        ScrollView {
                            LazyVStack(spacing: 2) {

                                ForEach(self.viewModel.defenderViewModel.modifierViewModels, id: \.self) { modifierViewModel in

                                    Text(modifierViewModel.text)
                                        .font(.footnote)
                                        .frame(width: 120, alignment: .leading)
                                }
                            }
                        }
                        .frame(width: 130, height: 90, alignment: .leading)
                        .offset(x: -130.0, y: 10.0)
                    }

                    // defender
                    Group {
                        Text("Attacker")
                            .font(.caption)
                            .frame(width: 110, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: 110.0, y: -96.0)

                        Text(self.viewModel.attackerViewModel.name)
                            .font(.caption)
                            .frame(width: 110, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: 110.0, y: -82.0)

                        Image(nsImage: self.viewModel.attackerViewModel.typeIcon())
                            .resizable()
                            .frame(width: 84, height: 84)
                            .offset(x: 32.0, y: -15.0)

                        Text("\(self.viewModel.attackerViewModel.strength)")
                            .font(.caption)
                            .frame(width: 20, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: 42.5, y: -80.0)

                        ScrollView {
                            LazyVStack(spacing: 2) {

                                ForEach(self.viewModel.defenderViewModel.modifierViewModels, id: \.self) { modifierViewModel in

                                    Text(modifierViewModel.text)
                                        .font(.footnote)
                                        .frame(width: 120, alignment: .leading)
                                }
                            }
                        }
                        .frame(width: 130, height: 90, alignment: .leading)
                        .offset(x: 130.0, y: 10.0)
                    }
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
}

#if DEBUG
struct CombatBannerView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        // attacker
        let playerAttacker = Player(leader: .alexander, isHuman: true)
        let locationAttacker = HexPoint(x: 1, y: 2)
        let unitAttacker = Unit(at: locationAttacker, type: UnitType.spearman, owner: playerAttacker)

        // defender
        let playerDefender = Player(leader: .barbarossa, isHuman: false)
        let locationDefender = HexPoint(x: 1, y: 3)
        let unitDefender = Unit(at: locationDefender, type: UnitType.warrior, owner: playerDefender)

        let viewModel = CombatBannerViewModel(attacker: unitAttacker, defender: unitDefender)

        CombatBannerView(viewModel: viewModel)
    }
}
#endif
