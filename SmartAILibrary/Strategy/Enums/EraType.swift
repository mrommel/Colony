//
//  EraType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum EraType: Int, Codable {
    
    case none
    
    case ancient
    case classical
    case medieval
    case renaissance
    case industrial
    case modern
    case atomic
    case information
    case future
    
    public static var all: [EraType] {
        
        return [.ancient, .classical, .medieval, .renaissance, .industrial, .modern, .atomic, .information, .future]
    }
    
    internal func value() -> Int {
        
        switch self {
            
        case .none: return -1
            
        case .ancient: return 0
        case .classical: return 1
        case .medieval: return 2
        case .renaissance: return 3
        case .industrial: return 4
        case .modern: return 5
        case .atomic: return 6
        case .information: return 7
        case .future: return 8
        }
    }
    
    func next() -> EraType {
        
        switch self {
            
        case .none: return .none
            
        case .ancient: return .classical
        case .classical: return .medieval
        case .medieval: return .renaissance
        case .renaissance: return .renaissance
        case .industrial: return .modern
        case .modern: return .atomic
        case .atomic: return .information
        case .information: return .future
        case .future: return .none
        }
    }
}

extension EraType: Comparable {
    
    public static func == (lhs: EraType, rhs: EraType) -> Bool {
        return lhs.value() == rhs.value()
    }
    
    public static func < (lhs: EraType, rhs: EraType) -> Bool {
        return lhs.value() < rhs.value()
    }
}
