//
//  PediaView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 06.08.21.
//

import SwiftUI
import SmartMacOSUILibrary

struct PediaView: View {

    @ObservedObject
    var viewModel: PediaViewModel

    var body: some View {

        VStack {
            Spacer(minLength: 1)

            Text("Pedia")
                .font(.largeTitle)

            Divider()

            //Text("Pedia text")
            HStack(spacing: 0) {

                Spacer(minLength: 1)

                self.master

                Divider()

                self.detail

                Spacer(minLength: 1)
            }

            Divider()

            HStack {
                Button("Cancel") {
                    self.viewModel.cancel()
                }
                .buttonStyle(GameButtonStyle())
                .padding(.top, 20)
                .padding(.trailing, 20)
            }

            Spacer(minLength: 1)
        }
    }

    func buttonState(for category: PediaCategory) -> GameButtonState {

        return category == self.viewModel.selectedPediaCategory ? .highlighted : .normal
    }

    var master: some View {

        ScrollView(.vertical, showsIndicators: true, content: {

            VStack {
                ForEach(self.viewModel.pediaCategoryViewModels, id: \.self) { pediaCategoryViewModel in

                    Button(pediaCategoryViewModel.title()) {
                        self.viewModel.selectedPediaCategory = pediaCategoryViewModel.category
                    }
                    .buttonStyle(GameButtonStyle(state: self.buttonState(for: pediaCategoryViewModel.category)))
                }
            }
        })
        .frame(width: 250)
        .frame(maxHeight: .infinity)
        .background(Color.clear)
    }

    var detail: some View {

        HStack(alignment: .top) {

            ScrollView(.vertical, showsIndicators: true, content: {

                VStack(alignment: .leading, spacing: 10) {

                    Text(self.viewModel.selectedPediaCategory.title())
                        .font(.title)

                    ForEach(self.viewModel.pediaDetailViewModels, id: \.self) { pediaDetailViewModel in

                        GroupBox(label: Text(pediaDetailViewModel.title)
                                .font(.headline)
                                .padding(.top, 10)) {

                            HStack(alignment: .top) {

                                Image(nsImage: pediaDetailViewModel.image())
                                    .resizable()
                                    .frame(width: 32, height: 32)

                                VStack(alignment: .leading) {
                                    Label(text: pediaDetailViewModel.summary)
                                        .frame(width: 520, alignment: .leading)

                                    Label(text: pediaDetailViewModel.detail)
                                        .frame(width: 520, alignment: .leading)

                                    Spacer()
                                }
                            }
                            .frame(width: 550, alignment: .leading)
                            .padding(.all, 4)
                        }
                    }

                    Spacer()
                }
            })
            .padding()

            Spacer()
        }
        .frame(width: 600)
        .frame(maxHeight: .infinity)
        //.background(Color.blue)
    }
}

#if DEBUG
struct PediaView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = PediaViewModel()

        PediaView(viewModel: viewModel)
    }
}
#endif
