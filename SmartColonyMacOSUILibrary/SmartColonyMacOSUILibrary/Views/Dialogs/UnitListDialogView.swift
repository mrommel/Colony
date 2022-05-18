//
//  UnitListDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.08.21.
//

import SwiftUI

struct UnitListDialogView: View {

    @ObservedObject
    var viewModel: UnitListDialogViewModel

    private var gridItemLayout = [GridItem(.fixed(250))]

    public init(viewModel: UnitListDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            VStack(spacing: 10) {
                HStack {

                    Spacer()

                    Text("TXT_KEY_UNITS".localized())
                        .font(.title2)
                        .bold()
                        .padding()

                    Spacer()
                }

                ScrollView(.vertical, showsIndicators: true, content: {

                    LazyVGrid(columns: gridItemLayout, spacing: 10) {

                        ForEach(Array(self.viewModel.unitViewModels.enumerated()), id: \.element) { index, unitViewModel in

                            UnitView(viewModel: unitViewModel, zIndex: 500 - Double(index))
                                .padding(0)
                                .onTapGesture {
                                    unitViewModel.clicked()
                                }
                        }

                        Spacer(minLength: 100)
                    }
                })
                .frame(width: 340, height: 325, alignment: .center)
                .border(Color.gray)

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
        .frame(width: 400, height: 450, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct UnitListDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = UnitListDialogViewModel()

        UnitListDialogView(viewModel: viewModel)
    }
}
#endif
