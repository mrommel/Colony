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

/*struct BottomRightBarView_Previews: PreviewProvider {

    static func viewModel() -> GameSceneViewModel {

        let viewModel = GameSceneViewModel()

        let game = DemoGameModel()
        viewModel.game = game

        return viewModel
    }

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = BottomRightBarView_Previews.viewModel()
        BottomRightBarView(viewModel: viewModel)
    }
}*/
