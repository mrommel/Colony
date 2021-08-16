//
//  CityChooseProductionDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityProductionView: View {

    @ObservedObject
    var viewModel: CityProductionViewModel

    private var gridItemLayout = [GridItem(.fixed(300))]

    public init(viewModel: CityProductionViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(spacing: 10) {

            ScrollView(.vertical, showsIndicators: true, content: {

                if self.viewModel.queueViewModels.count == 0 {
                    Text("Please add a unit / building / wonder")
                        .font(.headline)
                        .padding(.top, 10)
                }

                ForEach(self.viewModel.queueViewModels, id: \.self) { queueViewModel in

                    switch queueViewModel.queueType {

                    case .unit:
                        UnitView(viewModel: queueViewModel as! UnitViewModel)
                    case .district:
                        DistrictView(viewModel: queueViewModel as! DistrictViewModel)
                    case .building:
                        BuildingView(viewModel: queueViewModel as! BuildingViewModel)
                    case .wonder:
                        WonderView(viewModel: queueViewModel as! WonderViewModel)
                    default:
                        Text("type \(queueViewModel.queueType.rawValue)")
                    }
                }
            })
            .frame(width: 340, height: 300, alignment: .top)

            Divider()

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

                LazyVGrid(columns: gridItemLayout, spacing: 10) {

                    ForEach(self.viewModel.districtSectionViewModels, id: \.self) { districtSectionViewModel in

                        DistrictView(viewModel: districtSectionViewModel.districtViewModel)

                        ForEach(districtSectionViewModel.buildingViewModels, id: \.self) { buildingViewModel in

                            BuildingView(viewModel: buildingViewModel)
                        }
                    }
                }

                Divider()

                Text("Wonders")
                    .font(.headline)

                ForEach(self.viewModel.wonderViewModels, id: \.self) { wonderViewModel in

                    WonderView(viewModel: wonderViewModel)
                }
            })
            .frame(width: 340, height: 300, alignment: .top)
        }
        .frame(width: 700, height: 300, alignment: .top)
        .background(Globals.Style.dialogBackground)
    }
}

#if DEBUG
struct CityChooseProductionDialogView_Previews: PreviewProvider {

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)
        let city = City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())
        let viewModel = CityProductionViewModel(city: city)

        CityProductionView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
