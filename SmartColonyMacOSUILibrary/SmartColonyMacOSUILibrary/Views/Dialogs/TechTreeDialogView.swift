//
//  TechTreeDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI

struct TechTreeDialogView: View {

    @ObservedObject
    var viewModel: TechDialogViewModel

    private var gridItemLayout = [
        GridItem(.fixed(45)), GridItem(.fixed(45)),
        GridItem(.fixed(45)), GridItem(.fixed(45)),
        GridItem(.fixed(45)), GridItem(.fixed(45)),
        GridItem(.fixed(45)), GridItem(.fixed(45))
    ]

    public init(viewModel: TechDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 10) {
                Text("Select Tech")
                    .font(.title2)
                    .bold()
                    .padding()

                ScrollView(.horizontal, showsIndicators: true, content: {

                    LazyHGrid(rows: gridItemLayout, spacing: 20) {

                        ForEach(Array(self.viewModel.techGridViewModels.enumerated()), id: \.element) { index, techViewModel in

                            TechView(viewModel: techViewModel, zIndex: 500 - Double(index))
                                .padding(0)
                                .onTapGesture {
                                    techViewModel.selectTech()
                                }
                        }
                    }
                })

                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("TXT_KEY_OKAY".localized())
                })
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 700, height: 550, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct TechDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        TechTreeDialogView(viewModel: TechDialogViewModel(game: game))
            .environment(\.gameEnvironment, environment)
    }
}
#endif
