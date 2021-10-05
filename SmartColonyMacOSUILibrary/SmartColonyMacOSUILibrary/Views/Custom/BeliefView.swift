//
//  BeliefView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.10.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct BeliefView: View {

    @ObservedObject
    var viewModel: BeliefViewModel

    var body: some View {

        HStack(alignment: .top, spacing: 4) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 32, height: 32, alignment: .topLeading)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 2.0) {

                Text(self.viewModel.title)
                    .font(.headline)

                Text(self.viewModel.effect)
                    .font(.system(size: 8.0))
            }
            .padding(.vertical, 4)
        }
        .padding(.all, 4)
        .frame(width: 250, alignment: .leading)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-button-clicked"))
                .resizable(capInsets: EdgeInsets(all: 15))
                //.hueRotation(Angle(degrees: 135))
        )
    }
}

#if DEBUG
struct BeliefView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        BeliefView(viewModel: BeliefViewModel(belief: .choralMusic))

        BeliefView(viewModel: BeliefViewModel(belief: .crusade))
    }
}
#endif
