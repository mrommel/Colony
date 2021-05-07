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
    
    @State
    var showCommandsBody: Bool = false
    
    public var body: some View {
        HStack(alignment: .bottom) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                Spacer(minLength: 10)
                
                ZStack(alignment: .bottomLeading) {
                    
                    ZStack(alignment: .bottomLeading) {
                        
                        Image("unit_commands_body")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 112)
                            .offset(x: 0, y: 0)
                        
                        Text(self.viewModel.unitName())
                            .offset(x: 70, y: -80)
                        
                        Image("black_circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .offset(x: 70, y: -30)
                    }
                    .frame(width: 200, height: 112)
                    .offset(x: self.showCommandsBody ? 60 : -20, y: 0)
                    .onReceive(self.viewModel.$showCommands, perform: { value in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.showCommandsBody = value
                        }
                    })
                    
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
                    
                    ZStack(alignment: .bottomLeading) {
                        
                        Image(nsImage: self.viewModel.typeBackgroundImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    
                        Image(nsImage: self.viewModel.typeImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    }
                    .frame(width: 16, height: 16)
                    .offset(x: 5, y: -5)
                    
                    Image("unit_canvas")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 111, height: 112)
                        .allowsHitTesting(false)
                }
            }
            
            Spacer(minLength: 10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

/*
struct BottomLeftBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let viewModel = GameSceneViewModel()
        BottomLeftBarView(viewModel: viewModel)
    }
}
*/
