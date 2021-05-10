//
//  PolicyDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.05.21.
//

import SwiftUI
import SmartAILibrary

struct PolicyDialogView: View {
    
    let viewModel: PolicyDialogViewModel?
    
    @State
    private var showGreeting = true // todo: remove
    
    private var gridItemLayout = [GridItem(.fixed(150)), GridItem(.fixed(150)), GridItem(.fixed(150)), GridItem(.fixed(150))]
    
    public init(viewModel: PolicyDialogViewModel?) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            VStack(spacing: 10) {
                Text("Select Policies")
                    .font(.title2)
                    .bold()
                    .padding()
                
                Text(viewModel?.slots.hint() ?? "hint")
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        
                        ForEach(PolicyCardType.all, id: \.self) {
                            
                            let state: PolicyCardState = self.viewModel?.state(of: $0) ?? PolicyCardState.disabled
                            
                            PolicyCardView(viewModel: PolicyCardViewModel(policyCardType: $0, state: state))
                                .background(Color.white.opacity(0.1))
                        }
                    }
                })
                
                Button(action: { self.viewModel?.closeDialog() },
                       label: {
                    Text("Okay")
                })
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 700, height: 450, alignment: .top)
        .background(
            Image("grid9-dialog")
                .resizable(capInsets: EdgeInsets(all: 45)
            )
        )
    }
}

/*
// execution takes too long
 
#if DEBUG
struct PolicyDialogView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let environment = GameEnvironment(game: DemoGameModel())
        
        PolicyDialogView(viewModel: PolicyDialogViewModel())
            .environment(\.gameEnvironment, environment)
    }
}
#endif*/
