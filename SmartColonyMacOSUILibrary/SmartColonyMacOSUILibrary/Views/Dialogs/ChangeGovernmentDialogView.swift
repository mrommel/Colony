//
//  ChangeGovernmentDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.05.21.
//

import SwiftUI
import SmartAILibrary

struct ChangeGovernmentDialogView: View {

    @ObservedObject
    var viewModel: ChangeGovernmentDialogViewModel

    private var gridItemLayout = [GridItem(.fixed(300)), GridItem(.fixed(300))]

    public init(viewModel: ChangeGovernmentDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            VStack(spacing: 10) {
                Text("TXT_KEY_SELECT_GOVERNMENT".localized())
                    .font(.title2)
                    .bold()
                    .padding()

                ScrollView(.vertical, showsIndicators: true, content: {

                    LazyVGrid(columns: gridItemLayout, spacing: 20) {

                        ForEach(self.viewModel.governmentSectionViewModels, id: \.self) { sectionViewModel in

                            Section(header: Text(sectionViewModel.title()).font(.title)) {

                                ForEach(sectionViewModel.governmentCardViewModels) { governmentCardViewModel in

                                    GovernmentCardView(viewModel: governmentCardViewModel)
                                        .onTapGesture {
                                            self.viewModel.select(government: governmentCardViewModel.governmentType)
                                        }
                                }
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
        .frame(width: 700, height: 450, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct GovernmentDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let environment = GameEnvironment(game: DemoGameModel())

        GovernmentDialogView(viewModel: GovernmentDialogViewModel())
            .environment(\.gameEnvironment, environment)
    }
}
#endif
