//
//  TruncatedLabelNode.swift
//  Colony
//
//  Created by Michael Rommel on 02.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class TruncatedLabelNode: SKLabelNode {
    
    // MARK: - Public Properties
    public var originalText: String? = nil {
        didSet { self.text = originalText }
    }
    
    public var maxWidth: CGFloat = 0
    
    // MARK: - constructors
    
    override init() {
        
        super.init()
        self.originalText = ""
    }
    
    init(text: String?) {
        
        super.init(fontNamed: Formatters.Fonts.systemFontFamilyname)
        self.originalText = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func limitText() {
        
        guard let originalText = self.originalText, let font = UIFont(name: self.fontName!, size: self.fontSize), self.maxWidth > 0.0 else {
            return
        }
        
        self.text = self.buildBoundedString(for: originalText, with: font, maxWidth: self.maxWidth)
    }
}

private extension TruncatedLabelNode {
    
    private struct Configuration {
        static let truncationPattern = " .."
    }
    
    func width(for text: String, with font: UIFont) -> CGFloat {
        let size = text.size(withAttributes: [.font: font])
        return size.width
    }
    
    func buildBoundedString(for text: String, with font: UIFont, maxWidth: CGFloat) -> String {
        let textWidth = width(for: text, with: font)
        
        if textWidth < maxWidth {
            return text
        } else {
            let truncatedString = buildTruncatedString(from: text)
            return buildBoundedString(for: truncatedString, with: font, maxWidth: maxWidth)
        }
    }
    
    func buildTruncatedString(from truncatedString: String) -> String {
        
        let truncation = Configuration.truncationPattern
        
        switch self.lineBreakMode {
        case .byTruncatingHead:
            let truncatedText = truncatedString
                .replacingOccurrences(of: truncation, with: "")
                .dropFirst()
            return truncation.appending(truncatedText)
        case .byTruncatingTail:
            return truncatedString
                .replacingOccurrences(of: truncation, with: "")
                .dropLast()
                .appending(truncation)
        case .byTruncatingMiddle:
            let untruncatedText = truncatedString.replacingOccurrences(of: truncation, with: "")
            
            let halfCount = untruncatedText.count / 2
            let isEvenCount = untruncatedText.count % 2 == 1
            let offset = isEvenCount ? 1 : 0
            
            let firstHalf = untruncatedText.prefix(halfCount + offset)
            let secondHalf = untruncatedText.suffix(halfCount)
            let firstHalfWithoutLast = firstHalf.dropLast()
            
            return firstHalfWithoutLast + truncation + secondHalf
        case .byWordWrapping:
            // NOOP
            break
        case .byCharWrapping:
            // NOOP
            break
        case .byClipping:
            return truncatedString
                .replacingOccurrences(of: truncation, with: "")
                .dropLast().appending("")
        @unknown default:
            // NOOP
            break
        }
        
        return ""
    }
}
