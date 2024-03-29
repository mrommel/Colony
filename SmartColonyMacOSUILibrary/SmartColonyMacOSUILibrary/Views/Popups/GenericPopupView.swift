//
//  GenericPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 08.02.22.
//

import SwiftUI
import SmartAssets

struct GenericPopupView: View {

    @ObservedObject
    var viewModel: GenericPopupViewModel

    public init(viewModel: GenericPopupViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 0) {

                Label(self.viewModel.title)
                    .font(.title2)
                    .padding(.top, 12)
                    .padding(.bottom, 10)

                VStack(alignment: .center, spacing: 6) {

                    ScrollView([.vertical], showsIndicators: true) {

                        Label(self.viewModel.summary, width: 320)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding(.top, 30)
                            .padding(.bottom, 10)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                    }
                    .frame(width: 360)

                    Spacer()

                    Button(action: {
                        self.viewModel.closePopup()
                    }, label: {
                        Text("TXT_KEY_CLOSE".localized())
                    })
                    .buttonStyle(DialogButtonStyle())
                    .padding(.bottom, 8)
                }
                .frame(width: 362, height: 184, alignment: .center)
                .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 43)
            .padding(.leading, 19)
            .padding(.trailing, 19)
        }
        .frame(width: 400, height: 270, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct GenericPopupView_Previews: PreviewProvider {

    static func viewModel() -> GenericPopupViewModel {

        let viewModel = GenericPopupViewModel()
        viewModel.update(with: "Hello [Production]", and: "Summary [Capital]")

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = GenericPopupView_Previews.viewModel()
        GenericPopupView(viewModel: viewModel)
    }
}
#endif
