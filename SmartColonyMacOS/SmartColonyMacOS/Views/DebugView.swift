//
//  DebugView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 28.09.21.
//

import SwiftUI
import SmartMacOSUILibrary

struct DebugView: View {

    @ObservedObject
    var viewModel: DebugViewModel

    var body: some View {

        VStack {

            Spacer(minLength: 1)

            Text("Debug")
                .font(.largeTitle)

            Divider()

            GroupBox {

                VStack(alignment: .center, spacing: 10) {
                    Group {
                        Button(action: {
                            self.viewModel.createAttackBarbariansWorld()
                        }, label: {
                            Text("Attack Barbarians")
                        }).buttonStyle(GameButtonStyle())

                        Button(action: {
                            self.viewModel.createFastTradeRouteWorld()
                        }, label: {
                            Text("Fast Trade Route")
                        }).buttonStyle(GameButtonStyle())

                        Button(action: {
                            self.viewModel.createAllUnitsWorld()
                        }, label: {
                            Text("All Units")
                        }).buttonStyle(GameButtonStyle())

                        Button(action: {
                            self.viewModel.createFastReligionFoundingWorld()
                        }, label: {
                            Text("Fast religion founding")
                        }).buttonStyle(GameButtonStyle())

                        Button(action: {
                            self.viewModel.createTileImprovementsWorld()
                        }, label: {
                            Text("Tile Improvements")
                        }).buttonStyle(GameButtonStyle())

                        Button(action: {
                            self.viewModel.createCityCombatWorld()
                        }, label: {
                            Text("City Combat")
                        }).buttonStyle(GameButtonStyle())

                        Button(action: {
                            self.viewModel.createSpriteKitView()
                        }, label: {
                            Text("SpriteKit")
                        }).buttonStyle(GameButtonStyle())

                        Button(action: {
                            self.viewModel.createCityRevoltWorld()
                        }, label: {
                            Text("Revolt")
                        }).buttonStyle(GameButtonStyle())

                        Button(action: {
                            self.viewModel.generateUnitAssets()
                        }, label: {
                            Text("Unit Assets")
                        }).buttonStyle(GameButtonStyle())
                    }

                    Spacer()
                        .frame(height: 30, alignment: .center)

                    Button("Quit") {
                        self.viewModel.close()
                    }
                    .buttonStyle(GameButtonStyle())
                    .padding(.top, 45)
                }
            }

            Spacer(minLength: 1)

        }.padding(.vertical, 25)
    }
}

#if DEBUG
struct DebugView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = DebugViewModel()
        DebugView(viewModel: viewModel)
    }
}
#endif
