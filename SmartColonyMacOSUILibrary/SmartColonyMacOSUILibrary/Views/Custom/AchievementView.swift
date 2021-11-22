//
//  AchievementView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.08.21.
//

import SwiftUI
import SmartAILibrary

struct AchievementView: View {

    @ObservedObject
    var viewModel: AchievementViewModel

    public init(viewModel: AchievementViewModel) {

        self.viewModel = viewModel
    }

    public var body: some View {

        Image(nsImage: self.viewModel.image)
            .resizable()
            .frame(width: 16, height: 16, alignment: .topLeading)
            .toolTip(self.viewModel.toolTipText)
            .padding(.trailing, 0)
            .padding(.leading, 0)
    }
}

#if DEBUG
struct AchievementView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        AchievementView(viewModel: AchievementViewModel(imageName: TechType.animalHusbandry.iconTexture(), toolTipText: TechType.animalHusbandry.toolTip()))

        AchievementView(viewModel: AchievementViewModel(imageName: CivicType.codeOfLaws.iconTexture(), toolTipText: CivicType.codeOfLaws.toolTip()))

        AchievementView(viewModel: AchievementViewModel(imageName: UnitType.archer.typeTexture(), toolTipText: UnitType.archer.toolTip()))
    }
}
#endif
