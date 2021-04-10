//
//  MapOverviewView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct MapOverviewModifier: ViewModifier {

  func body(content: Content) -> some View {
    
    return content
        .frame(width: 156, height: 94, alignment: .top)
  }
}

extension Image {
    
  func mapOverview() -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fill)
      .modifier(MapOverviewModifier())
  }
}

public struct MapOverviewView: View {
    
    @ObservedObject
    var viewModel: MapOverviewViewModel
    
    let bundle = Bundle.init(for: Textures.self)
    
    public var body: some View {
        
        ZStack {
            
            Image("map_overview_canvas")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 112, alignment: .bottomTrailing) // 400 × 224
            
            self.viewModel.image
                .mapOverview()
                //.padding(.trailing, 11)
                //.padding(.bottom, 1)
        }
        .frame(width: 200, height: 112, alignment: .bottomTrailing)
        .background(Color.red.opacity(0.5))
    }
}
