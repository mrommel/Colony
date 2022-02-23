//
//  EditorContentView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary
import SmartColonyMacOSUILibrary

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

                                PopupButton(selectedValue: $viewModel.brushTerrainName,
                                            items: viewModel.terrainOptionNames(),
                                            onChange: {
                                    viewModel.setBrushTerrain(to: $0)
                                }).frame(width: 90, height: 16, alignment: .center)
                            }.groupBoxStyle(PlainGroupBoxStyle())
                        } else if self.viewModel.brush.type.name() == "Feature" {

                            GroupBox(label: Label("Features", systemImage: "pencil")
                                    .foregroundColor(.white)) {

                                PopupButton(selectedValue: $viewModel.brushFeatureName,
                                            items: viewModel.featureOptionNames(),
                                            onChange: {
                                    viewModel.setBrushFeature(to: $0)
                                }).frame(width: 90, height: 16, alignment: .center)
                            }.groupBoxStyle(PlainGroupBoxStyle())
                        } else {

                            GroupBox(label: Label("Resources", systemImage: "pencil")
                                    .foregroundColor(.white)) {

                                Button(action: {
                                    viewModel.clearResources()
                                }, label: {
                                    Label("Clear", systemImage: "trash")
                                })

                                Button(action: {
                                    viewModel.scatterResources()
                                }, label: {
                                    Label("Scatter", systemImage: "lasso.sparkles")
                                })

                                PopupButton(selectedValue: $viewModel.brushResourceName,
                                            items: viewModel.resourceOptionNames(),
                                            onChange: {
                                    viewModel.setBrushResource(to: $0)
                                }).frame(width: 90, height: 16, alignment: .center)
                            }.groupBoxStyle(PlainGroupBoxStyle())
                        }

                        Spacer(minLength: 20)

                        GroupBox(label: Label("Simulation", systemImage: "network")
                                    .foregroundColor(.white)) {

                            Button(action: {
                                viewModel.initTribes()
                            }, label: {
                                Label("Start", systemImage: "wand.and.stars")
                            })

                            Button(action: {
                                viewModel.iterateTribes()
                            }, label: {
                                Label("Iterate", systemImage: "play")
                            })
                        }.groupBoxStyle(PlainGroupBoxStyle())

                    }.frame(width: 120, height: 500, alignment: .leading)
                }

                HStack {

                    VStack {
                        Text("Location")

                        Text("\($viewModel.focusedPoint.wrappedValue)").frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Terrain")

                        PopupButton(selectedValue: $viewModel.focusedTerrainName,
                                    items: viewModel.terrainOptionNames(),
                                    onChange: {
                            viewModel.setTerrain(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Hills")

                        PopupButton(selectedValue: $viewModel.focusedHillsValue,
                                    items: viewModel.hillsOptionNames(),
                                    onChange: {
                            viewModel.setHills(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("River")

                        PopupButton(selectedValue: $viewModel.focusedRiverValue,
                                    items: viewModel.riverOptionNames(),
                                    onChange: {
                            viewModel.setRiver(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Feature")

                        PopupButton(selectedValue: $viewModel.focusedFeatureName,
                                    items: viewModel.featureOptionNames(),
                                    onChange: {
                            viewModel.setFeature(to: $0)
                        }).frame(width: 80, height: 16, alignment: .center)
                    }.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 12))

                    VStack {
                        Text("Resource")

                        PopupButton(selectedValue: $viewModel.focusedResourceName,
                                    items: viewModel.resourceOptionNames(),
                                    onChange: {
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

                        PopupButton(selectedValue: $viewModel.selectedZoomName,
                                    items: viewModel.zoomOptionNames(),
                                    onChange: {
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

    func setShowStartLocations(to value: Bool) {

        self.viewModel.setShowStartLocations(to: value)
    }

    func setShowInhabitants(to value: Bool) {

        self.viewModel.setShowInhabitants(to: value)
    }

    func setShowSupportedPeople(to value: Bool) {

        self.viewModel.setShowSupportedPeople(to: value)
    }
}

#if DEBUG
    struct EditorContentView_Previews: PreviewProvider {

        static var previews: some View {
            EditorContentView()
        }
    }
#endif
