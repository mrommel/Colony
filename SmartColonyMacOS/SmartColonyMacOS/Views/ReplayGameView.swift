//
//  ReplayGameView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 06.11.21.
//

import SwiftUI
import SmartAssets
import SmartMacOSUILibrary

struct ReplayGameView: View {

    @ObservedObject
    var viewModel: ReplayGameViewModel

    var body: some View {

        VStack {

            Spacer(minLength: 1)

            Text("SmartColony").font(.largeTitle)

            Divider()

            Text("Replay")

            Spacer(minLength: 1)
        }
    }
}

struct ReplayGameView_Previews: PreviewProvider {

    static var viewModel = ReplayGameViewModel()

    static var previews: some View {

        ReplayGameView(viewModel: viewModel)
    }
}
