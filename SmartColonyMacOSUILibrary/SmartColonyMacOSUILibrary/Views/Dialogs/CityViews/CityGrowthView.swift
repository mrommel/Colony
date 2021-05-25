//
//  CityGrowthView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityGrowthView: View {
    
    @ObservedObject
    var viewModel: CityGrowthViewModel
    
    public init(viewModel: CityGrowthViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
    
        HStack(spacing: 10) {
        
        ScrollView(.vertical, showsIndicators: true, content: {
            
            Text("Citizen Growth")
                .font(.headline)
                .padding(.top, 10)
            
            GroupBox {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Citizen")
                    Text("37 turns until a new citizen is born")
                }
                .frame(width: 220, height: 40, alignment: .top)
                .padding(.all, 4)
            }
            .frame(width: 250, height: 70, alignment: .top)
            
            GroupBox {
                VStack(spacing: 4) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("Food per turn")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Food consumption")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    Divider()
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Growth food per turn")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Amenities growth bonus")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Other growth bonuses")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    Divider()
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Modified food per turn")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Housing multiplier")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Occupied city multiplier")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                }
                .frame(minWidth: 220, maxWidth: 220, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 4)
            }
            .frame(minWidth: 250, maxWidth: 250, minHeight: 20, maxHeight: .infinity, alignment: .center)
        })
        .frame(width: 340, height: 300, alignment: .top)
        
        Divider()
    
        ScrollView(.vertical, showsIndicators: true, content: {
            
            Text("Amenities")
                .font(.headline)
                .padding(.top, 10)
            
            GroupBox {
                VStack(spacing: 4) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("Food per turn")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Food consumption")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    Divider()
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Growth food per turn")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                }
                .frame(minWidth: 220, maxWidth: 220, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 4)

            }
            .frame(minWidth: 250, maxWidth: 250, minHeight: 20, maxHeight: .infinity, alignment: .center)
            
            Text("Housing")
                .font(.headline)
                .padding(.top, 10)
            
            GroupBox {
                VStack(spacing: 4) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("Food per turn")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Food consumption")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                    
                    Divider()
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("Growth food per turn")
                        Spacer()
                        Text("+37")
                    }
                    .padding(.all, 4)
                }
                .frame(minWidth: 220, maxWidth: 220, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 4)

            }
            .frame(minWidth: 250, maxWidth: 250, minHeight: 20, maxHeight: .infinity, alignment: .center)
        })
        .frame(width: 340, height: 300, alignment: .top)
    }
    .frame(width: 700, height: 300, alignment: .top)
    .background(Globals.Style.dialogBackground)
    }
}

#if DEBUG
struct CityGrowthView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)
        let city = City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())
        let viewModel = CityGrowthViewModel(city: city)

        CityGrowthView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
