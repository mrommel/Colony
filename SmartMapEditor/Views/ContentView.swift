//
//  ContentView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary


struct ContentView: View {

    @ObservedObject
    private var viewModel: ContentViewModel = ContentViewModel()

    var body: some View {
        HStack {
            VStack {
                MapScrollContentView(viewModel: viewModel)

                HStack {

                    VStack {
                        Text("Location")
                        Text("\($viewModel.focusedPoint.wrappedValue)")
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Terrain")
                        //Text(self.mapFocus?.terrain().name() ?? "---")
                        PopupButton(selectedValue: $viewModel.focusedTerrainName, items: TerrainType.all.map({ $0.name() }), onChange: {
                            viewModel.setTerrain(to: $0)
                        }).frame(width: 70, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Hills")
                        //Text("---")
                        PopupButton(selectedValue: $viewModel.focusedHillsValue, items: ["true", "false"], onChange: {
                            viewModel.setHills(to: $0)
                        }).frame(width: 70, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Feature")
                        //Text(self.mapFocus?.feature().name() ?? "---")
                        PopupButton(selectedValue: $viewModel.focusedFeatureName, items: ["---"] + FeatureType.all.map({ $0.name() }), onChange: {
                            viewModel.setFeature(to: $0)
                        }).frame(width: 70, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Resource")
                        //Text(self.mapFocus?.resource(for: nil).name() ?? "---")
                        PopupButton(selectedValue: $viewModel.focusedResourceName, items: ["---"] + ResourceType.all.map({ $0.name() }), onChange: {
                            viewModel.setResource(to: $0)
                        }).frame(width: 70, height: 16, alignment: .center)
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
}

#if DEBUG
    struct ContentView_Previews: PreviewProvider {

        static var previews: some View {
            ContentView()
        }
    }
#endif
