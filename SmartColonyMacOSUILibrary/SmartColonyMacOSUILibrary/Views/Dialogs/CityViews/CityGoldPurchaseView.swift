//
//  CityGoldPurchaseView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.01.22.
//

import SwiftUI
import SmartAssets

struct CityGoldPurchaseView: View {

    @ObservedObject
    var viewModel: CityGoldPurchaseViewModel

    public init(viewModel: CityGoldPurchaseViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(spacing: 10) {

            self.buildableItemsView
        }
        .frame(width: 700, height: 300, alignment: .top)
        .background(Globals.Style.dialogBackground)
    }

    var buildableItemsView: some View {

        ScrollView(.vertical, showsIndicators: true, content: {

            Text("TXT_KEY_UNITS".localized())
                .font(.headline)
                .padding(.top, 10)
                .zIndex(500.1)

            ForEach(Array(self.viewModel.unitViewModels.enumerated()), id: \.element) { index, unitViewModel in

                UnitView(viewModel: unitViewModel, zIndex: 500 - Double(index))
            }

            Divider()

            Text("TXT_KEY_DISTRICTS_AND_BUILDINGS".localized())
                .font(.headline)
                .zIndex(400.1)

            ForEach(Array(self.viewModel.districtSectionViewModels.enumerated()), id: \.element) { dindex, districtSectionViewModel in

                DistrictView(viewModel: districtSectionViewModel.districtViewModel)
                    .zIndex(400.0 - Double(5 * dindex)) // needed for tooltip

                ForEach(Array(districtSectionViewModel.buildingViewModels.enumerated()), id: \.element) { bindex, buildingViewModel in

                    BuildingView(viewModel: buildingViewModel)
                        .zIndex(400.0 - Double(5 * dindex) - 1.0 - Double(bindex)) // needed for tooltip
                }
            }
        })
        .frame(width: 340, height: 300, alignment: .top)
    }
}
