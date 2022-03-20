//
//  ApproachItemView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 20.03.22.
//

import SwiftUI
import SmartAssets

struct ApproachItemView: View {

    @ObservedObject
    var viewModel: ApproachItemViewModel

    public init(viewModel: ApproachItemViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack {
            Text(self.viewModel.valueText)
                .foregroundColor(self.viewModel.value > 0 ? .green : .red)

            Text(self.viewModel.text)
        }
    }
}
