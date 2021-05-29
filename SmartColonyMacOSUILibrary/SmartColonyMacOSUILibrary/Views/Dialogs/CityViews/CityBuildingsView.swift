//
//  CityBuildingsView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityBuildingsView: View {
    
    @ObservedObject
    var viewModel: CityBuildingsViewModel
    
    public init(viewModel: CityBuildingsViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true, content: {
            
            GroupBox(label: Text("City breakdown")
                        .font(.headline)
                        .padding(.top, 10)) {
                
                VStack(alignment: .center) {
                    Text("3 Districts constructed")
                }
                .frame(width: 300, height: 18, alignment: .topLeading)
                .padding(.all, 4)
            }
            
            GroupBox(label: Text("Buildings and Districts")
                        .font(.headline)
                        .padding(.top, 10)) {
                
                VStack(alignment: .center, spacing: 4) {
                    
                    ForEach(self.viewModel.districtSectionViewModels, id:\.self) { districtSectionViewModel in
                        
                        DistrictView(viewModel: districtSectionViewModel.districtViewModel)
                
                        ForEach(districtSectionViewModel.buildingViewModels, id:\.self) { buildingViewModel in
                        
                            BuildingView(viewModel: buildingViewModel)
                        }
                    }
                    
                    Text("")
                        .frame(minWidth: 300, maxWidth: 300, minHeight: 5, maxHeight: 5, alignment: .center)
                }
                .padding(.all, 4)
            }
            
            GroupBox(label: Text("Wonders")
                        .font(.headline)
                        .padding(.top, 10)) {
                
                VStack {
                    
                    ForEach(self.viewModel.wonderViewModels, id:\.self) { wonderViewModel in
                    
                        WonderView(viewModel: wonderViewModel)
                    }
                        
                    Text("")
                        .frame(minWidth: 300, maxWidth: 300, minHeight: 5, maxHeight: 5, alignment: .center)
                }
                .padding(.all, 4)
            }
            
            GroupBox(label: Text("Trading Posts")
                        .font(.headline)
                        .padding(.top, 10)) {
                
                VStack {
  
                    ForEach(self.viewModel.tradePostViewModels, id:\.self) { tradePostViewModel in
                    
                        TradePostView(viewModel: tradePostViewModel)
                    }
                    
                    Text("")
                }
                .frame(minWidth: 300, maxWidth: 300, minHeight: 5, maxHeight: 5, alignment: .center)
                .padding(.all, 4)
            }
            
            Spacer()
        })
        .frame(width: 700, height: 300, alignment: .top)
        .background(Globals.Style.dialogBackground)
    }
}

#if DEBUG
struct CityBuildingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        CityBuildingsView(viewModel: CityBuildingsViewModel(city: City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())))
            .environment(\.gameEnvironment, environment)
    }
}
#endif
