//
//  CityDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

struct CityDialogView: View {
    
    @ObservedObject
    var viewModel: CityDialogViewModel
    
    public init(viewModel: CityDialogViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            VStack(spacing: 10) {
                Text(self.viewModel.cityName)
                    .font(.title2)
                    .bold()
                    .padding()

                HStack(alignment: .center) {
                    YieldValueView(viewModel: self.viewModel.scienceYieldViewModel)
                    
                    YieldValueView(viewModel: self.viewModel.cultureYieldViewModel)
                    
                    YieldValueView(viewModel: self.viewModel.foodYieldViewModel)
                    
                    YieldValueView(viewModel: self.viewModel.productionYieldViewModel)
                    
                    YieldValueView(viewModel: self.viewModel.goldYieldViewModel)
                    
                    YieldValueView(viewModel: self.viewModel.faithYieldViewModel)
                }
                
                // if no current production
                Button(action: {
                    self.viewModel.showChooseProductionDialog()
                }, label: {
                    Text("Choose Production")
                })
                
                Button(action: {
                    self.viewModel.showManageProductionDialog()
                }, label: {
                    Text("Manage Production")
                })
                
                Button(action: {
                    self.viewModel.showBuildingsDialog()
                }, label: {
                    Text("X Buildings")
                })
                
                Button(action: {
                    self.viewModel.showGrowthDialog()
                }, label: {
                    Text("Growth")
                })
                
                Button(action: {
                    self.viewModel.showManageCitizenDialog()
                }, label: {
                    Text("Manage Citizen")
                })
                
                Divider()
                
                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Cancel")
                })
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 500, height: 550, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct CityDialogView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        CityDialogView(viewModel: CityDialogViewModel(city: City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())))
            .environment(\.gameEnvironment, environment)
    }
}
#endif
