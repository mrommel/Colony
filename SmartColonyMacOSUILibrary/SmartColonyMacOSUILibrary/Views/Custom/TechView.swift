//
//  TechView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary

struct TechView: View {

    @ObservedObject
    var viewModel: TechViewModel

    let zIndexValue: Double

    public init(viewModel: TechViewModel, zIndex: Double) {

        self.viewModel = viewModel
        self.zIndexValue = zIndex
    }

    public var body: some View {

        if self.viewModel.techType != .none {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Image(nsImage: self.viewModel.icon())
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .topLeading)
                        .padding(.leading, 1)
                        .padding(.top, 1)
                        .padding(.trailing, 0)

                    VStack(alignment: .leading, spacing: 0) {

                        HStack(alignment: .top, spacing: 0) {
                            Text(self.viewModel.title())
                                .frame(width: 83, height: 8, alignment: .topLeading)
                                .font(.system(size: 6))
                                .padding(.leading, 1)
                                .padding(.top, 2)

                            Text(self.viewModel.turnsText())
                                .frame(width: 28, height: 8, alignment: .topTrailing)
                                .font(.system(size: 6))
                                .padding(.trailing, 2)
                                .padding(.top, 2)
                        }

                        LazyHStack(spacing: 2) {

                            ForEach(self.viewModel.achievementViewModels, id: \.self) { achievementViewModel in

                                AchievementView(viewModel: achievementViewModel)
                                    .id("tech-\(self.viewModel.id)-\(achievementViewModel.id)")
                                    .frame(width: 16, height: 16)
                                    .zIndex(self.zIndexValue + 1)
                            }
                        }
                        .padding(.top, 0)
                        .padding(.trailing, 0)
                        .padding(.leading, 0)
                    }
                    .frame(width: 110, height: 35, alignment: .topLeading)
                    .padding(.leading, 1)
                    .padding(.top, 1)
                }
                .frame(width: 150, height: 35, alignment: .topLeading)

                Text(self.viewModel.boostText())
                    .font(.system(size: 5))
                    .padding(.leading, 5)
                    .padding(.top, 1)
            }
            .frame(width: 150, height: 45, alignment: .topLeading)
            .zIndex(self.zIndexValue)
            .background(
                Image(nsImage: self.viewModel.background())
                    .resizable(capInsets: EdgeInsets(all: 14))
            )
        } else {
            Text(" ")
                .frame(width: 150, height: 45, alignment: .topLeading)
                .background(Color.clear)
        }
    }
}

#if DEBUG
struct TechView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        TechView(viewModel: TechViewModel(techType: .archery, state: .possible, boosted: true, turns: 27), zIndex: 50)

        TechView(viewModel: TechViewModel(techType: .astrology, state: .selected, boosted: false, turns: -1), zIndex: 50)

        TechView(viewModel: TechViewModel(techType: .animalHusbandry, state: .researched, boosted: true, turns: -1), zIndex: 50)

        TechView(viewModel: TechViewModel(techType: .flight, state: .disabled, boosted: true, turns: 45), zIndex: 50)
    }
}
#endif
