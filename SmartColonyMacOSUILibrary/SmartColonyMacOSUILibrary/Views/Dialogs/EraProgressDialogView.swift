//
//  EraProgressDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.12.21.
//

import SwiftUI
import SmartAILibrary

struct LabeledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            self.line
            Text(label).foregroundColor(color)
            self.line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}

struct EraProgressDialogView: View {

    @ObservedObject
    var viewModel: EraProgressDialogViewModel

    public init(viewModel: EraProgressDialogViewModel) {

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
                        Text("The " + self.viewModel.eraTitle + " Era")
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

            HStack {

                Text("Turns until next era:")

                Spacer()

                Text("35-55")
            }

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

            Label(text: self.viewModel.currentAgeEffectText)
                .frame(width: 330, alignment: .leading)

            Label(text: self.viewModel.loyaltyEffectText)
                .frame(width: 330, alignment: .leading)
        }
    }
}

#if DEBUG
struct EraProgressDialogView_Previews: PreviewProvider {

    static func viewModel(leader: LeaderType) -> EraProgressDialogViewModel {

        let viewModel = EraProgressDialogViewModel()

        let game = DemoGameModel()
        game.humanPlayer()?.add(moment: Moment(type: .metNew(civilization: .english), turn: 28))

        viewModel.gameEnvironment.game.value = game
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = EraProgressDialogView_Previews.viewModel(
            leader: .alexander
        )
        EraProgressDialogView(viewModel: viewModel)
    }
}
#endif
