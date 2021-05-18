//
//  HeaderButtonView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI

enum HeaderButtonType {
    
    case science
    case culture
    case government
    case log
    
    case ranking
    case tradeRoutes
    
    func iconTexture(for state: Bool) -> String {
        
        switch self {
        
        case .science:
            return state ? "header-science-button-active" : "header-science-button-disabled"
        case .culture:
            return state ? "header-culture-button-active" : "header-culture-button-disabled"
        case .government:
            return state ? "header-government-button-active" : "header-government-button-disabled"
        case .log:
            return state ? "header-log-button-active" : "header-log-button-disabled"
        case .ranking:
            return state ? "header-log-button-active" : "header-log-button-disabled"
        case .tradeRoutes:
            return state ? "header-log-button-active" : "header-log-button-disabled"
        }
    }
}

protocol HeaderButtonViewModelDelegate: AnyObject {
    
    func clicked(on type: HeaderButtonType)
}

class HeaderButtonViewModel: ObservableObject {
    
    let type: HeaderButtonType
    
    @Published
    var active: Bool = true
    
    weak var delegate: HeaderButtonViewModelDelegate?
    
    init(type: HeaderButtonType) {
        
        self.type = type
    }
    
    func icon() -> NSImage {
        
        return ImageCache.shared.image(for: self.type.iconTexture(for: self.active))
    }
    
    func clicked() {
        
        print("clicked on header: \(self.type)")
        self.delegate?.clicked(on: self.type)
    }
}

struct HeaderButtonView: View {
    
    @ObservedObject
    public var viewModel: HeaderButtonViewModel
    
    public init(viewModel: HeaderButtonViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 38, height: 38, alignment: .center)
                .padding(.top, 4)
                .padding(.leading, 9.5)
                .onTapGesture {
                    self.viewModel.clicked()
                }
        }
        .frame(width: 56, height: 47, alignment: .topLeading)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "header-bar-button"))
                .resizable()
            )
    }
}

#if DEBUG
struct HeaderButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = HeaderButtonViewModel(type: .government)
        
        HeaderButtonView(viewModel: viewModel)
    }
}
#endif
