//
//  NotificationsView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary

struct NotificationsView: View {

    @ObservedObject
    public var viewModel: NotificationsViewModel

    public init(viewModel: NotificationsViewModel) {

        self.viewModel = viewModel
    }

    @ViewBuilder
    public var body: some View {

        HStack(alignment: .top, spacing: 10) {

            VStack(alignment: .trailing, spacing: 0 ) {

                Spacer()

                Image(nsImage: ImageCache.shared.image(for: "notification-top"))
                    .frame(width: 61, height: 31, alignment: .center)

                ForEach(self.viewModel.notificationViewModels) { notificationViewModel in

                    NotificationView(viewModel: notificationViewModel)
                }

                Image(nsImage: ImageCache.shared.image(for: "notification-bottom"))
                    .resizable()
                    .frame(width: 61, height: 120, alignment: .center)
            }

            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct NotificationsView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let item0: NotificationItem = NotificationItem(type: .cityGrowth, for: LeaderType.alexander, message: "", summary: "", at: HexPoint(x: 3, y: 3), other: LeaderType.trajan)
        let viewModel = NotificationsViewModel(items: [item0])

        NotificationsView(viewModel: viewModel)
    }
}
#endif
