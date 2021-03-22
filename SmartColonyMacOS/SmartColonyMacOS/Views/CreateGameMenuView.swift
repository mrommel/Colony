//
//  CreateGameMenuView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import Foundation
import SwiftUI
import SmartAssets

struct CreateGameMenuView: View {
    
    @ObservedObject
    var viewModel: CreateGameMenuViewModel
    
    @State
    private var selectedLeaderIndex = 0
    
    var body: some View {
        
        VStack {
            
            Text("SmartColony").font(.largeTitle)
            
            Divider()
            
            Form {
                Section {
                    Picker(selection: $selectedLeaderIndex, label: Text("Choose Leader")) {
                        ForEach(0 ..< viewModel.leaders.count) { i in
                            HStack {
                                Image(nsImage: viewModel.leaders[i].image)
                                
                                Text(viewModel.leaders[i].name)
                            }
                            .frame(minWidth: 0, maxWidth: 200)
                            .padding(4)
                            .tag(i)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: 350)
                    .padding(16)
                }
            }
            
            Button("Cancel") {
                //viewModel.showingQuitConfirmationAlert = true
            }.buttonStyle(MenuButtonStyle()).padding(.top, 45)
        }
    }
}
