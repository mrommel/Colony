//
//  EditorContentView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary

struct PlainGroupBoxStyle: GroupBoxStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding(8)
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct EditorContentView: View {

    @ObservedObject
    private var viewModel: EditorContentViewModel = EditorContentViewModel()

    var body: some View {
        HStack {
            VStack {
                
                HStack {
                    MapScrollContentView(viewModel: viewModel).frame(width: 1000, height: 500, alignment: .center)

                    VStack {
                        Label("Brush", systemImage: "paintbrush.fill")
                        
                        Divider()
                                     
                        GroupBox(label: Label("Type", systemImage: "highlighter")
                                .foregroundColor(.white)) {
                            PopupButton(selectedValue: $viewModel.brushTypeName, items: MapBrushType.all.map({ $0.name() }), onChange: {
                                viewModel.setBrushType(to: $0)
                            }).frame(width: 90, height: 16, alignment: .center)
                        }.groupBoxStyle(PlainGroupBoxStyle())

                        Divider()
                        
                        GroupBox(label: Label("Size", systemImage: "hexagon")
                                .foregroundColor(.white)) {
                            PopupButton(selectedValue: $viewModel.brushSizeName, items: MapBrushSize.all.map({ $0.name() }), onChange: {
                                viewModel.setBrushSize(to: $0)
                            }).frame(width: 90, height: 16, alignment: .center)
                        }.groupBoxStyle(PlainGroupBoxStyle())

                        Divider()
                        
                        if self.viewModel.brush.type.name() == "Terrain" {
                            GroupBox(label: Label("Terrain", systemImage: "pencil")
                                    .foregroundColor(.white)) {
                                PopupButton(selectedValue: $viewModel.brushTerrainName, items: TerrainType.all.map({ $0.name() }), onChange: {
                                    viewModel.setBrushTerrain(to: $0)
                                }).frame(width: 90, height: 16, alignment: .center)
                            }.groupBoxStyle(PlainGroupBoxStyle())
                        } else if self.viewModel.brush.type.name() == "Feature" {
                            GroupBox(label: Label("Feature", systemImage: "pencil")
                                    .foregroundColor(.white)) {
                                PopupButton(selectedValue: $viewModel.brushFeatureName, items: ["None"] + FeatureType.all.map({ $0.name() }), onChange: {
                                    viewModel.setBrushFeature(to: $0)
                                }).frame(width: 90, height: 16, alignment: .center)
                            }.groupBoxStyle(PlainGroupBoxStyle())
                        } else {
                            GroupBox(label: Label("Resource", systemImage: "pencil")
                                    .foregroundColor(.white)) {
                                PopupButton(selectedValue: $viewModel.brushResourceName, items: ["None"] + ResourceType.all.map({ $0.name() }), onChange: {
                                    viewModel.setBrushResource(to: $0)
                                }).frame(width: 90, height: 16, alignment: .center)
                            }.groupBoxStyle(PlainGroupBoxStyle())
                        }
                        
                    }.frame(width: 120, height: 500, alignment: .leading)
                }
                
                HStack {

                    VStack {
                        Text("Location")
                        
                        Text("\($viewModel.focusedPoint.wrappedValue)").frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Terrain")

                        PopupButton(selectedValue: $viewModel.focusedTerrainName, items: TerrainType.all.map({ $0.name() }), onChange: {
                            viewModel.setTerrain(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Hills")

                        PopupButton(selectedValue: $viewModel.focusedHillsValue, items: ["yes", "no"], onChange: {
                            viewModel.setHills(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))
                    
                    VStack {
                        Text("River")
                        
                        PopupButton(selectedValue: $viewModel.focusedRiverValue, items: ["---", "n", "n-ne", "n-se", "ne-se", "n-ne-se", "se"], onChange: {
                            viewModel.setRiver(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Feature")
                        
                        PopupButton(selectedValue: $viewModel.focusedFeatureName, items: ["---"] + FeatureType.all.map({ $0.name() }), onChange: {
                            viewModel.setFeature(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Resource")
                        
                        PopupButton(selectedValue: $viewModel.focusedResourceName, items: ["---"] + ResourceType.all.map({ $0.name() }), onChange: {
                            viewModel.setResource(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))
                    
                    Spacer(minLength: 50)
                    
                    VStack {
                        Text("Start Locations")
                        
                        PopupButton(selectedValue: $viewModel.focusedStartLocationName, items: viewModel.startLocationNames(), onChange: {
                            viewModel.setStartLocation(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    Spacer()

                    VStack {
                        Text("Zoom")
                        
                        PopupButton(selectedValue: $viewModel.selectedZoomName, items: ["0.5", "1.0", "2.0"], onChange: {
                            viewModel.setZoom(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)

                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 6, trailing: 6))
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
    struct EditorContentView_Previews: PreviewProvider {

        static var previews: some View {
            EditorContentView()
        }
    }
#endif
