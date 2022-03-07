//
//  BaseDialog.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.09.21.
//

import SwiftUI
import SmartAssets

protocol BaseDialogViewModel: AnyObject {

    func closeDialog()
}

struct DialogBackground: ViewModifier {

    func body(content: Content) -> some View {
        content
            .background(
                Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                    .resizable(capInsets: EdgeInsets(all: 45))
            )
    }
}

extension View {

    func dialogBackground() -> some View {
        self.modifier(DialogBackground())
    }
}

enum DialogMode {

    case portrait
    case landscape

    var contentWidth: CGFloat {

        switch self {

        case .portrait: return 350
        case .landscape: return 750
        }
    }

    var contentHeight: CGFloat {

        switch self {

        case .portrait: return 330
        case .landscape: return 330
        }
    }

    var dialogWidth: CGFloat {

        switch self {

        case .portrait: return 400
        case .landscape: return 800
        }
    }

    var dialogHeight: CGFloat {

        switch self {

        case .portrait: return 450
        case .landscape: return 450
        }
    }
}

struct BaseDialogView<Content>: View where Content: View {

    let title: String
    let mode: DialogMode
    let buttonText: String
    let viewModel: BaseDialogViewModel
    var content: Content

    public init(title: String, mode: DialogMode, buttonText: String = "Okay", viewModel: BaseDialogViewModel, @ViewBuilder content: () -> Content) {

        self.title = title
        self.mode = mode
        self.buttonText = buttonText
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
                    .frame(width: self.mode.contentWidth, height: self.mode.contentHeight, alignment: .center)
                    .border(Color.gray)

                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text(self.buttonText.localized())
                })
                .buttonStyle(DialogButtonStyle())
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: self.mode.dialogWidth, height: self.mode.dialogHeight, alignment: .top)
        .dialogBackground()
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

        BaseDialogView(title: "Title", mode: .portrait, viewModel: viewModel) {
            Text("portrait Content")
        }

        BaseDialogView(title: "Title", mode: .landscape, viewModel: viewModel) {
            Text("landscape Content")
        }
    }
}
#endif
