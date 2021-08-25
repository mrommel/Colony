//
//  NewMapContentView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import SwiftUI
import SmartAILibrary

protocol NewMapContentViewDelegate: NSObject {

    func clickedGenerate(mapType: MapType, mapSize: MapSize)
}

struct NewMapContentView: View {
    
    @ObservedObject
    private var viewModel: NewMapContentViewModel = NewMapContentViewModel()
    
    weak var delegate: NewMapContentViewDelegate?
    
    var body: some View {
        VStack {
            
            Text("Generate Map with")
            
            HStack {
                Text("Type").padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                PopupButton(selectedValue: $viewModel.type,
                            items: MapType.all.map({ $0.name() }),
                            onChange: {
                                viewModel.setType(to: $0)
                            }
                )
                .frame(width: 70, height: 16, alignment: .center)
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            }
            
            HStack {
                Text("Size").padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                PopupButton(selectedValue: $viewModel.size,
                            items: MapSize.all.map({ $0.name() }),
                            onChange: {
                                viewModel.setSize(to: $0)
                            }
                )
                .frame(width: 70, height: 16, alignment: .center)
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            }

            Spacer()
            
            Button("Generate") {
                if let mapType: MapType = MapType.from(name: viewModel.type),
                   let mapSize: MapSize = MapSize.from(name: viewModel.size) {
                
                    self.delegate?.clickedGenerate(mapType: mapType, mapSize: mapSize)
                    // print("generate: \(viewModel.type) and \(viewModel.size)")
                }
            }
            
        }
        .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 2))
        .frame(width: 200, height: 120, alignment: .leading)
    }
}
