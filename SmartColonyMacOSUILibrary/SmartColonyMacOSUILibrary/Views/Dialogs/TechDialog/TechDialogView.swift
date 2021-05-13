//
//  TechDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI

struct TechDialogView: View {
    
    @ObservedObject
    var viewModel: TechDialogViewModel
    
    public init(viewModel: TechDialogViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            VStack(spacing: 10) {
                Text("Select Tech")
                    .font(.title2)
                    .bold()
                    .padding()
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    
                    Text("techs")
                    /*LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        
                        ForEach(self.viewModel.governmentSectionViewModels, id:\.self) { sectionViewModel in
                    
                            Section(header: Text(sectionViewModel.title()).font(.title)) {
                                
                                ForEach(sectionViewModel.governmentCardViewModels, id:\.self) { governmentCardViewModel in

                                    GovernmentCardView(viewModel: governmentCardViewModel)
                                        .background(Color.white.opacity(0.1))
                                }
                            }
                        }
                    }*/
                })
                
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
        .frame(width: 700, height: 450, alignment: .top)
        .background(
            Image("grid9-dialog")
                .resizable(capInsets: EdgeInsets(all: 45)
            )
        )
    }
}

#if DEBUG
struct TechDialogView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        TechDialogView(viewModel: TechDialogViewModel(game: game))
            .environment(\.gameEnvironment, environment)
    }
}
#endif
