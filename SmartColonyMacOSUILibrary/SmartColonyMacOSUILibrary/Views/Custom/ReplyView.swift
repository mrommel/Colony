//
//  ReplyView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.08.21.
//

import SwiftUI
import SmartAILibrary

struct ReplyView: View {
    
    @ObservedObject
    var viewModel: ReplyViewModel
    
    public init(viewModel: ReplyViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Button(self.viewModel.text) {
            self.viewModel.clicked()
        }.buttonStyle(GameButtonStyle(state: .text))
    }
}

#if DEBUG
struct ReplyView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = ReplyViewModel(reply: .introReplyPositive)

        ReplyView(viewModel: viewModel)
    }
}
#endif
