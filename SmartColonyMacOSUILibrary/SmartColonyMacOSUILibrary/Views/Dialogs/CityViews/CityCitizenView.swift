//
//  CityCitizenView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityCitizenView: View {

    @ObservedObject
    var viewModel: CityCitizenViewModel

    public init(viewModel: CityCitizenViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(spacing: 10) {

        ScrollView(.vertical, showsIndicators: true, content: {

            Text("Citizen")
                .font(.headline)
                .padding(.top, 10)

            HexagonGridView(viewModel: self.viewModel.hexagonGridViewModel)
                .frame(width: 300, height: 300, alignment: .top)

            Spacer()
        })
        .frame(width: 340, height: 300, alignment: .top)
    }
    .frame(width: 700, height: 300, alignment: .top)
    .background(Globals.Style.dialogBackground)
    }
}

#if DEBUG
struct CityCitizenView_Previews: PreviewProvider {

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)
        let city = City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())
        let viewModel = CityCitizenViewModel(city: city)

        CityCitizenView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
