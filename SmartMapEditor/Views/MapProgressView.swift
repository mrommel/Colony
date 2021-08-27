//
//  MapProgressView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import SwiftUI
import SmartAILibrary
import SDWebImageSwiftUI

protocol MapProgressViewDelegate: NSObject {

    func generated(map: MapModel?)
}

struct MapProgressView: View {

    @ObservedObject
    var viewModel: MapProgressViewModel

    weak var delegate: MapProgressViewDelegate?

    var body: some View {

        VStack {

            AnimatedImage(name: "animated-map.gif")
                .frame(width: 64, height: 64, alignment: .center)
                .clipShape(Circle())
                .scaledToFit()

            Text("Generating Map")

            Text($viewModel.progress.wrappedValue)

            ActivityIndicator(isAnimating: $viewModel.generating, style: .spinning)

        }.padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .frame(width: 200, height: 250, alignment: .center)
    }

    func bind() {

        self.viewModel.mapCreated = { map in
            self.delegate?.generated(map: map)
        }
    }
}
