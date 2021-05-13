//
//  CivicDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI

struct CivicDialogView: View {
    
    @ObservedObject
    var viewModel: CivicDialogViewModel
    
    public init(viewModel: CivicDialogViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("civic")
    }
}
