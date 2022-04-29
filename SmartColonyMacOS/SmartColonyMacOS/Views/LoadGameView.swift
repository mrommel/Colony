//
//  LoadGameView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 29.04.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary
import SmartColonyMacOSUILibrary

struct LoadGameView: View {

    @ObservedObject
    var viewModel: LoadGameViewModel

    public init(viewModel: LoadGameViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack {

            Spacer(minLength: 1)

            Text("Load Game")
                .font(.largeTitle)

            Text("Select filename")

            Divider()

            // checkbox: show autosave

            HStack {

                ScrollView(.vertical, showsIndicators: true) {

                    LazyVStack(spacing: 4) {

                        ForEach(self.viewModel.saveGameViewModels, id: \.self) { saveGameViewModel in

                            Button(action: {
                                self.viewModel.select(filename: saveGameViewModel.filename)
                            }, label: {
                                Text(saveGameViewModel.filename)
                            })
                                .buttonStyle(DialogButtonStyle(state: saveGameViewModel.selected ? .highlighted : .normal, width: 280))
                        }
                    }

                    Spacer()
                }
                    .frame(width: 300, height: 300)

                Divider()
                    .frame(height: 300)

                VStack(alignment: .leading, spacing: 4) {

                    if self.viewModel.previewLoading {
                        ActivityIndicator(isAnimating: self.$viewModel.previewLoading, style: .spinning)
                            .frame(width: 100, height: 100)
                    } else {
                        Text(self.viewModel.gamePreviewTurn)
                        Text(self.viewModel.gamePreviewDate)
                        GamePreview(viewModel: self.viewModel.gamePreviewViewModel)
                        Text(self.viewModel.mapSize)
                    }

                    Spacer()
                }
                    .frame(width: 300, height: 300)
            }

            HStack(alignment: .center, spacing: 0) {

                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Cancel")
                })
                    .buttonStyle(DialogButtonStyle())

                Spacer()

                Button(action: {
                    self.viewModel.closeAndSelectDialog()
                }, label: {
                    Text("Load Game")
                })
                    .buttonStyle(DialogButtonStyle(state: .highlighted))
            }
            .frame(width: 300)

            Spacer(minLength: 1)
        }
    }
}

struct LoadGameView_Previews: PreviewProvider {

    static var viewModel = LoadGameViewModel()

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        LoadGameView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
