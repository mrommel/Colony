//
//  Civ5MapImportingView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 16.12.20.
//

import SwiftUI
import SmartAILibrary
import SDWebImageSwiftUI

protocol Civ5MapImportingViewDelegate: NSObject {
    
    func imported(map: MapModel?)
}

struct Civ5MapImportingView: View {

    @ObservedObject
    var viewModel: Civ5MapImportingViewModel
    
    weak var delegate: Civ5MapImportingViewDelegate?
    
    var body: some View {
        
        VStack {
            
            AnimatedImage(name: "animated-map.gif").clipShape(Circle()).scaledToFit()

            Text("Importing Map")

            ActivityIndicator(isAnimating: $viewModel.loading, style: .spinning)

        }.padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 2))
        .frame(width: 200, height: 250, alignment: .center)
    }
    
    func bind() {
        
        self.viewModel.mapImported = { map in
            self.delegate?.imported(map: map)
        }
    }
}
