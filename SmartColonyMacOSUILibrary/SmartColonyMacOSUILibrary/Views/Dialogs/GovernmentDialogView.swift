//
//  GovernmentDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

struct GovernmentDialogView: View {

    @ObservedObject
    var viewModel: GovernmentDialogViewModel

    private var gridItemLayout = [GridItem(.fixed(150)), GridItem(.fixed(150)), GridItem(.fixed(150)), GridItem(.fixed(150))]

    public init(viewModel: GovernmentDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 10) {
                Text("Government")
                    .font(.title2)
                    .bold()
                    .padding()

                ScrollView(.vertical, showsIndicators: true, content: {

                    GovernmentCardView(viewModel: self.viewModel.governmentViewModel)

                    LazyVGrid(columns: gridItemLayout, spacing: 20) {

                        ForEach(self.viewModel.policyCardViewModels, id: \.self) {

                            PolicyCardView(viewModel: $0)
                                .background(Color.white.opacity(0.1))
                        }
                    }
                })
                .background(Color.red.opacity(0.2))

                HStack {
                    Button(action: {
                        self.viewModel.closeDialog()
                    }, label: {
                        Text("Okay")
                    })

                    Button(action: {
                        self.viewModel.viewPolicies()
                    }, label: {
                        Text("View Policies")
                    })

                    Button(action: {
                        self.viewModel.viewGovernments()
                    }, label: {
                        Text("View Governments")
                    })
                }
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 700, height: 450, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}
