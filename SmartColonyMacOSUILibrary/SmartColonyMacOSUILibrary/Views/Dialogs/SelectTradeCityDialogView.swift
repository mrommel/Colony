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
                
                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Okay")
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
