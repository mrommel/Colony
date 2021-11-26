//
//  MapLoadingView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 09.12.20.
//

import SwiftUI
import SmartAILibrary
import SDWebImageSwiftUI

protocol MapLoadingViewDelegate: class {

    func loaded(map: MapModel?)
}

struct MapLoadingView: View {

    @ObservedObject
    var viewModel: MapLoadingViewModel

    weak var delegate: MapLoadingViewDelegate?

    var body: some View {

        VStack {

            AnimatedImage(name: "animated-map.gif").clipShape(Circle()).scaledToFit()

            Text("Loading Map")

            ActivityIndicator(isAnimating: $viewModel.loading, style: .spinning)

        }.padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 2))
        .frame(width: 200, height: 250, alignment: .center)
    }

    func bind() {

        self.viewModel.mapLoaded = { map in
            self.delegate?.loaded(map: map)
        }
    }
}
