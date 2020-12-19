//
//  EditMetaDataView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 19.12.20.
//

import SwiftUI
import SmartAILibrary

protocol EditMetaDataViewDelegate: NSObject {
    
    func closed()
}

struct EditMetaDataView: View {
    
    @ObservedObject
    var viewModel: EditMetaDataViewModel
    
    weak var delegate: EditMetaDataViewDelegate? = nil
    
    var body: some View {
        
        VStack {

            Text("Map Meta Data").padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))

            Divider()
            
            TextField("Name", text: $viewModel.name).padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            
            TextField("Summary", text: $viewModel.summary).padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            
            Text("\(viewModel.sizeString)").padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            
            Divider()
            
            HStack {
                
                Spacer()
                
                Button(action: { viewModel.cancel() }) {
                    Text("Cancel")
                }
                
                Button(action: { viewModel.save() }) {
                    Text("Save")
                }
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

#if DEBUG
    struct ContentView_Previews: PreviewProvider {

        static var previews: some View {
            EditMetaDataView(viewModel: EditMetaDataViewModel(of: nil))
        }
    }
#endif
