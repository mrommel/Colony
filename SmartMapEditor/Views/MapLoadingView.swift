//
//  MapLoadingView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 09.12.20.
//

import SwiftUI
import SmartAILibrary

protocol MapLoadingViewDelegate: NSObject {
    
    func loaded(map: MapModel?)
}

struct MapLoadingView: View {

    @ObservedObject
    var viewModel: MapLoadingViewModel
    
    weak var delegate: MapLoadingViewDelegate? = nil
    
    var body: some View {
        
        VStack {

            Text("Loading Map")

            ActivityIndicator(isAnimating: $viewModel.loading, style: .spinning)

        }.padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 2))
        .frame(width: 200, height: 120, alignment: .leading)
    }
    
    func bind() {
        
        self.viewModel.mapLoaded = { map in
            self.delegate?.loaded(map: map)
        }
    }
}
