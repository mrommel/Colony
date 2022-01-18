//
//  EraEnteredPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct EraEnteredPopupView: View {

    @ObservedObject
    var viewModel: EraEnteredPopupViewModel

    public init(viewModel: EraEnteredPopupViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(
            title: self.viewModel.title,
            mode: .portrait,
            buttonText: "Cancel",
            viewModel: self.viewModel) {

                ScrollView(.vertical, showsIndicators: true, content: {

                    VStack {
                        Text(self.viewModel.summaryText)
                            .font(.title)

                        self.turnsView

                        self.civilizationsView

                        self.earnView

                        self.effectsView

                        Spacer()
                    }
                    .padding()
                })
            }
    }

    var turnsView: some View {

        VStack {
            Divider()

            HStack(alignment: .top) {

                LeaderView(viewModel: self.viewModel.leaderViewModel)

                VStack {

                    HStack {

                        Text("Current Score:")

                        Spacer()

                        Text(self.viewModel.currentScoreText)
                    }

                    HStack {

                        Text("Current Age:")

                        Spacer()

                        Text(self.viewModel.currentAgeText)
                    }
                }
            }
        }
    }

    var civilizationsView: some View {

        VStack {
            Divider()

            Text("Current age by Civilization")
                .font(.caption)

            Divider()

            CivilizationView(viewModel: CivilizationViewModel(civilization: .aztecs))
        }
    }

    var earnView: some View {

        VStack {
            Divider()

            Text("To earn a new age next era")
                .font(.caption)

            Divider()

            HStack {

                Image(nsImage: self.viewModel.darkAgeImage)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Dark Age")

                Spacer()

                Text(self.viewModel.darkAgeLimitText)
                Image(nsImage: self.viewModel.darkAgeCheckmarkImage)
                    .resizable()
                    .frame(width: 20, height: 20)
            }

            HStack {

                Image(nsImage: self.viewModel.normalAgeImage)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Normal Age")

                Spacer()

                Text(self.viewModel.normalAgeLimitText)
                Image(nsImage: self.viewModel.normalAgeCheckmarkImage)
                    .resizable()
                    .frame(width: 20, height: 20)
            }

            HStack {

                Image(nsImage: self.viewModel.goldenAgeImage)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Golden Age")

                Spacer()

                Text(self.viewModel.goldenAgeLimitText)
                Image(nsImage: self.viewModel.goldenAgeCheckmarkImage)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }

    var effectsView: some View {

        VStack {
            Divider()

            Text("effects active this age")
                .font(.caption)

            Divider()

            Label(self.viewModel.currentAgeEffectText)
                .frame(width: 330, alignment: .leading)

            Label(self.viewModel.loyaltyEffectText)
                .frame(width: 330, alignment: .leading)
        }
    }
}

#if DEBUG
struct EraEnteredPopupView_Previews: PreviewProvider {

    static func viewModel() -> EraEnteredPopupViewModel {

        let viewModel = EraEnteredPopupViewModel()

        let demoGameModel = DemoGameModel()
        viewModel.gameEnvironment.game.value = demoGameModel
        viewModel.update(for: .classical)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = EraEnteredPopupView_Previews.viewModel()
        EraEnteredPopupView(viewModel: viewModel)
    }
}
#endif
