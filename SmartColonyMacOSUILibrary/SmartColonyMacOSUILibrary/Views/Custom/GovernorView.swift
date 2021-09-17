//
//  GovernorView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.09.21.
//

import SwiftUI

struct GovernorView: View {

    @ObservedObject
    var viewModel: GovernorViewModel

    public init(viewModel: GovernorViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .center, spacing: 8) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 70, height: 70, alignment: .center)

            Text(self.viewModel.name)

            Text(self.viewModel.title)

            if self.viewModel.appointed {
                Button("Promote", action: { })
                    .buttonStyle(DialogButtonStyle())

                // assign
                Button("Reassign", action: { })
                    .buttonStyle(DialogButtonStyle(state: .highlighted))
            } else {
                // view promotions

                Button("Appoint", action: { })
                    .buttonStyle(DialogButtonStyle(state: .highlighted))
            }

        }
        .frame(width: 90, height: 300, alignment: .center)
        .background(Color.red)
    }
}
