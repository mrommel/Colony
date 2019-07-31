//
//  Formatters.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import UIKit

public struct Formatters {
    
}

public extension Formatters {
    
    struct Numbers {
        
        // MARK:- Properties
        
        private static let currencyFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            return formatter
        }()
        
        private static let decimalFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            
            return formatter
        }()
        
        private static let integerFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            
            return formatter
        }()
        
        private static let coinFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            formatter.minimumIntegerDigits = 4
            formatter.groupingSeparator = "" // no thousands separator
            
            return formatter
        }()
        
        // MARK:- API
        
        // MARK: Integers
        
        public static func getIntegerString(from value: Int64?, defaultValue: String = "") -> String {
            if let value = value {
                return integerFormatter.string(from: NSNumber(value: value)) ?? defaultValue
            }
            return defaultValue
        }
        
        public static func getIntegerString(from value: Int?, defaultValue: String = "") -> String {
            if let value = value {
                return integerFormatter.string(from: NSNumber(value: value)) ?? defaultValue
            }
            return defaultValue
        }
        
        public static func getIntegerString(from value: Double?, defaultValue: String = "") -> String {
            if let value = value {
                return integerFormatter.string(from: NSNumber(value: value)) ?? defaultValue
            }
            return defaultValue
        }
        
        // MARK: Decimals
        
        public static func getDecimalString(from value: Double?, defaultValue: String = "") -> String {
            if let value = value {
                return decimalFormatter.string(from: NSNumber(value: value)) ?? defaultValue
            }
            return defaultValue
        }
        
        // MARK: Currency
        
        public static func getCurrencyString(from value: Double?, defaultValue: String = "") -> String {
            if let value = value {
                return currencyFormatter.string(from: NSNumber(value: value)) ?? defaultValue
            }
            return defaultValue
        }
        
        // MARK: Coin
        
        public static func getCoinString(from value: Int?, defaultValue: String = "") -> String {
            if let value = value {
                return coinFormatter.string(from: NSNumber(value: value)) ?? defaultValue
            }
            return defaultValue
        }
        
    }
}

public extension Formatters {
    
    struct Dates {
        
        // MARK:- Properties
        
        private static let shortDateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Format.shortDate.rawValue
            
            return dateFormatter
        }()
        
        private static let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Format.date.rawValue
            
            return dateFormatter
        }()
        
        private static let timeFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Format.time.rawValue
            
            return dateFormatter
        }()
        
        private static let dateAndTimeFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Format.dateAndTime.rawValue
            
            return dateFormatter
        }()
        
        // MARK:- API
        
        public static func get(_ format: Format, from date: Date?, defaultValue: String = "") -> String {
            guard let date = date else { return defaultValue }
            
            switch format {
            case .date: return dateFormatter.string(from: date)
            case .dateAndTime: return dateAndTimeFormatter.string(from: date)
            case .shortDate: return shortDateFormatter.string(from: date)
            case .time: return timeFormatter.string(from: date)
            }
        }
        
        public static func getString(from duration: TimeInterval) -> String {
            
            let durationInt: Int      = Int(duration)
            let secondsPerHour: Int   = 3600
            let secondsPerMinute: Int = 60
            
            let hours: Int   = durationInt / secondsPerHour
            let minutes: Int = (durationInt % secondsPerHour) / secondsPerMinute
            let seconds: Int = durationInt % secondsPerMinute
            
            let hoursString: String   = hours == 0 ? "" : String(format: "%02d:", hours)
            let defaultString: String = String(format: "%02d:%02d", minutes, seconds)
            
            return hoursString + defaultString
        }
    }
    
}

public extension Formatters.Dates {
    
    // MARK:- Helping content
    
    enum Format: String {
        
        // MARK:- Presentation
        
        /// Date format: **d MMMM yyyy**
        ///
        /// Example: **13 febuary 2017**
        case shortDate = "d MMMM yyyy"
        
        /// Date format: **EEEE, d MMMM yyyy**
        ///
        /// Example: **Monday, 13 febuary 2017**
        case date = "EEEE, d MMMM yyyy"
        
        /// Date format: **HH:mm:ss**
        ///
        /// Example: **13:12**
        case time = "HH:mm"
        
        /// Date format: **EEEE, d MMMM yyyy HH:mm:ss**
        ///
        /// Example: **Monday, 13 febuary 2017 13:12**
        case dateAndTime = "EEEE, d MMMM yyyy HH:mm"
        
    }
}

public extension Formatters {
    
    struct Fonts {
        
        public static let systemFontBold = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        public static let systemFontBoldFamilyname = systemFontBold.familyName
        
        public static let systemFont = UIFont.systemFont(ofSize: 24)
        public static let systemFontFamilyname = systemFont.familyName
    }
}
