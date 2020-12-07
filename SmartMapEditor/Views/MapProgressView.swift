//
//  MapProgressView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import SwiftUI
import SmartAILibrary

protocol MapProgressViewDelegate: NSObject {
    
    func generated(map: MapModel?)
}

struct MapProgressView: View {

    @ObservedObject
    var viewModel: MapProgressViewModel
    
    weak var delegate: MapProgressViewDelegate? = nil
    
    var body: some View {
        
        VStack {

            Text("Generating Map")
            
            Text($viewModel.progress.wrappedValue)

            ActivityIndicator(isAnimating: $viewModel.generating, style: .spinning)

        }.padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 2))
        .frame(width: 200, height: 120, alignment: .leading)
    }
    
    func bind() {
        
        self.viewModel.mapCreated = { map in
            self.delegate?.generated(map: map)
        }
    }
}
