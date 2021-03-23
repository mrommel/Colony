//
//  CreateGameMenuView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import Foundation
import SwiftUI
import SmartAssets

struct PickerView: View {
    
    let title: String
    let data: [PickerData]
    
    @State
    var selectedIndex: Int
    
    var body: some View {
        
        Picker(selection: $selectedIndex, label: Text(title)) {
            ForEach(0 ..< data.count) { i in
                HStack {
                    Image(nsImage: data[i].image)
                    Text(data[i].name)
                }
                .frame(minWidth: 0, maxWidth: 200)
                .padding(4)
                .tag(i)
            }
        }
        .frame(minWidth: 0, maxWidth: 350)
        .padding(4)
    }
}

struct CreateGameMenuView: View {
    
    @ObservedObject
    var viewModel: CreateGameMenuViewModel
    
    var body: some View {
        
        VStack {
            
            Text("SmartColony").font(.largeTitle)
            
            Divider()
            
            Form {
                Section {
                    Picker(selection: $viewModel.selectedLeaderIndex, label: Text("Choose Leader")) {
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
                    .padding(4)
                    
                    Picker(selection: $viewModel.selectedDifficultyIndex, label: Text("Choose Difficulty")) {
                        ForEach(0 ..< viewModel.handicaps.count) { i in
                            HStack {
                                Image(nsImage: viewModel.handicaps[i].image)
                                Text(viewModel.handicaps[i].name)
                            }
                            .frame(minWidth: 0, maxWidth: 200)
                            .padding(4)
                            .tag(i)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: 350)
                    .padding(4)
                    
                    Picker(selection: $viewModel.selectedMapTypeIndex, label: Text("Choose Map Type")) {
                        ForEach(0 ..< viewModel.mapTypes.count) { i in
                            HStack {
                                Image(nsImage: viewModel.mapTypes[i].image)
                                Text(viewModel.mapTypes[i].name)
                            }
                            .frame(minWidth: 0, maxWidth: 200)
                            .padding(4)
                            .tag(i)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: 350)
                    .padding(4)
                    
                    Picker(selection: $viewModel.selectedMapSizeIndex, label: Text("Choose Map Size")) {
                        ForEach(0 ..< viewModel.mapSizes.count) { i in
                            HStack {
                                Image(nsImage: viewModel.mapSizes[i].image)
                                Text(viewModel.mapSizes[i].name)
                            }
                            .frame(minWidth: 0, maxWidth: 200)
                            .padding(4)
                            .tag(i)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: 350)
                    .padding(4)
                }
            }
            
            Divider()
            
            HStack {
                Button("Cancel") {
                    viewModel.cancel()
                }.buttonStyle(MenuButtonStyle()).padding(.top, 20).padding(.trailing, 20)
                
                Button("Start") {
                    viewModel.start()
                }.buttonStyle(MenuButtonStyle()).padding(.top, 20)
            }
        }
    }
}
