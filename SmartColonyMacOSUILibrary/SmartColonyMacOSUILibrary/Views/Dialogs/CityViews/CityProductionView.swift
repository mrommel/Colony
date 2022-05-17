//
//  CityChooseProductionDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct BuildableItemView: View {

    @ObservedObject
    var viewModel: QueueViewModel

    var body: some View {
        // swiftlint:disable force_cast
        switch self.viewModel.queueType {

        case .unit:
            UnitView(viewModel: self.viewModel as! UnitViewModel)
                .onDrag {
                    NSItemProvider(object: (self.viewModel as! UnitViewModel))
                }
        case .district:
            DistrictView(viewModel: self.viewModel as! DistrictViewModel)
                .onDrag {
                    NSItemProvider(object: (self.viewModel as! DistrictViewModel))
                }
        case .building:
            BuildingView(viewModel: self.viewModel as! BuildingViewModel)
                .onDrag {
                    NSItemProvider(object: (self.viewModel as! BuildingViewModel))
                }
        case .wonder:
            WonderView(viewModel: self.viewModel as! WonderViewModel)
                .onDrag {
                    NSItemProvider(object: (self.viewModel as! WonderViewModel))
                }
        default:
            Text("type \(self.viewModel.queueType.rawValue)")
        }
        // swiftlint:enable force_cast
    }
}

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

        // ScrollView(.vertical, showsIndicators: true) {
        VStack {
            if self.viewModel.queueViewModels.isEmpty {
                Text("TXT_KEY_EMPTY_QUEUE".localized())
                    .font(.headline)
                    .padding(.top, 10)
            } else {
                self.queueListView
            }
        }
        .frame(width: 340, height: 300, alignment: .top)
    }

    var queueListView: some View {

        List {
            ForEach(Array(self.viewModel.queueViewModels.enumerated()), id: \.element) { index, queueViewModel in

                BuildableItemView(viewModel: queueViewModel)
                    .zIndex(500.0 - Double(index))
            }
            .onInsert(of: ["public.item"], perform: self.viewModel.onDroppedQueueItem)
        }
        .background(Color.clear)
    }

    var buildableItemsView: some View {

        ScrollView(.vertical, showsIndicators: true, content: {

            Text("TXT_KEY_UNITS".localized())
                .font(.headline)
                .padding(.top, 10)
                .zIndex(500.1)

            ForEach(Array(self.viewModel.unitViewModels.enumerated()), id: \.element) { index, unitViewModel in

                UnitView(viewModel: unitViewModel)
                    .zIndex(500.0 - Double(index)) // needed for tooltip
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

            Divider()

            Text("TXT_KEY_WONDERS".localized())
                .font(.headline)
                .zIndex(50.1)

            ForEach(Array(self.viewModel.wonderViewModels.enumerated()), id: \.element) { index, wonderViewModel in

                WonderView(viewModel: wonderViewModel)
                    .zIndex(50.0 - Double(index)) // needed for tooltip
            }

            Spacer(minLength: 50)
        })
        .frame(width: 340, height: 300, alignment: .top)
    }

    var locationPickerView: some View {

        ScrollView(.vertical, showsIndicators: true, content: {

            Text("TXT_KEY_SELECT_LOCATION".localized())
                .font(.headline)
                .padding(.top, 10)

            HexagonGridView(viewModel: self.viewModel.hexagonGridViewModel)
                .frame(width: 300, height: 300, alignment: .top)

            Button("TXT_KEY_CANCEL".localized()) {
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
        viewModel.gameEnvironment.game.send(gameModel)

        viewModel.showLocationPicker = showLocationPicker
        viewModel.hexagonGridViewModel.mode = HexagonGridViewMode.districtLocation(type: .campus)

        viewModel.update(for: city, with: gameModel)

        return viewModel
    }

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let game = DemoGameModel()
        let cityProductionViewModel =
            CityProductionView_Previews.viewModel(
                for: game,
                showLocationPicker: false
            )

        CityProductionView(viewModel: cityProductionViewModel)
            // .environment(\.gameEnvironment, environment)
            .previewDisplayName("Picker")
    }
}
#endif
