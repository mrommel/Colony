//
//  GameCommands.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.04.21.
//

import SwiftUI

struct GameCommands: Commands {
    
    @ObservedObject
    var commandModel: GameCommandsModel
    
    @Binding
    var mapMenuDisabled: Bool
    
    @Binding
    var toggleDisplayResourceMarkers: Bool
    
    @Binding
    var toggleDisplayYields: Bool
    
    @Binding
    var toggleDisplayWater: Bool
    
    // debug
    
    @Binding
    var toggleDisplayHexCoordinates: Bool
    
    @Binding
    var toggleDisplayCompleteMap: Bool
    
    // MARK: view
    
    @CommandsBuilder var body: some Commands {
        CommandMenu("Game") {

            Button(action: {
                self.commandModel.centerCapital()
            }, label: {
                Image(systemName: "star.circle")
                Text("Center to capital")
            })
            
            Button(action: {
                self.commandModel.centerOnCursor()
            }, label: {
                Image(systemName: "paperplane.circle")
                Text("Center on cursor")
            }).keyboardShortcut("c")
            
            Divider()
            
            Button(action: {
                self.commandModel.zoomIn()
            }, label: {
                Image(systemName: "plus.magnifyingglass")
                Text("Zoom In")
            }).keyboardShortcut("+")
            
            Button(action: {
                self.commandModel.zoomOut()
            }, label: {
                Image(systemName: "minus.magnifyingglass")
                Text("Zoom Out")
            }).keyboardShortcut("-")
            
            Button(action: {
                self.commandModel.zoomReset()
            }, label: {
                Image(systemName: "1.magnifyingglass")
                Text("Zoom 1:1")
            }).keyboardShortcut("r")
            
            Divider()
        }
        
        CommandMenu("Map") {
            
            Toggle(isOn: self.$toggleDisplayResourceMarkers) {
                Text("Show Resource Markers")
            }
            .disabled(self.mapMenuDisabled)
            .toggleStyle(CheckboxSquareToggleStyle())
            
            Toggle(isOn: self.$toggleDisplayYields) {
                Text("Show Yields")
            }
            .disabled(self.mapMenuDisabled)
            .toggleStyle(CheckboxSquareToggleStyle())
            
            Toggle(isOn: self.$toggleDisplayWater) {
                Text("Show Fresh Water")
            }
            .disabled(self.mapMenuDisabled)
            .toggleStyle(CheckboxSquareToggleStyle())
            
            Divider()
            
            Toggle(isOn: self.$toggleDisplayHexCoordinates) {
                Text("Show Hex Coordinates")
            }
            .disabled(self.mapMenuDisabled)
            .toggleStyle(CheckboxSquareToggleStyle())
            
            Toggle(isOn: self.$toggleDisplayCompleteMap) {
                Text("Show complete map")
            }
            .disabled(self.mapMenuDisabled)
            .toggleStyle(CheckboxSquareToggleStyle())
        }
    }
}
