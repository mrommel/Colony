//
//  CityNameDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI

struct CityNameDialogView: View {

    @ObservedObject
    var viewModel: CityNameDialogViewModel

    public init(viewModel: CityNameDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 10) {
                Text("Enter City Name")
                    .font(.title2)
                    .bold()
                    .padding()

                TextField("city name ...", text: self.$viewModel.cityName)

                HStack(alignment: .center, spacing: 0) {

                    Button(action: {
                        self.viewModel.closeDialog()
                    }, label: {
                        Text("Cancel")
                    })

                    Spacer()

                    Button(action: {
                        self.viewModel.closeAndFoundDialog()
                    }, label: {
                        Text("Okay")
                    })
                }
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 300, height: 170, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct CityNameDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        CityNameDialogView(viewModel: CityNameDialogViewModel())
            .environment(\.gameEnvironment, environment)
    }
}
#endif
