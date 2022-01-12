//
//  BottomRightBarView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 07.04.21.
//

import SwiftUI

public struct BottomRightBarView: View {

    @ObservedObject
    public var viewModel: BottomRightBarViewModel

    public var body: some View {
        HStack {

            Spacer()

            VStack(alignment: .trailing, spacing: 10) {

                Spacer()
                MapOverviewView(viewModel: self.viewModel.mapOverviewViewModel)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct BottomRightBarView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        let viewModel = BottomRightBarViewModel()
        BottomRightBarView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
