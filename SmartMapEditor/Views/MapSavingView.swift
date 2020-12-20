//
//  MapSavingView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 10.12.20.
//

import SwiftUI
import SDWebImageSwiftUI

protocol MapSavingViewDelegate: NSObject {
    
    func saved(with success: Bool)
}

struct MapSavingView: View {

    @ObservedObject
    var viewModel: MapSavingViewModel
    
    weak var delegate: MapSavingViewDelegate? = nil
    
    var body: some View {
        
        VStack {

            AnimatedImage(name: "animated-map.gif").clipShape(Circle()).scaledToFit()
            
            Text("Saving Map")

            ActivityIndicator(isAnimating: $viewModel.saving, style: .spinning)

        }.padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 2))
        .frame(width: 200, height: 250, alignment: .center)
    }
    
    func bind() {
        
        self.viewModel.mapSaved = { value in
            self.delegate?.saved(with: value)
        }
    }
}
