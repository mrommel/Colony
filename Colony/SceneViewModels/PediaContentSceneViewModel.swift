//
//  PediaContentSceneViewModel.swift
//  Colony
//
//  Created by Michael Rommel on 02.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class PediaContentSceneViewModel {
    
    var terrain: Terrain?
    
    init(with viewModel: PediaContentViewModel?) {
        self.terrain = viewModel?.terrain
    }
}
