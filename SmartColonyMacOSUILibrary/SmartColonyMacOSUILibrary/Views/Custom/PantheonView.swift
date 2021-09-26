//
//  PantheonView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.05.21.
//

import SwiftUI

struct PantheonView: View {

    @ObservedObject
    var viewModel: PantheonViewModel

    var body: some View {

        HStack(alignment: .top, spacing: 4) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 32, height: 32, alignment: .leading)

            VStack(alignment: .leading, spacing: 0) {

                Text(self.viewModel.name())
                    .font(.headline)

                Text(self.viewModel.summary())
                    .font(.footnote)
                    .padding(.top, 1)
            }
        }
        .padding(.all, 4)
        .frame(width: 250, alignment: .leading)
        .background(
            Image(nsImage: self.viewModel.background())
                .resizable()
                .frame(width: 250, alignment: .topLeading)
        )
    }
}

#if DEBUG
struct PantheonView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        PantheonView(viewModel: PantheonViewModel(pantheonType: .godOfWar))

        PantheonView(viewModel: PantheonViewModel(pantheonType: .initiationRites))
    }
}
#endif
