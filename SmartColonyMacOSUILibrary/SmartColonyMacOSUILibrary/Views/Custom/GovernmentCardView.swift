//
//  GovernmentCardView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.05.21.
//

import SwiftUI

struct GovernmentCardView: View {

    @ObservedObject
    var viewModel: GovernmentCardViewModel

    var body: some View {
        ZStack(alignment: .top) {
            Image(nsImage: self.viewModel.ambient())
                .resizable()
                .frame(width: 300, height: 100, alignment: .topLeading)
                .padding(.top, 30)

            Image(nsImage: self.viewModel.background())
                .resizable()
                .frame(width: 300, height: 200, alignment: .topLeading)

            VStack(alignment: .center) {

                Text(self.viewModel.title())
                    .font(.headline)
                    .padding(.top, 13)
                    .padding(.leading, 33)
                    .padding(.trailing, 33)

                HStack {

                    ForEach(self.viewModel.cardImages(), id: \.self) { cardImage in
                        Image(nsImage: cardImage)
                            .resizable()
                            .frame(width: 36, height: 36, alignment: .topLeading)
                            .padding(.leading, -15)
                    }
                }
                .padding(.top, 20)
                .padding(.leading, 15)
                .frame(width: 300, height: 70, alignment: .top)

                Label(self.viewModel.bonus1Summary())
                    .font(.footnote)
                    .padding(.top, 5)
                    .padding(.leading, 33)
                    .padding(.trailing, 33)

                Label(self.viewModel.bonus2Summary())
                    .font(.footnote)
                    .padding(.top, 15)
                    .padding(.leading, 33)
                    .padding(.trailing, 33)
            }
            .frame(width: 300, height: 200, alignment: .top)
        }
        .frame(width: 300, height: 200, alignment: .topLeading)
    }
}

#if DEBUG
struct GovernmentCardView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = GovernmentCardViewModel(governmentType: .communism, state: .active)

        GovernmentCardView(viewModel: viewModel)
    }
}
#endif
