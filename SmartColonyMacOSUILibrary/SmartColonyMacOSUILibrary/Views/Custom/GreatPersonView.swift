//
//  GreatPersonView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.10.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct GreatPersonView: View {

    @ObservedObject
    var viewModel: GreatPersonViewModel

    private let cornerRadius: CGFloat = 5
    private let cardWidth: CGFloat = 100
    private let cardHeight: CGFloat = 300
    private let imageSize: CGFloat = 70

    public init(viewModel: GreatPersonViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        ZStack {

            RoundedRectangle(cornerRadius: self.cornerRadius)
                .strokeBorder(Color(Globals.Colors.dialogBorder), lineWidth: 1)
                .frame(width: self.cardWidth, height: self.cardHeight)
                .background(Color(Globals.Colors.greatPersonBackground))

            VStack(alignment: .center, spacing: 4) {

                self.headerView

                ZStack {
                    Image(nsImage: self.viewModel.image())
                        .resizable()
                        .frame(width: self.imageSize, height: self.imageSize, alignment: .center)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                        .border(Color.black)

                    // self.imageInfoView
                }
                .frame(width: self.imageSize, height: self.imageSize, alignment: .center)
                .padding(.top, 8)

                Divider()
                    .background(Color(Globals.Colors.dialogBorder))
                    .padding(.horizontal, 6)

                Text("Effects")
                    .font(.system(size: 8))

                Spacer()
                    .frame(minHeight: 0, maxHeight: 100)

                Text("Recruit Progress")
                    .font(.system(size: 7))

                ProgressBar(value: self.$viewModel.progress, maxValue: self.viewModel.maxValue, backgroundColor: .black, foregroundColor: .white)
                    .frame(width: self.cardWidth - 20, height: 6, alignment: .top)

                Divider()
                    .background(Color(Globals.Colors.dialogBorder))
                    .padding(.horizontal, 6)
            }
            .frame(width: self.cardWidth, height: self.cardHeight - 8, alignment: .center)
            .padding(.bottom, 8)
        }
        .frame(width: self.cardWidth, height: self.cardHeight, alignment: .center)
        .cornerRadius(self.cornerRadius)
    }

    var headerView: AnyView {

        AnyView(
            VStack(alignment: .center, spacing: 4) {

                Text(self.viewModel.typeName)
                    .font(.system(size: 8))

                Text(self.viewModel.name)
                    .font(.system(size: 10))

                Divider()
                    .background(Color(Globals.Colors.dialogBorder))
                    .padding(.horizontal, 6)

                Text(self.viewModel.eraName)
                    .font(.system(size: 8))
            }
        )
    }
}

#if DEBUG
struct GreatPersonView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        HStack {

            let greatPersonAdiShankara = GreatPerson.adiShankara
            let viewModelAdiShankara = GreatPersonViewModel(greatPerson: greatPersonAdiShankara, progress: 0.7, cost: 20.0)

            GreatPersonView(viewModel: viewModelAdiShankara)

            let greatPersonSunTzu = GreatPerson.sunTzu
            let viewModelSunTzu = GreatPersonViewModel(greatPerson: greatPersonSunTzu, progress: 19.7, cost: 20.0)

            GreatPersonView(viewModel: viewModelSunTzu)
        }
    }
}
#endif
