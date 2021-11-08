//
//  ScoreLegendView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 08.11.21.
//

import SwiftUI

class ScoreLegendDataItem: ObservableObject {

    private var id: UUID = UUID()

    @Published
    var name: String

    @Published
    var color: NSColor

    init(name: String, color: NSColor) {

        self.name = name
        self.color = color
    }
}

extension ScoreLegendDataItem: Hashable {

    static func == (lhs: ScoreLegendDataItem, rhs: ScoreLegendDataItem) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}

class ScoreLegendViewModel: ObservableObject {

    @Published
    var legendItemViewModels: [ScoreLegendDataItem]

    init(legendItemViewModels: [ScoreLegendDataItem]) {

        self.legendItemViewModels = legendItemViewModels
    }
}

struct ScoreLegendView: View {

    private let legendWidth: CGFloat = 120

    @ObservedObject
    var viewModel: ScoreLegendViewModel

    public init(viewModel: ScoreLegendViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        ScrollView([.vertical], showsIndicators: true) {

            LazyVStack(alignment: .leading, spacing: 4) {

                ForEach(self.viewModel.legendItemViewModels, id: \.self) { legendItemViewModel in

                    HStack(alignment: .center) {

                        Rectangle()
                            .fill(Color(legendItemViewModel.color))
                            .frame(width: 8, height: 8)

                        Text(legendItemViewModel.name)

                        Spacer()
                    }
                    .frame(width: self.legendWidth)
                }
            }
        }
    }
}

#if DEBUG
struct ScoreLegendView_Previews: PreviewProvider {

    static func viewModel() -> ScoreLegendViewModel {

        var legendItemViewModels: [ScoreLegendDataItem] = []

        legendItemViewModels.append(ScoreLegendDataItem(name: "Abc", color: .red))
        legendItemViewModels.append(ScoreLegendDataItem(name: "Def", color: .blue))
        legendItemViewModels.append(ScoreLegendDataItem(name: "Ghi", color: .green))

        let viewModel = ScoreLegendViewModel(legendItemViewModels: legendItemViewModels)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = ScoreLegendView_Previews.viewModel()
        ScoreLegendView(viewModel: viewModel)
    }
}
#endif
