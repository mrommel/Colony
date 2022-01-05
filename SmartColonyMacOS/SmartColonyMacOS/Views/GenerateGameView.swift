//
//  GenerateGameView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 23.03.21.
//

import SwiftUI
import SmartAssets
import SmartMacOSUILibrary

struct GenerateGameView: View {

    @ObservedObject
    var viewModel: GenerateGameViewModel

    var body: some View {

        VStack {

            Spacer(minLength: 1)

            Text("TXT_KEY_GAME".localized())
                .font(.largeTitle)

            Divider()

            Text(self.$viewModel.progressText.wrappedValue)

            ProgressCircle(value: self.$viewModel.progressValue,
                           maxValue: 1.0,
                           style: .line,
                           backgroundColor: Color(Globals.Colors.progressBackground),
                           foregroundColor: Color(Globals.Colors.progressColor),
                           lineWidth: 10)
                .frame(height: 80)

            Spacer(minLength: 1)
        }
    }
}

struct GenerateGameView_Previews: PreviewProvider {

    static var viewModel = GenerateGameViewModel(initialProgress: 0.3, initialText: "abc")

    static var previews: some View {

        GenerateGameView(viewModel: viewModel)
    }
}
