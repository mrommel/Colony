//
//  ReligionType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/List_of_religions_in_Civ6
public enum ReligionType {
    
    case none
        
    case buddhism
    case catholicism
    case confucianism
    case hinduism
    case islam
    case judaism
    case easternOrthodoxy
    case protestantism
    case shinto
    case sikhism
    case taoism
    case zoroastrianism
    
    case custom(title: String)
}
