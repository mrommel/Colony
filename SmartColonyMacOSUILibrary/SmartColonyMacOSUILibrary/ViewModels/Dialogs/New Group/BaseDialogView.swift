//
//  BaseDialog.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.09.21.
//

import SwiftUI

protocol BaseDialogViewModel: AnyObject {

    func closeDialog()
}

struct BaseDialogView<Content>: View where Content: View {

    let title: String
    let viewModel: BaseDialogViewModel
    var content: Content

    public init(title: String, viewModel: BaseDialogViewModel, @ViewBuilder content: () -> Content) {

        self.title = title
        self.viewModel = viewModel
        self.content = content()
    }

    var body: some View {

        Group {
            VStack(spacing: 10) {
                HStack {

                    Spacer()

                    Text(self.title)
                        .font(.title2)
                        .bold()
                        .padding(.top, 14)

                    Spacer()
                }

                self.content
                    .frame(width: 340, height: 330, alignment: .center)
                    .border(Color.gray)

                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Okay")
                })
                .buttonStyle(DialogButtonStyle())
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 400, height: 450, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
class BaseDialogViewModelImpl: BaseDialogViewModel {

    func closeDialog() {

    }
}

struct BaseDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = BaseDialogViewModelImpl()

        BaseDialogView(title: "Title", viewModel: viewModel) {
            Text("Content")
        }
    }
}
#endif
