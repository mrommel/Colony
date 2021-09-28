//
//  TechProgressView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct TechProgressView: View {

    @ObservedObject
    public var viewModel: TechProgressViewModel

    public init(viewModel: TechProgressViewModel) {

        self.viewModel = viewModel
    }

    public var body: some View {

        ZStack(alignment: .topLeading) {

            Image(nsImage: self.viewModel.progressImage())
                .resizable()
                .frame(width: 29, height: 29)
                .padding(.top, 3.5)
                .padding(.leading, 1)

            Image(nsImage: self.viewModel.iconImage())
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.top, 8)
                .padding(.leading, 5.5)
                .onTapGesture {
                    //self.viewModel.click()
                    print("click on tech progress")
                }

            Text(self.viewModel.title())
                .padding(.top, 1)
                .padding(.leading, 35)
                .font(.footnote)

            LazyHStack(spacing: 4) {

                ForEach(self.viewModel.achievementViewModels, id: \.self) { achievementViewModel in

                    AchievementView(viewModel: achievementViewModel)
                        .id("progress-tech-\(self.viewModel.id)-\(achievementViewModel.id)")
                }
                .padding(.all, 0)
            }
            .padding(.top, 2)
            .padding(.leading, 32)

            Text("\(self.viewModel.turns)")
                .font(.system(size: 6))
                .padding(.top, 39)
                .padding(.leading, 14)

            Text(self.viewModel.boostText())
                .font(.system(size: 6))
                .padding(.top, 38)
                .padding(.leading, 39)
        }
        .frame(width: 148, height: 48, alignment: .topLeading)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "science-progress"))
                .resizable()
        )
    }
}

#if DEBUG
struct TechProgressView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModelArchery = TechProgressViewModel(techType: .archery, progress: 27, turns: 3, boosted: true)
        TechProgressView(viewModel: viewModelArchery)
            .previewDisplayName("Archery")

        let viewModelBronzeWorking = TechProgressViewModel(techType: .bronzeWorking, progress: 27, turns: 3, boosted: false)
        TechProgressView(viewModel: viewModelBronzeWorking)
            .previewDisplayName("Bronze Working")
    }
}
#endif
