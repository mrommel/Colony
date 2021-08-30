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

    public var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            Spacer()

            HStack(alignment: .center, spacing: 0) {

                Spacer()

                ZStack(alignment: .bottom) {

                    Image(nsImage: ImageCache.shared.image(for: "combat-view"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)

                    // attacker
                    Group {
                        Text(self.viewModel.attackerViewModel.name)
                            .font(.caption)
                            .frame(width: 84, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: -70.0, y: -58.0)

                        Image(nsImage: self.viewModel.attackerViewModel.typeIcon())
                            .resizable()
                            .frame(width: 54, height: 54)
                            .offset(x: -20.0, y: -10.0)

                        Text("\(self.viewModel.attackerViewModel.strength)")
                            .font(.caption)
                            .frame(width: 12, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: -27.0, y: -48.0)
                    }

                    // defender
                    Group {
                        Text(self.viewModel.defenderViewModel.name)
                            .font(.caption)
                            .frame(width: 84, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: 70.0, y: -58.0)

                        Image(nsImage: self.viewModel.defenderViewModel.typeIcon())
                            .resizable()
                            .frame(width: 54, height: 54)
                            .offset(x: 20.0, y: -10.0)

                        Text("\(self.viewModel.defenderViewModel.strength)")
                            .font(.caption)
                            .frame(width: 12, height: 12, alignment: .center)
                            //.background(Color.red)
                            .offset(x: 27.0, y: -48.0)
                    }
                }
                .frame(height: 112, alignment: .bottomTrailing)
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

        let locationSource = HexPoint(x: 1, y: 2)
        let locationTarget = HexPoint(x: 1, y: 3)

        let playerSource = Player(leader: .alexander, isHuman: true)
        let playerTarget = Player(leader: .barbarossa, isHuman: false)
        let unitSource = Unit(at: locationSource, type: UnitType.warrior, owner: playerSource)
        let unitTarget = Unit(at: locationTarget, type: UnitType.warrior, owner: playerTarget)
        let viewModel = CombatBannerViewModel(source: unitSource, target: unitTarget)

        CombatBannerView(viewModel: viewModel)

        /*let _ = GameViewModel(preloadAssets: true)
        Image(nsImage: ImageCache.shared.image(for: "combat-view"))
            .resizable()
            .scaledToFit()
            .frame(width: 250)*/
    }
}
#endif
