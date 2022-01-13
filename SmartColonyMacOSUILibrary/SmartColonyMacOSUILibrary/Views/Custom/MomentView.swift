//
//  MomentView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.01.22.
//

import SwiftUI
import SmartAssets

struct MomentView: View {

    @ObservedObject
    var viewModel: MomentViewModel

    public init(viewModel: MomentViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack {
            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 184, height: 134)
                .padding(.all, 8)

            Label(self.viewModel.summaryText)
                .toolTip(self.viewModel.tooltipText)

            HStack {

                Text(self.viewModel.yearText)
                    .font(.caption)

                Text("|")
                    .font(.caption)

                Text(self.viewModel.turnText)
                    .font(.caption)

                Text("|")
                    .font(.caption)

                Text(self.viewModel.scoreText)
                    .font(.caption)
            }
        }
        .frame(width: 200, height: 200)
    }
}

#if DEBUG
import SmartAILibrary

struct MomentView_Previews: PreviewProvider {

    private static func viewModel(momentType: MomentType, turn: Int) -> MomentViewModel {

        let viewModel = MomentViewModel(moment: Moment(type: momentType, turn: turn))

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let momentViewModel = MomentView_Previews.viewModel(momentType: .constructSpecialtyDistrict, turn: 5)
        MomentView(viewModel: momentViewModel)
    }
}
#endif
