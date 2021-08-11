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
                    .fill(Color(self.viewModel.tileColor))
                    .scaleEffect(CGSize(width: 1.0, height: 0.75))
                
                //if self.viewModel.showMountains() {
                    Image(nsImage: self.viewModel.mountainsImage)
                        .resizable()
                        .frame(width: h, height: h, alignment: .center)
                //}
                
                //if self.viewModel.showHills() {
                    Image(nsImage: self.viewModel.hillsImage)
                        .resizable()
                        .frame(width: h, height: h, alignment: .center)
                //}
                
                //if self.viewModel.showForest() {
                    Image(nsImage: self.viewModel.forestImage)
                        .resizable()
                        .frame(width: h, height: h, alignment: .center)
                //}
                
                //if self.viewModel.showCity() {
                    Image(nsImage: self.viewModel.cityImage)
                        .resizable()
                        .frame(width: h, height: h, alignment: .center)
                //}
                
                //if self.viewModel.showCitizenIcons {
                    Image(nsImage: self.viewModel.actionImage)
                        .resizable()
                        .frame(width: h, height: h, alignment: .center)
                //}
                
                /*Text("\(self.viewModel.tile.point.x),\(self.viewModel.tile.point.y)")*/
            }
            .frame(width: w, height: h, alignment: .center)
            .onTapGesture {
                self.viewModel.clicked()
            }
        }
        .scaleEffect(CGSize(width: 0.5, height: 0.5))
    }
}

#if DEBUG
struct HexagonView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        HexagonView(viewModel: HexagonViewModel(at: HexPoint(x: 1, y: 1), tileColor: NSColor.lightGreen, mountains: nil, hills: nil, forest: nil, city: nil, tileAction: nil, showCitizenIcons: true))
        
        //HexagonView(viewModel: HexagonViewModel(tile: .grass))
        
        //HexagonView(viewModel: HexagonViewModel(tile: .ocean))
    }
}
#endif
