//
//  EurekaCivicActivatedPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct InspirationTriggeredPopupView: View {

    @ObservedObject
    var viewModel: InspirationTriggeredPopupViewModel

    public init(viewModel: InspirationTriggeredPopupViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 0) {

                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                VStack(alignment: .center, spacing: 10) {

                    Label(self.viewModel.summaryText, width: 320)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)

                    GroupBox {
                        HStack(alignment: .center) {

                            Image(nsImage: self.viewModel.icon())
                                .resizable()
                                .frame(width: 64, height: 64)

                            VStack {
                                Text(self.viewModel.descriptionText)
                                    .font(.caption)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 4)
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)

                                HStack(spacing: 4) {

                                    Image(nsImage: Globals.Icons.inspiration)
                                        .resizable()
                                        .frame(width: 12, height: 12)

                                    Text(self.viewModel.boostedText)
                                        .font(.caption)
                                }
                                .padding(.bottom, 4)
                            }
                        }
                    }

                    Button(action: {
                        self.viewModel.closePopup()
                    }, label: {
                        Text(self.viewModel.buttonText)
                    })
                        .padding(.bottom, 8)
                        .padding(.top, 20)
                }
                .frame(width: 374, height: 188, alignment: .center)
                // .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 29.5)
            .padding(.leading, 13)
            .padding(.trailing, 13)
        }
        .frame(width: 400, height: 260, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct EurekaCivicActivatedPopupView_Previews: PreviewProvider {

    static func viewModel() -> InspirationTriggeredPopupViewModel {

        let viewModel = InspirationTriggeredPopupViewModel()
        viewModel.update(for: .militaryTradition)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = EurekaCivicActivatedPopupView_Previews.viewModel()

        InspirationTriggeredPopupView(viewModel: viewModel)
    }
}
#endif
