//
//  TradeCityView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.07.21.
//

import SwiftUI
import SmartAILibrary

struct TradeCityView: View {

    @ObservedObject
    var viewModel: TradeCityViewModel

    var body: some View {

        HStack(alignment: .top, spacing: 4) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 32, height: 32, alignment: .topLeading)

            VStack(alignment: .leading, spacing: 0) {

                Text(self.viewModel.title)
                    .font(.headline)

                Text("Yields")
                    .font(.footnote)
                    .padding(.top, 1)
            }
        }
        .padding(.all, 4)
        .frame(width: 250, height: 50, alignment: .leading)
        .background(
            Image(nsImage: self.viewModel.background())
                .resizable()
                .frame(width: 250, height: 50, alignment: .topLeading)
        )
    }
}

#if DEBUG
struct TradeCityView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let player = Player(leader: .alexander, isHuman: false)
        let city = City(name: "Berlin", at: HexPoint.zero, owner: player)

        TradeCityView(viewModel: TradeCityViewModel(city: city))
    }
}
#endif
