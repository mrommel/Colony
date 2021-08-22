//
//  Operations.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class Operations: Codable {

    enum CodingKeys: CodingKey {

        case operations
    }

    internal var operations: [Operation]

    init() {

        self.operations = []
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.operations = try container.decode([Operation].self, forKey: .operations)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.operations, forKey: .operations)
    }

    func turn(in gameModel: GameModel?) {

        for operation in self.operations {

            print("--- operation: \(operation.type) - \(operation.state)")
        }
    }

    func add(operation: Operation) {

        self.operations.append(operation)
    }

    func delete(operation: Operation) {

        self.operations.removeAll(where: { $0 == operation })
    }

    func operationsOf(type: UnitOperationType) -> [Operation] {

        return self.operations.filter({ $0.type == type })
    }

    func numUnitsNeededToBeBuilt() -> Int {

        var rtnValue = 0

        for operation in self.operations {

            rtnValue += operation.numUnitsNeededToBeBuilt()
        }

        return rtnValue
    }

    func doDelayedDeath(in gameModel: GameModel?) {

        var operationsToDelete: [Operation?] = []

        for operation in self.operations {

            if operation.doDelayedDeath(in: gameModel) {
                operationsToDelete.append(operation)
            }
        }

        for operationToDelete in operationsToDelete {
            self.operations.removeAll(where: { $0 == operationToDelete })
        }
    }

    func isCityAlreadyTargeted(city: AbstractCity?, via domain: UnitDomainType, percentToTarget: Int = 100, in gameModel: GameModel?) -> Bool {

        guard let city = city else {
            fatalError("cant get city")
        }

        for operation in self.operations {

            if operation.targetPosition == city.location && operation.percentFromMusterPointToTarget(in: gameModel) < percentToTarget {

                // Naval attacks are mixed land/naval operations
                if (domain == .none || domain == .sea) && operation.isMixedLandNavalOperation() {
                    return true
                }

                if (domain == .none || domain == .land) && !operation.isMixedLandNavalOperation() {
                    return true
                }
            }
        }

        return false
    }
}

public struct OperationIterator: IteratorProtocol {

    private let operations: Operations
    private var index = 0

    init(operations: Operations) {
        self.operations = operations
    }

    mutating public func next() -> Operation? {

        guard 0 <= index else {
            return nil
        }

        // prevent out of bounds
        guard index < self.operations.operations.count else {
            return nil
        }

        let point = self.operations.operations[index]
        index += 1
        return point
    }
}

extension Operations: Sequence {

    public func makeIterator() -> OperationIterator {
        return OperationIterator(operations: self)
    }
}
