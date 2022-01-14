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
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                VStack(alignment: .center, spacing: 10) {

                    Text(self.viewModel.summaryText)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)

                    GroupBox {
                        HStack(alignment: .center) {

                            Image(nsImage: self.viewModel.icon())

                            VStack {
                                Text(self.viewModel.descriptionText)
                                    .font(.caption)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.bottom, 10)
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)

                                HStack(spacing: 4) {

                                    Image(nsImage: Globals.Icons.eureka)
                                        .resizable()
                                        .frame(width: 12, height: 12)

                                    Text("TXT_KEY_BOOSTED".localized())
                                        .font(.caption)
                                }
                            }
                        }
                    }

                    Button(action: {
                        self.viewModel.closePopup()
                    }, label: {
                        Text("TXT_KEY_CONTINUE".localized())
                    })
                    .padding(.bottom, 8)
                }
                .frame(width: 362, height: 174, alignment: .center)
                .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 43)
            .padding(.leading, 19)
            .padding(.trailing, 19)

        }
        .frame(width: 400, height: 260, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct EurekaCivicActivatedPopupView_Previews: PreviewProvider {

    static func viewModel() -> InspirationTriggeredPopupViewModel {

        let viewModel = InspirationTriggeredPopupViewModel()
        viewModel.update(for: .codeOfLaws)

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
