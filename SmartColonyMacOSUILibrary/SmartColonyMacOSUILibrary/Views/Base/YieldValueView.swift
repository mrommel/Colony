//
//  YieldValueView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class YieldValueViewModel: ObservableObject {
    
    let yieldType: YieldType
    let value: Double
    
    init(yieldType: YieldType, value: Double) {
        
        self.yieldType = yieldType
        self.value = value
    }
    
    func iconImage() -> NSImage {
        
        return ImageCache.shared.image(for: self.yieldType.iconTexture())
    }
    
    func backgroundImage() -> NSImage {
        
        return ImageCache.shared.image(for: self.yieldType.backgroundTexture())
    }
    
    func valueText() -> String {
        
        return String(format: "%.1f", self.value)
    }
}

struct YieldValueView: View {
    
    @ObservedObject
    var viewModel: YieldValueViewModel
    
    public var body: some View {
        
        HStack(alignment: .center) {
            Image(nsImage: self.viewModel.iconImage())
                .resizable()
                .frame(width: 12, height: 12, alignment: .center)
            
            Text(self.viewModel.valueText())
                .foregroundColor(Color(self.viewModel.yieldType.fontColor()))
        }
        .background(
            Image(nsImage: self.viewModel.backgroundImage())
                .resizable(capInsets: EdgeInsets(all: 8))
                .frame(width: 65, height: 20, alignment: .center)
        )
        .frame(width: 65, height: 20, alignment: .center)
    }
}

#if DEBUG
struct YieldValueView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)

        YieldValueView(viewModel: YieldValueViewModel(yieldType: .food, value: 2.32))
        
        YieldValueView(viewModel: YieldValueViewModel(yieldType: .production, value: 12.32))
    }
}
#endif
