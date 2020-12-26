//
//  DebugHeightMapView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 23.12.20.
//

import SwiftUI

struct DebugHeightMapView: View {

    @ObservedObject
    var viewModel: DebugHeightMapViewModel

    weak var delegate: EditMetaDataViewDelegate? = nil
    
    let octaves = ["1", "2", "4", "6", "8", "10", "12", "16", "32"]

    var body: some View {

        VStack {

            Text("Map Meta Data").padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))

            Divider()

            Image(nsImage: self.viewModel.image).frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Picker(selection: $viewModel.selectedOctavesIndex/*.onChange(viewModel.octavesChanged)*/, label: Text("Octaves")) {
                ForEach(0 ..< self.octaves.count) {
                    Text(self.octaves[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())

            HStack {

                Spacer()
                
                Button(action: { viewModel.update() }) {
                    Text("Update")
                }

                Button(action: { viewModel.cancel() }) {
                    Text("Cancel")
                }

                /*Button(action: { viewModel.save() }) {
                    Text("Save")
                }*/
            }.padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))

        }.padding()
        //.frame(width: 300, height: 350, alignment: .center)
    }

    func bind() {

        self.viewModel.closed = {
            self.delegate?.closed()
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
