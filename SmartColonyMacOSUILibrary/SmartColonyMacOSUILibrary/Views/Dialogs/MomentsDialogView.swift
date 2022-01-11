//
//  MomentsDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.01.22.
//

import SwiftUI
import SmartAssets

struct MomentsDialogView: View {

    @ObservedObject
    var viewModel: MomentsDialogViewModel

    public init(viewModel: MomentsDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(
            title: self.viewModel.title,
            mode: .landscape,
            buttonText: "Cancel",
            viewModel: self.viewModel) {

                VStack(alignment: .center) {

                    ScrollView(.horizontal, showsIndicators: true, content: {

                        LazyHStack(spacing: 4) {

                            ForEach(self.viewModel.momentViewModels, id: \.self) { momentViewModel in

                                MomentView(viewModel: momentViewModel)
                            }
                        }
                        .padding(.top, 8)
                    })
                }
                .frame(width: 750, height: 330)
                .background(
                    Globals.Style.dialogBackground
                )
            }
    }
}

#if DEBUG
import SmartAILibrary

struct MomentsDialogView_Previews: PreviewProvider {

    static func viewModel() -> MomentsDialogViewModel {

        let viewModel = MomentsDialogViewModel()

        let game = DemoGameModel()
        game.humanPlayer()?.addMoment(of: .metNewCivilization(civilization: .english), in: 4)
        game.humanPlayer()?.addMoment(of: .battleFought, in: 6)
        game.humanPlayer()?.addMoment(of: .barbarianCampDestroyed, in: 12)

        viewModel.gameEnvironment.game.value = game
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = MomentsDialogView_Previews.viewModel()
        MomentsDialogView(viewModel: viewModel)
    }
}
#endif
