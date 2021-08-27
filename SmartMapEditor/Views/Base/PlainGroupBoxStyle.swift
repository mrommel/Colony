//
//  PlainGroupBoxStyle.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 20.12.20.
//

import Cocoa
import SwiftUI

struct PlainGroupBoxStyle: GroupBoxStyle {

    func makeBody(configuration: Configuration) -> some View {

        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding(8)
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
