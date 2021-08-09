//
//  SelectTradeCityDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.07.21.
//

import SwiftUI
import SmartAILibrary

struct SelectTradeCityDialogView: View {
    
    @ObservedObject
    var viewModel: SelectTradeCityDialogViewModel
    
    private var gridItemLayout = [GridItem(.fixed(250))]
    
    public init(viewModel: SelectTradeCityDialogViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            VStack(spacing: 10) {
                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding()
                
                Text(self.viewModel.question)
                    .font(.title2)
                
                if self.viewModel.showTradeRoute {
                    GroupBox(label: Text("Yields for the selected trade route")) {
                        
                        VStack {
                            
                            HStack {
                                if self.viewModel.foodYield.value > 0 {
                                    YieldValueView(viewModel: self.viewModel.foodYield)
                                }
                                
                                if self.viewModel.productionYield.value > 0 {
                                    YieldValueView(viewModel: self.viewModel.productionYield)
                                }
                                
                                if self.viewModel.goldYield.value > 0 {
                                    YieldValueView(viewModel: self.viewModel.goldYield)
                                }
                                
                                if self.viewModel.scienceYield.value > 0 {
                                    YieldValueView(viewModel: self.viewModel.scienceYield)
                                }
                                
                                if self.viewModel.cultureYield.value > 0 {
                                    YieldValueView(viewModel: self.viewModel.cultureYield)
                                }
                                
                                if self.viewModel.faithYield.value > 0 {
                                    YieldValueView(viewModel: self.viewModel.faithYield)
                                }
                            }
                        
                            HStack {
                                Button(action: {
                                    self.viewModel.confirmTradeRoute()
                                }, label: {
                                    Text("Confirm")
                                })
                                
                                Button(action: {
                                    self.viewModel.cancelTradeRoute()
                                }, label: {
                                    Text("Cancel")
                                })
                            }
                        }
                        .frame(width: 270)
                    }
                } else {
                
                    ScrollView(.vertical, showsIndicators: true, content: {
                        
                        LazyVGrid(columns: gridItemLayout, spacing: 10) {
                            
                            ForEach(self.viewModel.targetCityViewModels) { targetCityViewModel in

                                TradeCityView(viewModel: targetCityViewModel)
                                    .padding(0)
                                    .onTapGesture {
                                        targetCityViewModel.selectCity()
                                    }
                            }
                        }
                        .padding()
                    })
                    .border(Color.gray)
                    .frame(width: 270, height: 415, alignment: .top)
                }
                
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
        .frame(width: 330, height: 550, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct SelectTradeCityDialogView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let player1 = Player(leader: .alexander)
        let player2 = Player(leader: .barbarossa)
        let cities: [AbstractCity?] = [
            City(name: "Leipzig", at: HexPoint.invalid, owner: player1),
            City(name: "Hamburg", at: HexPoint.invalid, owner: player2),
        ]
        let viewModel = SelectTradeCityDialogViewModel(cities: cities)
            
        SelectTradeCityDialogView(viewModel: viewModel)
    }
}
#endif
