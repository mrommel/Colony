//
//  NotificationDetailView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.11.21.
//

import SwiftUI
import SmartAssets

struct NotificationDetailView: View {

    @ObservedObject
    public var viewModel: NotificationDetailViewModel

    public init(viewModel: NotificationDetailViewModel) {

        self.viewModel = viewModel
    }

    public var body: some View {

        VStack(spacing: 0) {

            self.titleView

            self.contentView
                .padding(.top, 4)
                .onTapGesture {
                    self.viewModel.clicked()
                }

            PageControlView(
                current: self.$viewModel.selected,
                pages: self.viewModel.pages)
                .frame(height: 20)
                .frame(maxWidth: 240)
                .onTapGesture {
                    self.viewModel.selectNextClicked()
                }
        }
        .frame(height: 65)
        .background(Color(Globals.Colors.notificationDetailBodyColor))
            .cornerRadius(15)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private var titleView: some View {

        Text(self.viewModel.titleText)
            .padding(.all, 4)
            .frame(width: 240)
            .background(Color(Globals.Colors.notificationDetailTitleColor))
    }

    private var contentView: some View {

        Text(self.viewModel.selectedText)
            .font(.footnote)
    }
}

#if DEBUG
struct NotificationDetailView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = NotificationDetailViewModel(
            title: "2 Negotiated Peace",
            texts: ["Abc", "Def"]
        )

        NotificationDetailView(viewModel: viewModel)
    }
}
#endif
