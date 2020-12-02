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

    //@State var mapScrollContentViewModel = MapScrollContentViewModel()
    @State private var mapFocus: AbstractTile? = nil
    @State private var mapZoom: CGFloat = 1.0
    @State private var zoomOptions = ["0.5", "1.0","2.0" ]

    func selectedZoom(key: String) {
        
        let mapZoomValue = Double(key)
        self.mapZoom = CGFloat(mapZoomValue!)
    }

    var body: some View {
        HStack {
            VStack {
                MapScrollContentView(focus: $mapFocus, mapZoom: $mapZoom)

                HStack {

                    VStack {
                        Text("Location")
                        Text("\(self.mapFocus?.point.x ?? -1), \(self.mapFocus?.point.y ?? -1)")
                    }
                    
                    VStack {
                        Text("Terrain")
                        Text(self.mapFocus?.terrain().name() ?? "---")
                    }

                    VStack {
                        Text("Hills")
                        if self.mapFocus != nil {
                            if self.mapFocus!.hasHills() {
                                Text("true")
                            } else {
                                Text("false")
                            }
                        } else {
                            Text("---")
                        }
                    }

                    VStack {
                        Text("Feature")
                        Text(self.mapFocus?.feature().name() ?? "---")
                    }
                    
                    VStack {
                        Text("Resource")
                        Text(self.mapFocus?.resource(for: nil).name() ?? "---")
                    }
                    
                    Spacer()

                    VStack {
                        Text("Zoom")
                        PopUpButtonView(options: self.$zoomOptions, onSelect: self.selectedZoom).frame(width: 70, height: 20, alignment: .center)
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
