//
//  VictoryDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.11.21.
//

import SwiftUI
import SmartAssets

struct VictoryDialogView: View {

    @ObservedObject
    var viewModel: VictoryDialogViewModel

    public init(viewModel: VictoryDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: "Victory", mode: .landscape, viewModel: self.viewModel) {

            VStack(alignment: .leading) {

                Image(nsImage: self.viewModel.bannerImage())
                    .resizable()
                    .frame(height: 42)

                /*HStack {
                    Image(nsImage: self.viewModel.image())
                        .resizable()
                        .frame(width: 42, height: 42)

                    Text(self.viewModel.title)
                        .font(.title)
                }*/
            }
            .frame(width: 750, height: 300)
            .background(
                Globals.Style.dialogBackground
            )
        }
    }
}

#if DEBUG
struct VictoryDialogView_Previews: PreviewProvider {

    static func viewModel() -> VictoryDialogViewModel {

        let viewModel = VictoryDialogViewModel()

        let game = DemoGameModel()
        game.set(winner: .alexander, for: .domination)

        viewModel.gameEnvironment.game.value = game
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = VictoryDialogView_Previews.viewModel()
        VictoryDialogView(viewModel: viewModel)
    }
}
#endif
