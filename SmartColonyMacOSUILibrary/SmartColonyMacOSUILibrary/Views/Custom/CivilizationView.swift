//
//  CivilizationView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CivilizationView: View {

    @ObservedObject
    var viewModel: CivilizationViewModel

    public init(viewModel: CivilizationViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        
        Image(nsImage: self.viewModel.image())
            .resizable()
            .frame(width: 42, height: 42)
            .tooltip(self.viewModel.toolTip)
    }
}

#if DEBUG
struct CivilizationView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModelFrench = CivilizationViewModel(civilization: .french)
        CivilizationView(viewModel: viewModelFrench)

        let viewModelEnglish = CivilizationViewModel(civilization: .english)
        CivilizationView(viewModel: viewModelEnglish)
    }
}
#endif
