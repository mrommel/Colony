//
//  NotificationsView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct NotificationsView: View {

    @ObservedObject
    public var viewModel: NotificationsViewModel

    public init(viewModel: NotificationsViewModel) {

        self.viewModel = viewModel
    }

    @ViewBuilder
    public var body: some View {

        HStack(alignment: .top, spacing: 10) {

            VStack(alignment: .leading, spacing: 0) {

                Spacer()

                Image(nsImage: ImageCache.shared.image(for: "notification-top"))
                    .frame(width: 61, height: 31)

                ForEach(self.viewModel.notificationViewModels) { notificationViewModel in

                    NotificationView(viewModel: notificationViewModel)
                }

                Image(nsImage: ImageCache.shared.image(for: "notification-bottom"))
                    .resizable()
                    .frame(width: 61, height: 120)
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
        let item0: NotificationItem = NotificationItem(
            type: .cityGrowth(
                cityName: "Berlin",
                population: 3,
                location: HexPoint(x: 3, y: 3)
            )
        )
        let item1: NotificationItem = NotificationItem(
            type: .cityGrowth(
                cityName: "Potsdam",
                population: 3,
                location: HexPoint(x: 5, y: 3)
            )
        )

        let item2: NotificationItem = NotificationItem(
            type: .barbarianCampDiscovered(
                location: HexPoint(x: 5, y: 13)
            )
        )

        let viewModel = NotificationsViewModel(
            items: [item0, item1, item2]
        )

        NotificationsView(viewModel: viewModel)
    }
}
#endif
