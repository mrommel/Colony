//
//  CityReligionView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityReligionView: View {

    @ObservedObject
    var viewModel: CityReligionViewModel

    public init(viewModel: CityReligionViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        ScrollView(.vertical, showsIndicators: true, content: {

            Text("Religion")
                .font(.headline)
                .padding(.top, 10)

            if let pantheonViewModel = self.viewModel.pantheonViewModel {

                PantheonView(viewModel: pantheonViewModel)
            } else {
                Text("Earn 25 Faith to start a pantheon")
                    .padding()
            }

            if self.viewModel.citizenReligionViewModels.count == 0 {
                Text("No religious people in this city - you need to found a religion.")
                    .padding()
            } else {
                VStack {
                    ForEach(self.viewModel.citizenReligionViewModels, id: \.self) { citizenReligionViewModel in

                        CitizenReligionView(viewModel: citizenReligionViewModel)
                    }
                }
            }
        })
        .frame(width: 700, height: 300, alignment: .top)
        .background(Globals.Style.dialogBackground)
    }
}

#if DEBUG
struct CityReligionView_Previews: PreviewProvider {

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)
        let city = City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())
        let viewModel = CityReligionViewModel(city: city)

        CityReligionView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
