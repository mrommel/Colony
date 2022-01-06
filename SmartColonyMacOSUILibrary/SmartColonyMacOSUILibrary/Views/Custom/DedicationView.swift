//
//  DedicationView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.01.22.
//

import SwiftUI
import SmartAssets

struct DedicationView: View {

    @ObservedObject
    var viewModel: DedicationViewModel

    public init(viewModel: DedicationViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(alignment: .top, spacing: 4) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 32, height: 32, alignment: .topLeading)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 2.0) {

                Text(self.viewModel.title)
                    .font(.headline)

                Text(self.viewModel.summary)
                    .font(.system(size: 8.0))
            }
            .padding(.vertical, 4)

            Spacer()
                .frame(minWidth: 0, maxWidth: 32)

            if self.viewModel.selected {
                Image(nsImage: Globals.Icons.checkmark)
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .topLeading)
                    .padding(.horizontal, 8)
            }
        }
        .padding(.all, 4)
        .frame(width: 300, alignment: .leading)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-button-clicked"))
                .resizable(capInsets: EdgeInsets(all: 15))
        )
        .onTapGesture {
            self.viewModel.clicked()
        }
    }
}

#if DEBUG
import SmartAILibrary

struct DedicationView_Previews: PreviewProvider {

    private static func viewModel(dedication: DedicationType, goldenAge: Bool, selected: Bool) -> DedicationViewModel {

        let viewModel = DedicationViewModel(dedication: dedication, goldenAge: goldenAge)
        viewModel.selected = selected

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let monumentalityNormalViewModel = DedicationView_Previews.viewModel(dedication: .monumentality, goldenAge: false, selected: false)
        DedicationView(viewModel: monumentalityNormalViewModel)

        let monumentalityNormalViewModelSelected = DedicationView_Previews.viewModel(dedication: .monumentality, goldenAge: false, selected: true)
        DedicationView(viewModel: monumentalityNormalViewModelSelected)

        let monumentalityGoldenViewModel = DedicationView_Previews.viewModel(dedication: .monumentality, goldenAge: true, selected: false)
        DedicationView(viewModel: monumentalityGoldenViewModel)

        let monumentalityGoldenViewModelSelected = DedicationView_Previews.viewModel(dedication: .monumentality, goldenAge: true, selected: true)
        DedicationView(viewModel: monumentalityGoldenViewModelSelected)
    }
}
#endif
