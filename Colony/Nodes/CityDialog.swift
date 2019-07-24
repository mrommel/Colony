//
//  CityDialog.swift
//  Colony
//
//  Created by Michael Rommel on 23.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class CityDialog: Dialog {
    
    override init(from dialogConfiguration: DialogConfiguration) {
        super.init(from: dialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methids
    
    func populate(with city: City?) {
        
        if let city = city {
            self.set(imageNamed: "city_1_no_walls", identifier: "dialog_image")
            self.set(text: city.name, identifier: "summary")
        }
    }
}
