//
//  UnitBannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 09.08.21.
//

import SwiftUI
import SmartAILibrary

struct UnitBannerView: View {
    
    @ObservedObject
    public var viewModel: UnitBannerViewModel
    
    @State
    var showBanner: Bool = false
    
    public var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                
                Spacer()
                
                ZStack(alignment: .bottom) {

                    Image(nsImage: ImageCache.shared.image(for: "unit-banner"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 112, alignment: .bottomTrailing)
                    
                    Text(self.viewModel.unitName())
                        .font(.footnote)
                        .padding(.bottom, 76)
                    
                    Text(self.viewModel.unitMoves())
                        .offset(x: 60, y: -60)
                    
                    Text(self.viewModel.unitHealth())
                        .offset(x: 60, y: -40)
                    
                    Text(self.viewModel.unitCharges())
                        .offset(x: 60, y: -20)
                    
                    Image(nsImage: self.viewModel.commandImage(at: 3))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .offset(x: 30, y: -107)
                        .onTapGesture {
                            self.viewModel.commandClicked(at: 3)
                        }
                    
                    Image(nsImage: self.viewModel.commandImage(at: 2))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .offset(x: 65, y: -107)
                        .onTapGesture {
                            self.viewModel.commandClicked(at: 2)
                        }
                    
                    Image(nsImage: self.viewModel.commandImage(at: 1))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .offset(x: 100, y: -107)
                        .onTapGesture {
                            self.viewModel.commandClicked(at: 1)
                        }
                    
                    Image(nsImage: self.viewModel.commandImage(at: 0))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .offset(x: 135, y: -107)
                        .onTapGesture {
                            self.viewModel.commandClicked(at: 0)
                        }
                }
                .frame(width: 300, height: 112, alignment: .bottomTrailing)
                .offset(x: 0, y: self.showBanner ? 0 : 300)
                .onReceive(self.viewModel.$showBanner, perform: { value in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.showBanner = value
                    }
                })
                
                Spacer()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct UnitBannerView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)
        
        let player = Player(leader: .alexander, isHuman: false)
        let unit = Unit(at: HexPoint.zero, type: UnitType.settler, owner: player)
        let viewModel = UnitBannerViewModel(selectedUnit: unit, in: game)
        
        UnitBannerView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
