//
//  SegmentedProgressView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 22.03.22.
//

import SwiftUI

class SegmentedProgressViewModel: ObservableObject {

    @Published
    var value: Int

    @Published
    var maximum: Int = 7

    init(value: Int, maximum: Int = 10) {

        self.value = value
        self.maximum = maximum
    }
}

struct SegmentedProgressView: View {

    var height: CGFloat = 10
    var spacing: CGFloat = 2

    @State private var selectedColor: Color = .accentColor
    @State private var unselectedColor: Color = Color.secondary.opacity(0.3)

    @ObservedObject
    public var viewModel: SegmentedProgressViewModel

    init(value: Int, maximum: Int) {

        self.viewModel = SegmentedProgressViewModel(value: value, maximum: maximum)
    }

    var body: some View {
        HStack(spacing: self.spacing) {
            ForEach(0 ..< self.viewModel.maximum, id: \.self) { index in
                Rectangle()
                    .foregroundColor(index < self.viewModel.value ? self.selectedColor : self.unselectedColor)
            }
        }
        .frame(maxHeight: self.height)
        .clipShape(Capsule())
    }

    // simply modify self, as self is just a value
    public func selectedColor(color: Color) -> some View {
        var view = self
        view._selectedColor = State(initialValue: color)
        return view.id(UUID())
    }
}
