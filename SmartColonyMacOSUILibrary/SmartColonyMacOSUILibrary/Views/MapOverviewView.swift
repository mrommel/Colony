//
//  MapOverviewView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

extension Image {
    
    func mapOverview() -> some View {
        self
            .resizable()
            .frame(width: 156, height: 94)
    }
}

public struct MapOverviewView: View {
    
    @ObservedObject
    var viewModel: MapOverviewViewModel
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    let bundle = Bundle.init(for: Textures.self)
    
    public var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            Image("map_overview_canvas")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 112, alignment: .bottomTrailing) // 400 × 224
            
            self.viewModel.image
                .mapOverview()
                .offset(x: -8.0, y: -2.0)

            /*Path { path in
                path.move(to: CGPoint(x: 50, y: 50))
                path.addLine(to: CGPoint(x: 150, y: 50))
                path.addLine(to: CGPoint(x: 150, y: 100))
                path.addLine(to: CGPoint(x: 50, y: 100))
            }
            .stroke(Color.red, lineWidth: 2)*/
        }
        .frame(width: 200, height: 112)
        .onReceive(gameEnvironment.visibleRect) { rect in
            
        }
    }
}

/*struct MapOverviewView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let viewModel = MapOverviewViewModel(with: DemoGameModel())
        MapOverviewView(viewModel: viewModel, visibleRect: <#Binding<CGRect>#>)
    }
}*/
