//
//  ComfirmUnitDisbandDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.06.21.
//

import SwiftUI
import SmartAILibrary

struct UnitDisbandConfirmationDialogView: View {

    @ObservedObject
    var viewModel: UnitDisbandConfirmationDialogViewModel

    public init(viewModel: UnitDisbandConfirmationDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 10) {
                Text("Disband Unit?")
                    .font(.title2)
                    .bold()
                    .padding()

                Text(self.viewModel.question) +
                    Text(self.viewModel.unitName) +
                    Text(" ?")

                HStack(alignment: .center, spacing: 0) {

                    Button(action: {
                        self.viewModel.closeDialog()
                    }, label: {
                        Text("Cancel")
                    })

                    Spacer()

                    Button(action: {
                        self.viewModel.closeDialogAndDisband()
                    }, label: {
                        Text("Disband")
                    })
                }
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 300, height: 170, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct UnitDisbandConfirmationDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        //let game = DemoGameModel()
        //let environment = GameEnvironment(game: game)
        let unit = Unit(at: HexPoint.zero, type: .archer, owner: nil)
        let viewModel = UnitDisbandConfirmationDialogViewModel(unit: unit)

        UnitDisbandConfirmationDialogView(viewModel: viewModel)
            //.environment(\.gameEnvironment, environment)
    }
}
#endif
