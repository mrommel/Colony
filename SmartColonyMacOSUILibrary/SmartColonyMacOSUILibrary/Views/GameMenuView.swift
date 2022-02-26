//
//  GameMenuView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.02.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

struct GameMenuView: View {

    @ObservedObject
    private var viewModel: GameMenuViewModel

    public init(viewModel: GameMenuViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        ZStack {
            VStack(alignment: .center, spacing: 12) {

                Text("Menu")
                    .font(.title)
                    .padding(.top, 8)
                    .padding(.bottom, 20)

                Group {

                    Button(
                        action: { self.viewModel.clickBackToGame() },
                        label: { Text("Back to Game".localized()) }
                    )
                        .buttonStyle(DialogButtonStyle(width: 180))
                        .padding(.bottom, 20)

                    Button(
                        action: { self.viewModel.clickRestartGame() },
                        label: { Text("Restart".localized()) }
                    )
                        .buttonStyle(DialogButtonStyle(width: 180))

                    Button(
                        action: { print("Quick Save Game") },
                        label: { Text("Quick Save Game".localized()) }
                    )
                        .buttonStyle(DialogButtonStyle(width: 180))

                    Button(
                        action: { print("Save Game") },
                        label: { Text("Save Game".localized()) }
                    )
                        .buttonStyle(DialogButtonStyle(width: 180))

                    Button(
                        action: { print("Load Game") },
                        label: { Text("Load Game".localized()) }
                    )
                        .buttonStyle(DialogButtonStyle(width: 180))

                    Button(
                        action: { print("Option") },
                        label: { Text("Option".localized()) }
                    )
                        .buttonStyle(DialogButtonStyle(width: 180))

                    Button(
                        action: { print("Retire") },
                        label: { Text("Retire".localized()) }
                    )
                        .buttonStyle(DialogButtonStyle(width: 180))

                    Button(
                        action: { print("Exit to Main Menu") },
                        label: { Text("Exit to Main Menu".localized()) }
                    )
                        .buttonStyle(DialogButtonStyle(width: 180))
                }

                Spacer()

                self.gameInfoIconView
                    .padding(.bottom, 12)

                Text("1.0.0")
                    .padding(.bottom, 6)
            }
            .frame(width: 250, height: 520)
            .background(
                Image(nsImage: ImageCache.shared.image(for: "menu-background"))
                    .resizable()
            )

            if self.viewModel.showConfirmationDialog {
                ConfirmationDialogView(viewModel: self.viewModel.confirmationDialogViewModel)
            }
        }
    }

    private var gameInfoIconView: some View {

        HStack(alignment: .center, spacing: 17.5) {

            Image(nsImage: self.viewModel.civilizationImage())
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .toolTip(self.viewModel.civilizationToolTip())

            Image(nsImage: self.viewModel.leaderImage())
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .toolTip(self.viewModel.leaderToolTip())

            Image(nsImage: self.viewModel.handicapImage())
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .toolTip(self.viewModel.handicapToolTip())

            Image(nsImage: self.viewModel.speedImage())
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
        }
    }
}

struct GameMenuView_Previews: PreviewProvider {

    static func viewModel() -> GameMenuViewModel {

        let viewModel = GameMenuViewModel()

        let gameModel = DemoGameModel()
        viewModel.gameEnvironment.game.send(gameModel)

        return viewModel
    }

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = GameMenuView_Previews.viewModel()
        GameMenuView(viewModel: viewModel)
    }
}
