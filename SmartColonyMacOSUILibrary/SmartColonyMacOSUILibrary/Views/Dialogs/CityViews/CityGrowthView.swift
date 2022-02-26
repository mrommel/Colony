//
//  CityGrowthView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityGrowthView: View {

    @ObservedObject
    var viewModel: CityGrowthViewModel

    public init(viewModel: CityGrowthViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(spacing: 10) {

        ScrollView(.vertical, showsIndicators: true, content: {

            Text("Citizen Growth")
                .font(.headline)
                .padding(.top, 10)

            GroupBox {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Citizen")
                    Text("\(self.viewModel.growthInTurns) turns until a new citizen is born")
                }
                .frame(width: 220, height: 40, alignment: .top)
                .padding(.all, 4)
            }
            .frame(width: 250, height: 70, alignment: .top)

            GroupBox {
                VStack(spacing: 4) {

                    Group {
                        HStack(alignment: .center, spacing: 4) {
                            Text("Food per turn")
                            Spacer()
                            Text(self.viewModel.lastTurnFoodHarvested)
                        }
                        .padding(.all, 4)

                        HStack(alignment: .center, spacing: 4) {
                            Text("Food consumption")
                            Spacer()
                            Text(self.viewModel.foodConsumption)
                        }
                        .padding(.all, 4)
                    }

                    Divider()

                    Group {
                        HStack(alignment: .center, spacing: 4) {
                            Text("Growth food per turn")
                            Spacer()
                            Text(self.viewModel.foodSurplus)
                        }
                        .padding(.all, 4)

                        HStack(alignment: .center, spacing: 4) {
                            Text("Amenities growth bonus")
                            Spacer()
                            Text(self.viewModel.amenitiesModifier)
                        }
                        .padding(.all, 4)

                        HStack(alignment: .center, spacing: 4) {
                            Text("Other growth bonuses")
                            Spacer()
                            Text("???")
                        }
                        .padding(.all, 4)
                    }

                    Divider()

                    Group {
                        HStack(alignment: .center, spacing: 4) {
                            Text("Modified food per turn")
                            Spacer()
                            Text("???")
                        }
                        .padding(.all, 4)

                        HStack(alignment: .center, spacing: 4) {
                            Text("Housing multiplier")
                            Spacer()
                            Text(self.viewModel.housingModifier)
                        }
                        .padding(.all, 4)

                        HStack(alignment: .center, spacing: 4) {
                            Text("Occupied city multiplier")
                            Spacer()
                            Text("???")
                        }
                        .padding(.all, 4)
                    }

                    Divider()

                    Group {
                        HStack(alignment: .center, spacing: 4) {
                            Text("Total Food Surplus")
                            Spacer()
                            Text(self.viewModel.lastTurnFoodEarned)
                        }
                        .padding(.all, 4)
                    }
                }
                .frame(minWidth: 220, maxWidth: 220, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 4)

            }
            .frame(minWidth: 250, maxWidth: 250, minHeight: 20, maxHeight: .infinity, alignment: .center)

            GroupBox {
                HStack(alignment: .center, spacing: 4) {
                    Text("Growth in")
                    Text(self.viewModel.growthInTurns)
                }
                .frame(width: 220, height: 20, alignment: .top)
                .padding(.all, 4)
            }
            .frame(width: 250, height: 40, alignment: .top)

        })
        .frame(width: 340, height: 300, alignment: .top)

        Divider()

        ScrollView(.vertical, showsIndicators: true, content: {

            Text("Amenities")
                .font(.headline)
                .padding(.top, 10)

            GroupBox {
                VStack(spacing: 4) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("X Amenities of Y Required")
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Status")
                        Spacer()
                        Text("Displeased")
                    }
                    .padding(.all, 4)
                }
                .frame(width: 220, height: 52, alignment: .topLeading)
                .padding(.all, 4)
            }
            .frame(minWidth: 250, maxWidth: 250, minHeight: 20, maxHeight: .infinity, alignment: .center)

            GroupBox {
                VStack(spacing: 4) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("Citizen Growth")
                        Spacer()
                        Text("-15%")
                    }
                    .padding(.all, 4)

                    Divider()

                    HStack(alignment: .center, spacing: 4) {
                        Text("Luxury")
                        Spacer()
                        Text(self.viewModel.amenitiesFromLuxuries)
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Entertainment")
                        Spacer()
                        Text(self.viewModel.amenitiesFromEntertainment)
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Religion")
                        Spacer()
                        Text(self.viewModel.amenitiesFromReligion)
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("War Weariness")
                        Spacer()
                        Text(self.viewModel.amenitiesFromWarWeariness)
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Civics")
                        Spacer()
                        Text(self.viewModel.amenitiesFromCivics)
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Great People")
                        Spacer()
                        Text("0")
                    }
                    .padding(.all, 4)
                }
                .frame(minWidth: 220, maxWidth: 220, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 4)
            }
            .frame(minWidth: 250, maxWidth: 250, minHeight: 20, maxHeight: .infinity, alignment: .center)

            Text("Housing")
                .font(.headline)
                .padding(.top, 10)

            GroupBox {
                VStack(spacing: 4) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("X Housing for Y Citizen")
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Populationgrowthrate")
                        Spacer()
                        Text("???")
                    }
                    .padding(.all, 4)
                }
                .frame(minWidth: 220, maxWidth: 220, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 4)
            }
            .frame(minWidth: 250, maxWidth: 250, minHeight: 20, maxHeight: .infinity, alignment: .center)

            GroupBox {
                VStack(spacing: 4) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("Building")
                        Spacer()
                        Text(self.viewModel.housingFromBuildings)
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("District")
                        Spacer()
                        Text(self.viewModel.housingFromDistricts)
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Water")
                        Spacer()
                        Text(self.viewModel.housingFromWater)
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Era")
                        Spacer()
                        Text("?")
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Civics")
                        Spacer()
                        Text("?")
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Great People")
                        Spacer()
                        Text("0")
                    }
                    .padding(.all, 4)

                    HStack(alignment: .center, spacing: 4) {
                        Text("Improvement")
                        Spacer()
                        Text("0")
                    }
                    .padding(.all, 4)
                }
                .frame(minWidth: 220, maxWidth: 220, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 4)

            }
            .frame(minWidth: 250, maxWidth: 250, minHeight: 20, maxHeight: .infinity, alignment: .center)
        })
        .frame(width: 340, height: 300, alignment: .top)
    }
    .frame(width: 700, height: 300, alignment: .top)
    .background(Globals.Style.dialogBackground)
    }
}

#if DEBUG
struct CityGrowthView_Previews: PreviewProvider {

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)
        let city = City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())
        let viewModel = CityGrowthViewModel(city: city)

        CityGrowthView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
