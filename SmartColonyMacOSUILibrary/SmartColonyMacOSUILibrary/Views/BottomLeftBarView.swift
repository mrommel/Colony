//
//  BottomMenuView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI

public struct BottomLeftBarView: View {
    
    /*private let viewModel: MapViewModel
    
    public init(viewModel: MapViewModel) {
        
        self.viewModel = viewModel
    }*/
    
    public var body: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 10) {
                
                Spacer(minLength: 10)
                
                ZStack(alignment: .leading) {
                    
                    Image("unit_commands_body")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 112)
                        .onTapGesture {
                            print("unit_commands_body tapped!")
                        }
                    
                    Image("black_circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .padding(.top, 10)
                        .padding(.leading, 3)
                    
                    Image("button_generic")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 83, height: 83)
                        .padding(.top, 15)
                        .padding(.leading, 6)
                        .onTapGesture {
                            //print("button tapped!")
                            //self.viewModel.doTurn()
                        }
                    
                    Image("unit_canvas")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 111, height: 112)
                        .allowsHitTesting(false)
                }
            }
            
            Spacer(minLength: 10)
        
            /*VStack(alignment: .leading, spacing: 10) {
                Text("top leading")
                Spacer()
                Text("leading")
                Spacer()
                Text("bottom leading")
                Button("Turn") {
                    print("turn")
                }
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: 10) {
                Text("top center")
                Spacer()
                Text("center")
                Spacer()
                Text("bottom center")
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                Text("top trailing")
                Spacer()
                Text("trailing")
                Spacer()
                Text("bottom trailing")
            }*/
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}
/*
struct BottomLeftBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let viewModel = MapViewModel()
        BottomLeftBarView(viewModel: viewModel)
    }
}*/
