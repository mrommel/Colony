//
//  UnitListDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.08.21.
//

import SwiftUI

struct UnitListDialogView: View {
    
    @ObservedObject
    var viewModel: UnitListDialogViewModel

    private var gridItemLayout = [GridItem(.fixed(250))]
    
    public init(viewModel: UnitListDialogViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            VStack(spacing: 10) {
                HStack {
                    
                    Spacer()
                    
                    Text("Units")
                        .font(.title2)
                        .bold()
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        self.viewModel.closeDialog()
                    }, label: {
                        Text("X")
                    })
                }
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    
                    LazyVGrid(columns: gridItemLayout, spacing: 10) {
                        
                        ForEach(self.viewModel.unitViewModels, id:\.self) { unitViewModel in

                            UnitView(viewModel: unitViewModel)
                                .padding(0)
                                .onTapGesture {
                                    unitViewModel.clicked()
                                }
                        }
                    }
                })
                .frame(width: 300, height: 325, alignment: .center)
                .border(Color.gray)
                
                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Okay")
                })
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 400, height: 450, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct UnitListDialogView_Previews: PreviewProvider {
    
    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        UnitListDialogView(viewModel: UnitListDialogViewModel())
    }
}
#endif
