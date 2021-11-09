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
    var accent: NSColor

    @Published
    var main: NSColor

    init(name: String, accent: NSColor, main: NSColor) {

        self.name = name
        self.accent = accent
        self.main = main
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

struct Triangle: Shape {

    let accent: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()

        if accent {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }

        return path
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

                        ZStack {
                            Triangle(accent: true)
                                .fill(Color(legendItemViewModel.accent))
                                .frame(width: 8, height: 8)

                            Triangle(accent: false)
                                .fill(Color(legendItemViewModel.main))
                                .frame(width: 8, height: 8)
                        }
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

        legendItemViewModels.append(ScoreLegendDataItem(name: "Abc", accent: .red, main: .black))
        legendItemViewModels.append(ScoreLegendDataItem(name: "Def", accent: .blue, main: .yellow))
        legendItemViewModels.append(ScoreLegendDataItem(name: "Ghi", accent: .green, main: .white))

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
