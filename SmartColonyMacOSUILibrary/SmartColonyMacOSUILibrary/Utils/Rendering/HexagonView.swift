//
//  HexagonView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.05.21.
//

import SwiftUI
import SmartAILibrary

struct HexagonView: View {
    
    @ObservedObject
    var viewModel: HexagonViewModel
    
    public init(viewModel: HexagonViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        let size = 50.0
        let w = CGFloat(2.0 * size)
        let h = CGFloat(sqrt(3.0) * size)
        
        Group {
            ZStack {
                
                RegularPolygon(sides: 6, inset: -6.0)
                    .fill(Color(self.viewModel.color()))
                    .onTapGesture {
                        self.viewModel.clicked()
                    }
                
                if self.viewModel.showMountains() {
                    Image(nsImage: self.viewModel.mountainsImage())
                        .resizable()
                        .frame(width: h, height: h, alignment: .center)
                }
                
                if self.viewModel.showHills() {
                    Image(nsImage: self.viewModel.hillsImage())
                        .resizable()
                        .frame(width: h, height: h, alignment: .center)
                }
                
                if self.viewModel.showForest() {
                    Image(nsImage: self.viewModel.forestImage())
                        .resizable()
                        .frame(width: h, height: h, alignment: .center)
                }
                
                /*Text("\(self.viewModel.tile.point.x),\(self.viewModel.tile.point.y)")*/
            }
            .frame(width: w, height: h, alignment: .center)
        }
        .scaleEffect(CGSize(width: 1.0, height: 0.75))
        .scaleEffect(CGSize(width: 0.5, height: 0.5))
    }
}

#if DEBUG
struct HexagonView_Previews: PreviewProvider {
    
    static var previews: some View {
        let tile = Tile(point: HexPoint(x: 1, y: 1), terrain: .grass, hills: false, feature: .forest)
        
        HexagonView(viewModel: HexagonViewModel(tile: tile))
        
        //HexagonView(viewModel: HexagonViewModel(tile: .grass))
        
        //HexagonView(viewModel: HexagonViewModel(tile: .ocean))
    }
}
#endif
