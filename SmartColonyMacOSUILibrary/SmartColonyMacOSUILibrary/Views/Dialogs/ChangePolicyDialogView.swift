//
//  ChangePolicyDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.05.21.
//

import SwiftUI
import SmartAILibrary

struct ChangePolicyDialogView: View {

    @ObservedObject
    var viewModel: ChangePolicyDialogViewModel

    private var gridItemLayout = [GridItem(.fixed(150)), GridItem(.fixed(150)), GridItem(.fixed(150)), GridItem(.fixed(150))]

    public init(viewModel: ChangePolicyDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            VStack(spacing: 10) {
                HStack {

                    Spacer()

                    Text("Select Policies")
                        .font(.title2)
                        .bold()
                        .padding()

                    Spacer()

                    Button(action: {
                        self.viewModel.closeDialog()
                    }, label: {
                        Text("X")
                    })
                }

                HStack {
                    Text("Government: ")

                    Text(self.viewModel.governmentName())
                }

                HStack {

                    Text("Slots:")

                    Text(self.viewModel.policyCardSlotTypeText(of: PolicyCardSlotType.military))

                    Image(nsImage: self.viewModel.policyCardSlotTypeImage(of: PolicyCardSlotType.military))
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)

                    Text(self.viewModel.policyCardSlotTypeText(of: PolicyCardSlotType.economic))

                    Image(nsImage: self.viewModel.policyCardSlotTypeImage(of: PolicyCardSlotType.economic))
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)

                    Text(self.viewModel.policyCardSlotTypeText(of: PolicyCardSlotType.diplomatic))

                    Image(nsImage: self.viewModel.policyCardSlotTypeImage(of: PolicyCardSlotType.diplomatic))
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)

                    Text(self.viewModel.policyCardSlotTypeText(of: PolicyCardSlotType.wildcard))

                    Image(nsImage: self.viewModel.policyCardSlotTypeImage(of: PolicyCardSlotType.wildcard))
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                }

                Text(self.viewModel.hint())

                ScrollView(.vertical, showsIndicators: true, content: {

                    LazyVGrid(columns: gridItemLayout, spacing: 20) {

                        ForEach(self.viewModel.policyCardViewModels, id: \.self) {

                            PolicyCardView(viewModel: $0)
                                .background(Color.white.opacity(0.1))
                        }
                    }
                })

                Button(action: {
                    self.viewModel.closeAndSaveDialog()
                }, label: {
                    Text("Okay")
                })
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

/*
// execution takes too long
 
#if DEBUG
struct PolicyDialogView_Previews: PreviewProvider {
    
    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let environment = GameEnvironment(game: DemoGameModel())
        
        PolicyDialogView(viewModel: PolicyDialogViewModel())
            .environment(\.gameEnvironment, environment)
    }
}
#endif*/
