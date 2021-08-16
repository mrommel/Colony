//
//  CivicView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary

struct CivicView: View {

    @ObservedObject
    var viewModel: CivicViewModel

    private var gridItemLayout = [
        GridItem(.fixed(16), spacing: 2.0),
        GridItem(.fixed(16), spacing: 2.0),
        GridItem(.fixed(16), spacing: 2.0),
        GridItem(.fixed(16), spacing: 2.0),
        GridItem(.fixed(16), spacing: 2.0),
        GridItem(.fixed(16), spacing: 2.0),
        GridItem(.fixed(16), spacing: 2.0)
    ]

    public init(viewModel: CivicViewModel) {

        self.viewModel = viewModel
    }

    public var body: some View {

        if self.viewModel.civicType != .none {
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
                                .frame(width: 28, height: 8, alignment:
                                    .topTrailing)
                                .font(.system(size: 6))
                                .padding(.trailing, 2)
                                .padding(.top, 2)
                        }

                        LazyVGrid(columns: gridItemLayout, spacing: 4) {

                            ForEach(self.viewModel.achievementViewModels, id: \.self) { achievementViewModel in

                                AchievementView(viewModel: achievementViewModel)
                                    .id("civic-\(self.viewModel.id)-\(achievementViewModel.id)")
                            }
                        }
                        .padding(.top, 4)
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
struct CivicView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        CivicView(viewModel: CivicViewModel(civicType: .codeOfLaws, state: .possible, boosted: true, turns: 27))

        CivicView(viewModel: CivicViewModel(civicType: .guilds, state: .selected, boosted: false, turns: -1))

        CivicView(viewModel: CivicViewModel(civicType: .feudalism, state: .researched, boosted: true, turns: -1))
    }
}
#endif
