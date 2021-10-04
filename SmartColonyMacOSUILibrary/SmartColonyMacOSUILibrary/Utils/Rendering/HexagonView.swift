//
//  HexagonView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.05.21.
//

import SwiftUI
import SmartAILibrary

struct HexagonView: View {

    @ObservedObject
    var viewModel: HexagonViewModel

    public init(viewModel: HexagonViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        let size = 50.0
        let width = CGFloat(2.0 * size)
        let height = CGFloat(sqrt(3.0) * size)

        Group {
            ZStack {

                RegularPolygon(sides: 6, inset: -6.0)
                    .fill(Color(self.viewModel.tileColor))
                    .scaleEffect(CGSize(width: 1.0, height: 0.75))

                Image(nsImage: self.viewModel.mountainsImage)
                    .resizable()
                    .frame(width: height, height: height, alignment: .center)

                Image(nsImage: self.viewModel.hillsImage)
                    .resizable()
                    .frame(width: height, height: height, alignment: .center)

                Image(nsImage: self.viewModel.forestImage)
                    .resizable()
                    .frame(width: height, height: height, alignment: .center)

                Image(nsImage: self.viewModel.cityImage)
                    .resizable()
                    .frame(width: height, height: height, alignment: .center)

                Image(nsImage: self.viewModel.actionImage)
                    .resizable()
                    .frame(width: height, height: height, alignment: .center)

                Text(self.viewModel.costText)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.all, 2)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(5)
                    .offset(x: 0, y: 15.0)
            }
            .frame(width: width, height: height, alignment: .center)
            .onTapGesture {
                self.viewModel.clicked()
            }
        }
        .scaleEffect(CGSize(width: 0.5, height: 0.5))
    }
}

#if DEBUG
struct HexagonView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = HexagonViewModel(
            at: HexPoint(x: 1, y: 1),
            tileColor: NSColor.lightGreen,
            mountains: nil,
            hills: nil,
            forest: nil,
            city: nil,
            tileAction: TileActionType.purchasable.textureName,
            cost: 100,
            showCitizenIcons: true
        )
        HexagonView(viewModel: viewModel)

        //HexagonView(viewModel: HexagonViewModel(tile: .grass))

        //HexagonView(viewModel: HexagonViewModel(tile: .ocean))
    }
}
#endif
