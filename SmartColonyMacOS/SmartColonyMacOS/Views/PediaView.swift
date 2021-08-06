//
//  PediaView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 06.08.21.
//

import SwiftUI
import SmartMacOSUILibrary

struct PediaView: View {
    
    @ObservedObject
    var viewModel: PediaViewModel
    
    var body: some View {
        
        VStack {
            Spacer(minLength: 1)
            
            Text("Pedia")
                .font(.largeTitle)
            
            Divider()
            
            Text("Pedia text")
            
            HStack {
                Button("Cancel") {
                    self.viewModel.cancel()
                }
                .buttonStyle(GameButtonStyle())
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            
            Spacer(minLength: 1)
        }
    }
}

struct PediaView_Previews: PreviewProvider {

    static var previews: some View {
        let viewModel = PediaViewModel()
        
        PediaView(viewModel: viewModel)
    }
}
