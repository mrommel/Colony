//
//  TechView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary

struct TechView: View {
    
    @ObservedObject
    var viewModel: TechViewModel
    
    public var body: some View {
        Text(self.viewModel.title)
    }
}

#if DEBUG
struct TechView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)

        TechView(viewModel: TechViewModel(techType: .archery, progress: 0.9))
        
        TechView(viewModel: TechViewModel(techType: .chemistry, progress: 1.0))
    }
}
#endif
