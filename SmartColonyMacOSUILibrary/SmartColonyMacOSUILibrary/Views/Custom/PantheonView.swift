//
//  PantheonView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.05.21.
//

import SwiftUI

struct PantheonView: View {
    
    @ObservedObject
    var viewModel: PantheonViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Pantheon Belief")
        
            Text(self.viewModel.pantheonName)
                .padding(.all, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                )
        }
        .padding(.all, 8)
        .frame(width: 250, height: 70, alignment: .leading)
        .background(Color.red.opacity(0.4))
    }
}

#if DEBUG
struct PantheonView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)

        PantheonView(viewModel: PantheonViewModel(pantheonType: .godOfWar))
    }
}
#endif
