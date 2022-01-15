//
//  Eurekas.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TechEurekas: Codable {

    var eurekaCounter: EurekaCounterList
    var eurakaTrigger: EurekaTriggeredList

    class EurekaCounterList: WeightedList<TechType> {

        override func fill() {

            for techType in TechType.all {
                self.add(weight: 0, for: techType)
            }
        }
    }

    class EurekaTriggeredList: WeightedList<TechType> {

        override func fill() {

            for techType in TechType.all {
                self.add(weight: 0, for: techType)
            }
        }

        func trigger(for techType: TechType) {

            self.set(weight: 1.0, for: techType)
        }

        func triggered(for techType: TechType) -> Bool {

            return self.weight(of: techType) > 0.0
        }
    }

    init() {
        self.eurekaCounter = EurekaCounterList()
        self.eurekaCounter.fill()

        self.eurakaTrigger = EurekaTriggeredList()
        self.eurakaTrigger.fill()
    }

    func triggered(for tech: TechType) -> Bool {

        return self.eurakaTrigger.triggered(for: tech)
    }
}

class CivicInspirations: Codable {

    var inspirationCounter: InspirationCounterList
    var inspirationTrigger: InspirationTriggeredList

    class InspirationCounterList: WeightedList<CivicType> {

        override func fill() {

            for civicType in CivicType.all {
                self.add(weight: 0, for: civicType)
            }
        }
    }

    class InspirationTriggeredList: WeightedList<CivicType> {

        override func fill() {

            for civicType in CivicType.all {
                self.add(weight: 0, for: civicType)
            }
        }

        func trigger(for civicType: CivicType) {

            self.set(weight: 1.0, for: civicType)
        }

        func triggered(for civicType: CivicType) -> Bool {

            return self.weight(of: civicType) > 0.0
        }
    }

    init() {
        self.inspirationCounter = InspirationCounterList()
        self.inspirationCounter.fill()

        self.inspirationTrigger = InspirationTriggeredList()
        self.inspirationTrigger.fill()
    }

    func triggered(for civic: CivicType) -> Bool {

        return self.inspirationTrigger.triggered(for: civic)
    }
}
