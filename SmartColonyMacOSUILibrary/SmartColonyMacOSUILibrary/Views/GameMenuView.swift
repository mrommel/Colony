//
//  GameMenuView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.02.22.
//

import SwiftUI
import SmartAssets

protocol GameMenuViewModelDelegate: AnyObject {

    func backToGameClicked()
}

class GameMenuViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    weak var delegate: GameMenuViewModelDelegate?

    init() {

    }

    func clickBackToGame() {

        self.delegate?.backToGameClicked()
    }

    func civilizationImage() -> NSImage {

        guard let gameModel = self.gameEnvironment.game.value else {
            return NSImage()
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            return NSImage()
        }

        return ImageCache.shared.image(for: humanPlayer.leader.civilization().iconTexture())
    }
}

struct GameMenuView: View {

    @ObservedObject
    private var viewModel: GameMenuViewModel

    public init(viewModel: GameMenuViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .center, spacing: 20) {

            Text("Menu")
                .font(.title)
                .padding(.top, 8)

            Group {

                Button(
                    action: { self.viewModel.clickBackToGame() },
                    label: { "Back to Game".localized() }
                )
                .buttonStyle(GameButtonStyle())
                .padding(.top, 20)

                Button("Restart".localized()) {
                    print("Restart")
                }.buttonStyle(GameButtonStyle())

                Button("Quick Save Game".localized()) {
                    print("Quick Save Game")
                }.buttonStyle(GameButtonStyle())

                Button("Save game".localized()) {
                    print("Save game")
                }.buttonStyle(GameButtonStyle())

                Button("Load Game".localized()) {
                    print("Load Game")
                }.buttonStyle(GameButtonStyle())

                Button("Option".localized()) {
                    print("Option")
                }.buttonStyle(GameButtonStyle())

                Button("Retire".localized()) {
                    print("retire")
                }.buttonStyle(GameButtonStyle())

                Button("Exit to Main Menu".localized()) {
                    print("Exit to Main Menu")
                }.buttonStyle(GameButtonStyle())
            }

            Spacer()

            self.gameInfoIconView
        }
        .frame(width: 250, height: 520)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "menu-background"))
                .resizable()
        )
    }

    private var gameInfoIconView: some View {

        HStack {

            Image(nsImage: self.viewModel.civilizationImage())
                .resizable()
                .frame(width: 32, height: 32)

            Image(nsImage: self.viewModel.civilizationImage())
                .resizable()
                .frame(width: 32, height: 32)

            Image(nsImage: self.viewModel.civilizationImage())
                .resizable()
                .frame(width: 32, height: 32)

            Image(nsImage: self.viewModel.civilizationImage())
                .resizable()
                .frame(width: 32, height: 32)
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
