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

            if self.viewModel.showLocationPicker {

                self.locationPickerView
            } else {
                self.queueView

                Divider()

                self.buildableItemsView
            }
        }
        .frame(width: 700, height: 300, alignment: .top)
        .background(Globals.Style.dialogBackground)
    }

    var queueView: some View {

        ScrollView(.vertical, showsIndicators: true, content: {

            if self.viewModel.queueViewModels.isEmpty {
                Text("Please add a unit / building / wonder")
                    .font(.headline)
                    .padding(.top, 10)
            }

            ForEach(self.viewModel.queueViewModels, id: \.self) { queueViewModel in

                // swiftlint:disable force_cast
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
                // swiftlint:enable force_cast
            }
        })
        .frame(width: 340, height: 300, alignment: .top)
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

    var locationPickerView: some View {

        ScrollView(.vertical, showsIndicators: true, content: {

            Text("Select Location")
                .font(.headline)
                .padding(.top, 10)

            HexagonGridView(viewModel: self.viewModel.hexagonGridViewModel)
                .frame(width: 300, height: 300, alignment: .top)

            Button("Cancel") {
                self.viewModel.cancelLocationPicker()
            }
            .buttonStyle(GameButtonStyle())
            .padding(.top, 20)
            .padding(.trailing, 20)

            Spacer()
        })
            .frame(width: 340, height: 300, alignment: .top)
    }
}

#if DEBUG
struct CityProductionView_Previews: PreviewProvider {

    static func viewModel(for gameModel: GameModel, showLocationPicker: Bool) -> CityProductionViewModel {

        let city = City(
            name: "Berlin",
            at: HexPoint(x: 7, y: 4),
            capital: true,
            owner: gameModel.humanPlayer()
        )
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        let viewModel = CityProductionViewModel(city: city)
        viewModel.showLocationPicker = showLocationPicker
        viewModel.hexagonGridViewModel.mode = HexagonGridViewMode.districtLocation(type: .campus)

        viewModel.update(for: city, with: gameModel)

        return viewModel
    }

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        /*let viewModelShowNoLocationPicker =
            CityProductionView_Previews.viewModel(
                for: game,
                showLocationPicker: false
            )

        CityProductionView(viewModel: viewModelShowNoLocationPicker)
            .environment(\.gameEnvironment, environment)
            .previewDisplayName("Normal")*/

        let viewModelShowLocationPicker =
            CityProductionView_Previews.viewModel(
                for: game,
                showLocationPicker: true
            )

        CityProductionView(viewModel: viewModelShowLocationPicker)
            .environment(\.gameEnvironment, environment)
            .previewDisplayName("Picker")
    }
}
#endif
