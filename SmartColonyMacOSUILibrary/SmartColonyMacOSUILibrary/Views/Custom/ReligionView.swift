//
//  ReligionView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.10.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct ReligionView: View {

    @ObservedObject
    var viewModel: ReligionViewModel

    var body: some View {

        HStack(alignment: .center, spacing: 4) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 32, height: 32, alignment: .topLeading)

            VStack(alignment: .leading, spacing: 0) {

                Text(self.viewModel.title)
                    .font(.headline)
            }
        }
        .padding(.all, 4)
        .frame(width: 250, height: 50, alignment: .leading)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-button-clicked"))
                .resizable(capInsets: EdgeInsets(all: 15))
                //.hueRotation(Angle(degrees: 135))
        )
    }
}

#if DEBUG
struct ReligionView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        ReligionView(viewModel: ReligionViewModel(religion: .buddhism))

        ReligionView(viewModel: ReligionViewModel(religion: .easternOrthodoxy))
    }
}
#endif
