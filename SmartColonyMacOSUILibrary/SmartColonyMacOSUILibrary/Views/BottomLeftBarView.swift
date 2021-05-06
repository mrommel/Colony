//
//  BottomMenuView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI

public struct BottomLeftBarView: View {
    
    @ObservedObject
    public var viewModel: GameSceneViewModel
    
    public var body: some View {
        HStack(alignment: .bottom) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                Spacer(minLength: 10)
                
                ZStack(alignment: .bottomLeading) {
                    
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
                    
                    Image(nsImage: self.viewModel.buttonImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 83, height: 83)
                        .offset(x: 6, y: -7)
                        .onTapGesture {
                            self.viewModel.doTurn()
                        }
                    
                    Image("unit_canvas")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 111, height: 112)
                        .allowsHitTesting(false)
                    
                    Image(nsImage: self.viewModel.typeImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .offset(x: 5, y: -5)
                }
            }
            
            Spacer(minLength: 10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct BottomLeftBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let viewModel = GameSceneViewModel()
        BottomLeftBarView(viewModel: viewModel)
    }
}
