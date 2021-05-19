//
//  CityChooseProductionDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

struct CityChooseProductionDialogView: View {
    
    @ObservedObject
    var viewModel: CityChooseProductionDialogViewModel
    
    private var gridItemLayout = [GridItem(.fixed(300))]
    
    public init(viewModel: CityChooseProductionDialogViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            VStack(spacing: 10) {
                Text(self.viewModel.cityName)
                    .font(.title2)
                    .bold()
                    .padding()
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    
                    ForEach(self.viewModel.unitViewModels, id:\.self) { unitViewModel in
                    
                        UnitView(viewModel: unitViewModel)
                    }
                    
                    Divider()
                    
                    LazyVGrid(columns: gridItemLayout, spacing: 10) {
                        
                        ForEach(self.viewModel.districtSectionViewModels, id:\.self) { districtSectionViewModel in
                            
                            DistrictView(viewModel: districtSectionViewModel.districtViewModel)
                    
                            ForEach(districtSectionViewModel.buildingViewModels, id:\.self) { buildingViewModel in
                            
                                BuildingView(viewModel: buildingViewModel)
                            }
                        }
                    }
                    
                    Divider()
                    
                    ForEach(self.viewModel.wonderViewModels, id:\.self) { wonderViewModel in
                    
                        WonderView(viewModel: wonderViewModel)
                    }
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
struct CityChooseProductionDialogView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        CityChooseProductionDialogView(viewModel: CityChooseProductionDialogViewModel(city: City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())))
            .environment(\.gameEnvironment, environment)
    }
}
#endif
