//
//  RazeOrReturnCityDialogView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 08.04.22.
//

import SwiftUI
import SmartAssets

struct RazeOrReturnCityDialogView: View {

    @ObservedObject
    var viewModel: RazeOrReturnCityDialogViewModel

    public init(viewModel: RazeOrReturnCityDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(
            title: "TXT_KEY_CITY_RAZE_OR_LIBERATE_TITLE".localized(),
            mode: .portrait,
            buttonText: "", // hide close button
            viewModel: self.viewModel) {

                VStack(alignment: .center) {

                    HStack {

                        Text("TXT_KEY_CITY_NAME_LABEL".localized())
                            .frame(width: 155, alignment: .trailing)

                        Text(self.viewModel.cityName)
                            .frame(width: 155, alignment: .leading)
                    }

                    HStack {

                        Text("TXT_KEY_CITY_POPULATION_LABEL".localized())
                            .frame(width: 155, alignment: .trailing)

                        Text(self.viewModel.cityPopulation)
                            .frame(width: 155, alignment: .leading)
                    }

                    Button("TXT_KEY_CITY_KEEP".localized()) {
                        self.viewModel.keepCityClicked()
                    }.buttonStyle(DialogButtonStyle(state: .highlighted))

                    if self.viewModel.canRazeCity {
                        Button("TXT_KEY_CITY_RAZE".localized()) {
                            self.viewModel.razeCityClicked()
                        }.buttonStyle(DialogButtonStyle(state: .normal))
                    }

                    if self.viewModel.canLiberateCity {
                        Button("TXT_KEY_CITY_LIBERATE".localizedWithFormat(with: [self.viewModel.originalOwnerName])) {
                            self.viewModel.returnCityClicked()
                        }.buttonStyle(DialogButtonStyle(state: .normal))
                    }

                    Spacer()
                }
                .frame(width: 350, height: 330)
                .background(
                    Globals.Style.dialogBackground
                )
            }
    }
}

#if DEBUG
import SmartAILibrary

struct RazeOrReturnCityDialogView_Previews: PreviewProvider {

    static func viewModel() -> RazeOrReturnCityDialogViewModel {

        let game = DemoGameModel()
        let humanPlayer = game.humanPlayer()

        let city = City(name: "Berlin", at: HexPoint(x: 7, y: 7), capital: false, owner: humanPlayer)
        city.initialize(in: game)
        game.add(city: city)

        let viewModel = RazeOrReturnCityDialogViewModel()

        viewModel.gameEnvironment.game.value = game
        viewModel.update(for: city)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = RazeOrReturnCityDialogView_Previews.viewModel()

        RazeOrReturnCityDialogView(viewModel: viewModel)
    }
}
#endif
