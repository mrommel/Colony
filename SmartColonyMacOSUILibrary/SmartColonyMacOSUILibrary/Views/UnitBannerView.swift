//
//  UnitBannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 09.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct UnitGroupBoxStyle: GroupBoxStyle {

    func makeBody(configuration: Configuration) -> some View {
        
        VStack(alignment: .leading) {
            configuration.content
        }
        .padding(.top, 2)
        .padding(.bottom, 2)
        .padding(.leading, 6)
        .padding(.trailing, 6)
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }
}

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
                    
                    Group {
                        Image(nsImage: self.viewModel.commandImage(at: 4))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: -40, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 4)
                            }
                        
                        Image(nsImage: self.viewModel.commandImage(at: 3))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: -5, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 3)
                            }
                        
                        Image(nsImage: self.viewModel.commandImage(at: 2))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: 30, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 2)
                            }
                        
                        Image(nsImage: self.viewModel.commandImage(at: 1))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: 65, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 1)
                            }
                        
                        Image(nsImage: self.viewModel.commandImage(at: 0))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: 100, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 0)
                            }
                    }

                    Image(nsImage: ImageCache.shared.image(for: "unit-banner"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                    
                    // progress
                    ProgressCircle(value: self.$viewModel.unitHealthValue,
                                   maxValue: 1.0,
                                   style: .line,
                                   backgroundColor: Color(Globals.Colors.progressBackground),
                                   foregroundColor: Color(.green),
                                   lineWidth: 10)
                        .frame(height: 47)
                        .offset(x: -80.3, y: -29)
                    
                    // unit type

                    GroupBox(content: {
                        Text(self.viewModel.unitName())
                            .frame(width: 120, alignment: .leading)
                    })
                    .groupBoxStyle(UnitGroupBoxStyle())
                    .offset(x: 25, y: -76)
                    
                    GroupBox(content: {
                        Text(self.viewModel.unitMoves())
                            .frame(width: 120, alignment: .leading)
                    })
                    .groupBoxStyle(UnitGroupBoxStyle())
                    .offset(x: 25, y: -54)
                    
                    GroupBox(content: {
                        Text(self.viewModel.unitHealth())
                            .frame(width: 120, alignment: .leading)
                    })
                    .groupBoxStyle(UnitGroupBoxStyle())
                    .offset(x: 25, y: -32)
                    
                    if self.viewModel.unitCharges().count > 0 {
                        GroupBox(content: {
                            Text(self.viewModel.unitCharges())
                            .frame(width: 120, alignment: .leading)
                        })
                        .groupBoxStyle(UnitGroupBoxStyle())
                        .offset(x: 25, y: -10)
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
        let pt = HexPoint(x: 1, y: 2)
        let commands = [
            Command(type: .found, location: pt),
            Command(type: .buildFarm, location: pt),
            Command(type: .buildMine, location: pt),
            Command(type: .buildCamp, location: pt)
        ]
        
        let player = Player(leader: .alexander, isHuman: false)
        let unit = Unit(at: pt, type: UnitType.settler, owner: player)
        let viewModel = UnitBannerViewModel(selectedUnit: unit, commands: commands, in: game)
        
        UnitBannerView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
