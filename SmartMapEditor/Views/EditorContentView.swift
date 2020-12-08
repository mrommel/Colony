//
//  EditorContentView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary

struct EditorContentView: View {

    @ObservedObject
    private var viewModel: EditorContentViewModel = EditorContentViewModel()

    var body: some View {
        HStack {
            VStack {
                MapScrollContentView(viewModel: viewModel).frame(width: 1000, height: 500, alignment: .center)

                HStack {

                    VStack {
                        Text("Location")
                        Text("\($viewModel.focusedPoint.wrappedValue)").frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Terrain")
                        //Text(self.mapFocus?.terrain().name() ?? "---")
                        PopupButton(selectedValue: $viewModel.focusedTerrainName, items: TerrainType.all.map({ $0.name() }), onChange: {
                            viewModel.setTerrain(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Hills")
                        //Text("---")
                        PopupButton(selectedValue: $viewModel.focusedHillsValue, items: ["yes", "no"], onChange: {
                            viewModel.setHills(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))
                    
                    VStack {
                        Text("River")
                        PopupButton(selectedValue: $viewModel.focusedRiverValue, items: ["---", "n", "n-ne", "n-se", "ne-se", "n-ne-se", "se"], onChange: {
                            viewModel.setRiver(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }

                    VStack {
                        Text("Feature")
                        //Text(self.mapFocus?.feature().name() ?? "---")
                        PopupButton(selectedValue: $viewModel.focusedFeatureName, items: ["---"] + FeatureType.all.map({ $0.name() }), onChange: {
                            viewModel.setFeature(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Resource")
                        //Text(self.mapFocus?.resource(for: nil).name() ?? "---")
                        PopupButton(selectedValue: $viewModel.focusedResourceName, items: ["---"] + ResourceType.all.map({ $0.name() }), onChange: {
                            viewModel.setResource(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    Spacer()

                    VStack {
                        Text("Zoom")
                        ZoomDropdownView(viewModel: viewModel).frame(width: 70, height: 20, alignment: .center)
                    }
                }
            }
        }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func set(map: MapModel?) {
        
        self.viewModel.map = map
    }
}

#if DEBUG
    struct ContentView_Previews: PreviewProvider {

        static var previews: some View {
            EditorContentView()
        }
    }
#endif
