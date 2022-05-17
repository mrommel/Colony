//
//  NotificationView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct NotificationView: View {

    @ObservedObject
    public var viewModel: NotificationViewModel

    public init(viewModel: NotificationViewModel) {

        self.viewModel = viewModel
    }

    public var body: some View {

        ZStack(alignment: .topLeading) {

            Image(nsImage: self.viewModel.background())
                .resizable()
                .frame(width: 61, height: 65, alignment: .center)

            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 40, height: 40, alignment: .center)
                .padding(.top, 13.5)
                .padding(.leading, 14)

            Circle()
                .fill(Color.white.opacity(0.01))
                .frame(width: 40, height: 40)
                .padding(.top, 13.5)
                .padding(.leading, 14)
                .onTapGesture {
                    self.viewModel.click()
                }

            if self.viewModel.amount > 1 {
                Text("\(self.viewModel.amount)")
                    .frame(width: 8, height: 8, alignment: .center)
                    .padding(4)
                    .background(
                        Circle()
                            .strokeBorder(Color.orange, lineWidth: 1)
                            .background(Circle().fill(Color(Globals.Colors.dialogCenter)))
                            .padding(1)
                    )
                    .offset(x: 8, y: 44)
            }

            if self.viewModel.expanded {
                NotificationDetailView(viewModel: self.viewModel.detailViewModel)
                    .offset(x: 70, y: 0)
            }
        }
        .frame(height: 65, alignment: .leading)
        .tooltip(self.viewModel.toolTip, side: .trailing)
    }
}

#if DEBUG
struct NotificationView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let growthViewModel = NotificationViewModel(
            items: [
                NotificationItem(
                    type: .cityGrowth(
                        cityName: "Berlin",
                        population: 3,
                        location: HexPoint(x: 3, y: 3)
                    )
                )
            ]
        )

        NotificationView(viewModel: growthViewModel)

        let barbarianCampViewModel = NotificationViewModel(
            items: [
                NotificationItem(
                    type: .barbarianCampDiscovered(
                        location: HexPoint(x: 3, y: 3)
                    )
                ),
                NotificationItem(
                    type: .barbarianCampDiscovered(
                        location: HexPoint(x: 6, y: 7)
                    )
                )
            ]
        )

        NotificationView(viewModel: barbarianCampViewModel)
    }
}
#endif
