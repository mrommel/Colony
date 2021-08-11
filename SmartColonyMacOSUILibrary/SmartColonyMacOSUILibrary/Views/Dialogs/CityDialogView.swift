//
//  CityDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityDialogView: View {
    
    @ObservedObject
    var viewModel: CityDialogViewModel
    
    public init(viewModel: CityDialogViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            VStack(spacing: 0) {
                
                Text(self.viewModel.cityName)
                    .font(.title2)
                    .bold()
                    .padding(.top, 13)
                    .padding(.bottom, 10)
                
                VStack(spacing: 10) {
                    
                    Text("Population: \(self.viewModel.population)")

                    HStack(alignment: .center) {
                        YieldValueView(viewModel: self.viewModel.scienceYieldViewModel)
                        
                        YieldValueView(viewModel: self.viewModel.cultureYieldViewModel)
                        
                        YieldValueView(viewModel: self.viewModel.foodYieldViewModel)
                        
                        YieldValueView(viewModel: self.viewModel.productionYieldViewModel)
                        
                        YieldValueView(viewModel: self.viewModel.goldYieldViewModel)
                        
                        YieldValueView(viewModel: self.viewModel.faithYieldViewModel)
                    }
                    
                    Divider()
                    
                    self.detailView
                        .frame(width: 700, height: 300, alignment: .top)
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 25) {
                        
                        ForEach(CityDetailViewType.all, id: \.self) { value in
                            Button(action: {
                                self.viewModel.show(detail: value)
                            }) {
                                Text(value.name())
                                    .font(.system(size: 15))
                                    .foregroundColor(value == self.viewModel.cityDetailViewType
                                        ? Color.accentColor
                                        : Color.gray)
                                    .animation(nil)
                            }
                        }
                    }
                    
                    Divider()
                    
                    Button(action: {
                        self.viewModel.closeDialog()
                    }, label: {
                        Text("Cancel")
                    })
                    .padding(.bottom, 8)
                }
                .padding(.top, 10)
                .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 43)
            .padding(.leading, 19)
            .padding(.trailing, 19)
        }
        .frame(width: 750, height: 550, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
    
    var detailView: AnyView {
        
        switch self.viewModel.cityDetailViewType {
        
        case .production:
            return AnyView(CityProductionView(viewModel: self.viewModel.productionViewModel))
        case .buildings:
            return AnyView(CityBuildingsView(viewModel: self.viewModel.buildingsViewModel))
        case .growth:
            return AnyView(CityGrowthView(viewModel: self.viewModel.growthViewModel))
        case .citizen:
            return AnyView(CityCitizenView(viewModel: self.viewModel.citizenViewModel))
        case .religion:
            return AnyView(CityReligionView(viewModel: self.viewModel.religionViewModel))
        }
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
