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

            Text("Units")
                .font(.headline)
                .padding(.top, 10)

            ForEach(self.viewModel.unitViewModels, id: \.self) { unitViewModel in

                UnitView(viewModel: unitViewModel)
            }

            Divider()

            Text("Districts and Buildings")
                .font(.headline)

            LazyVStack(spacing: 10) {

                ForEach(self.viewModel.districtSectionViewModels, id: \.self) { districtSectionViewModel in

                    DistrictView(viewModel: districtSectionViewModel.districtViewModel)

                    ForEach(districtSectionViewModel.buildingViewModels, id: \.self) { buildingViewModel in

                        BuildingView(viewModel: buildingViewModel)
                    }
                }
            }
        })
        .frame(width: 340, height: 300, alignment: .top)
    }
}
