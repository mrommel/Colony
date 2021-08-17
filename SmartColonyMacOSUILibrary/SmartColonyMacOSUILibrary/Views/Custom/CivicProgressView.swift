//
//  CivicProgressView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

struct CivicProgressView: View {

    @ObservedObject
    public var viewModel: CivicProgressViewModel

    private var gridItemLayout = [
        GridItem(.fixed(18), spacing: 2.0),
        GridItem(.fixed(18), spacing: 2.0),
        GridItem(.fixed(18), spacing: 2.0),
        GridItem(.fixed(18), spacing: 2.0),
        GridItem(.fixed(18), spacing: 2.0),
        GridItem(.fixed(18), spacing: 2.0),
        GridItem(.fixed(18), spacing: 2.0)
    ]

    public init(viewModel: CivicProgressViewModel) {

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
                    print("click")
                }

            Text(self.viewModel.title())
                .padding(.top, 1)
                .padding(.leading, 35)
                .font(.footnote)

            LazyVGrid(columns: gridItemLayout, spacing: 4) {

                ForEach(self.viewModel.achievementViewModels, id: \.self) { achievementViewModel in

                    AchievementView(viewModel: achievementViewModel)
                        .id("progress-civic-\(self.viewModel.id)-\(achievementViewModel.id)")
                }
                .padding(.top, 4)
                .padding(.trailing, 0)
                .padding(.leading, 10)
            }
            .padding(.top, 12)
            .padding(.leading, 28)

            Text(self.viewModel.boostText())
                .font(.system(size: 5))
                .padding(.top, 38)
                .padding(.leading, 39)
        }
        .frame(width: 148, height: 48, alignment: .topLeading)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "culture-progress"))
                .resizable()
        )
    }
}

#if DEBUG
struct CivicProgressView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = CivicProgressViewModel(civicType: .codeOfLaws, progress: 27, boosted: true)

        CivicProgressView(viewModel: viewModel)
            .previewDisplayName("Code of Laws")
    }
}
#endif

/*#if DEBUG
struct Test_Previews: PreviewProvider {
    
    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)
        
        let viewModel = CivicProgressViewModel(civicType: .codeOfLaws, progress: 27, boosted: true)
        
        VStack {
        
            CivicProgressView(viewModel: viewModel)

            CivicDialogView(viewModel: CivicDialogViewModel(game: game))
                .environment(\.gameEnvironment, environment)
        }
        .previewDisplayName("Code of Laws + Civic Tree Dialog")
    }
}
#endif*/
