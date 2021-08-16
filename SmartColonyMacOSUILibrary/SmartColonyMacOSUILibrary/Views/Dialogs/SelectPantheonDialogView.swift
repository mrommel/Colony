//
//  SelectPantheonDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.07.21.
//

import SwiftUI

struct SelectPantheonDialogView: View {

    @ObservedObject
    var viewModel: SelectPantheonDialogViewModel

    private var gridItemLayout = [GridItem(.fixed(250)), GridItem(.fixed(250))]

    public init(viewModel: SelectPantheonDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 10) {
                Text("Select Pantheon")
                    .font(.title2)
                    .bold()
                    .padding()

                ScrollView(.vertical, showsIndicators: true, content: {

                    LazyVGrid(columns: gridItemLayout, spacing: 8) {

                        ForEach(self.viewModel.pantheonViewModels) { pantheonViewModel in

                            PantheonView(viewModel: pantheonViewModel)
                                .padding(0)
                                .onTapGesture {
                                    pantheonViewModel.selectPantheon()
                                }
                        }
                    }
                })
                .border(Color.gray)

                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Okay")
                })
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 700, height: 550, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct SelectPantheonDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let viewModel = SelectPantheonDialogViewModel(game: game)

        SelectPantheonDialogView(viewModel: viewModel)
    }
}
#endif
