//
//  CivicView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary

struct CivicView: View {
    
    @ObservedObject
    var viewModel: CivicViewModel
    
    private var gridItemLayout = [
        GridItem(.fixed(12), spacing: 2.0),
        GridItem(.fixed(12), spacing: 2.0),
        GridItem(.fixed(12), spacing: 2.0),
        GridItem(.fixed(12), spacing: 2.0),
        GridItem(.fixed(12), spacing: 2.0),
        GridItem(.fixed(12), spacing: 2.0),
        GridItem(.fixed(12), spacing: 2.0)
    ]
    
    public init(viewModel: CivicViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Text(self.viewModel.title())
    }
}

#if DEBUG
struct CivicView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)

        CivicView(viewModel: CivicViewModel(civicType: .capitalism, state: .possible, boosted: true, turns: 27))
        
        CivicView(viewModel: CivicViewModel(civicType: .guilds, state: .selected, boosted: false, turns: -1))
        
        CivicView(viewModel: CivicViewModel(civicType: .feudalism, state: .researched, boosted: true, turns: -1))
    }
}
#endif
