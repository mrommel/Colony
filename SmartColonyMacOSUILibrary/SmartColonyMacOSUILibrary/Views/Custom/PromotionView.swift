//
//  PromotionView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 31.08.21.
//

import SwiftUI
import SmartAILibrary

/*extension Text {
    init(_ astring: NSAttributedString) {
        self.init("")

        astring.enumerateAttributes(in: NSRange(location: 0, length: astring.length), options: []) { (attrs, range, _) in

            var t = Text(astring.attributedSubstring(from: range).string)

            if let color = attrs[NSAttributedString.Key.foregroundColor] as? NSColor {
                t  = t.foregroundColor(Color(color))
            }

            if let font = attrs[NSAttributedString.Key.font] as? NSFont {
                t  = t.font(.init(font))
            }

            if let kern = attrs[NSAttributedString.Key.kern] as? CGFloat {
                t  = t.kerning(kern)
            }

            if let striked = attrs[NSAttributedString.Key.strikethroughStyle] as? NSNumber, striked != 0 {
                if let strikeColor = (attrs[NSAttributedString.Key.strikethroughColor] as? NSColor) {
                    t = t.strikethrough(true, color: Color(strikeColor))
                } else {
                    t = t.strikethrough(true)
                }
            }

            if let baseline = attrs[NSAttributedString.Key.baselineOffset] as? NSNumber {
                t = t.baselineOffset(CGFloat(baseline.floatValue))
            }

            if let underline = attrs[NSAttributedString.Key.underlineStyle] as? NSNumber, underline != 0 {
                if let underlineColor = (attrs[NSAttributedString.Key.underlineColor] as? NSColor) {
                    t = t.underline(true, color: Color(underlineColor))
                } else {
                    t = t.underline(true)
                }
            }

            self = self + t
        }
    }
}*/

struct AttributedText: View {
    @State var size: CGSize = .zero
    let attributedString: NSAttributedString

    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    var body: some View {
        AttributedTextRepresentable(attributedString: attributedString, size: $size)
            .frame(width: size.width, height: size.height)
    }

    struct AttributedTextRepresentable: NSViewRepresentable {

        let attributedString: NSAttributedString
        @Binding var size: CGSize

        func makeNSView(context: Context) -> NSTextView {
            let textView = NSTextView()

            textView.textContainer!.widthTracksTextView = false
            textView.textContainer!.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            textView.drawsBackground = false

            return textView
        }

        func updateNSView(_ nsView: NSTextView, context: Context) {
            nsView.textStorage?.setAttributedString(attributedString)

            DispatchQueue.main.async {
                size = nsView.textStorage!.size()
            }
        }
    }
}

struct PromotionView: View {

    @ObservedObject
    var viewModel: PromotionViewModel

    public init(viewModel: PromotionViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(alignment: .top, spacing: 4) {

            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.leading, 8)

            VStack(alignment: .leading, spacing: 4) {

                Text(self.viewModel.name)
                    .font(.headline)

                Text(self.viewModel.effect)
            }
            .padding(.leading, 4)
            .padding(.trailing, 8)

            Spacer()
        }
        .frame(width: 300, height: 65)
        .onTapGesture {
            self.viewModel.selectPromotion()
        }
        .background(
            Image(nsImage: self.viewModel.background())
                .resizable(capInsets: EdgeInsets(all: 15))
        )
    }
}

#if DEBUG
struct PromotionView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModelAlpine = PromotionViewModel(promotionType: .alpine, state: .possible)
        PromotionView(viewModel: viewModelAlpine)

        let viewModelCamouflage = PromotionViewModel(promotionType: .camouflage, state: .gained)
        PromotionView(viewModel: viewModelCamouflage)

        let viewModelCommando = PromotionViewModel(promotionType: .commando, state: .disabled)
        PromotionView(viewModel: viewModelCommando)
    }
}
#endif
