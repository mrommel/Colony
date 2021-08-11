//
//  HexagonGridView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.05.21.
//

import SwiftUI
import SmartAILibrary

struct HexagonGridView: View {
    
    @ObservedObject
    var viewModel: HexagonGridViewModel
    
    public init(viewModel: HexagonGridViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            ZStack {
                
                ForEach(self.viewModel.hexagonViewModels, id: \.self) { hexagonViewModel in
                    
                    HexagonView(viewModel: hexagonViewModel)
                        .offset(hexagonViewModel.offset())
                }
            }
            .offset(self.viewModel.focused)
            .scaleEffect(CGSize(width: 0.8, height: 0.8))
        }
        .frame(width: 300, height: 300, alignment: .center)
        .background(Color.black)
        .clipped()
    }
}

#if DEBUG
struct HexagonGridView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let demoGameModel = DemoGameModel()
        
        HexagonGridView(viewModel: HexagonGridViewModel(gameModel: demoGameModel))
    }
}
#endif
