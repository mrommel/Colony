//
//  BottomRightBarView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 07.04.21.
//

import SwiftUI
import SmartMacOSUILibrary

struct BottomRightBarView: View {
    
    private let viewModel: GameViewModel
    
    public init(viewModel: GameViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {

                Spacer()
                MapOverviewView()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct BottomRightBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let viewModel = GameViewModel()
        BottomRightBarView(viewModel: viewModel)
    }
}
