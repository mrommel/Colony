//
//  TopBarView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.05.21.
//

import SwiftUI

public struct TopBarView: View {
    
    @ObservedObject
    public var viewModel: GameSceneViewModel
    
    public var body: some View {
        
        HStack(alignment: .top) {

            VStack(alignment: .trailing, spacing: 10) {

                Button("Gov") {
                    self.viewModel.delegate?.showChangeGovernmentDialog()
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}
