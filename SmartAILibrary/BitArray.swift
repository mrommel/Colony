//
//  BitArray.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

final class BitArray: NSObject, NSCoding, Codable {

    //Array of bits manipulation
    typealias WordType = UInt64

    enum CodingKeys: String, CodingKey {
        case array
    }

    private var array: [WordType] = []

    // MARK: constructors

    init(count: Int) {
        super.init()
        self.array = self.buildArray(count: count)
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.array = try values.decode([WordType].self, forKey: .array)
    }

    // MARK: methods

    public func valueOfBit(at index: Int) -> Bool {
        return self.valueOfBit(in: self.array, at: index)
    }

    public func setValueOfBit(value: Bool, at index: Int) {
        self.setValueOfBit(in: &self.array, at: index, value: value)
    }

    public func count() -> Int {
        return self.array.count * intSize - 1
    }

    public func reset() {

        for index in 0..<self.count() {
            self.setValueOfBit(value: false, at: index)
        }
    }

    //NSCoding

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.array, forKey: "internalBitArray")
    }

    init?(coder aDecoder: NSCoder) {
        super.init()
        let array: [WordType] = aDecoder.decodeObject(forKey: "internalBitArray") as? [WordType] ?? []
        self.array = array
    }

    //Private API

    private func valueOfBit(in array: [WordType], at index: Int) -> Bool {
        checkIndexBound(index: index, lowerBound: 0, upperBound: array.count * intSize - 1)
        let (arrayIndex, bitIndexVal) = bitIndex(at: index)
        let bit = array[arrayIndex]
        return valueOf(bit: bit, atIndex: bitIndexVal)
    }

    private func setValueOfBit(in array: inout[WordType], at index: Int, value: Bool) {
        checkIndexBound(index: index, lowerBound: 0, upperBound: array.count * intSize - 1)
        let (arrayIndex, bitIndexVal) = bitIndex(at: index)
        let bit = array[arrayIndex]
        let newBit = setValueFor(bit: bit, value: value, atIndex: bitIndexVal)
        array[arrayIndex] = newBit
    }

    //Constants
    private let intSize = MemoryLayout<WordType>.size * 8

    //bit masks

    func invertedIndex(index: Int) -> Int {
        return intSize - 1 - index
    }

    func mask(index: Int) -> WordType {
        checkIndexBound(index: index, lowerBound: 0, upperBound: intSize - 1)
        return 1 << WordType(invertedIndex(index: index))
    }

    func negative(index: Int) -> WordType {
        checkIndexBound(index: index, lowerBound: 0, upperBound: intSize - 1)
        return ~(1 << WordType(invertedIndex(index: index)))
    }

    //return (arrayIndex for word containing the bit, bitIndex inside the word)
    private func bitIndex(at index: Int) -> (Int, Int) {
        return(index / intSize, index % intSize)
    }

    private func buildArray(count: Int) -> [WordType] {
        //words contain intSize bits each
        let numWords = count / intSize + 1
        return Array.init(repeating: WordType(0), count: numWords)
    }

    //Bit manipulation
    private func valueOf(bit: WordType, atIndex index: Int) -> Bool {
        checkIndexBound(index: index, lowerBound: 0, upperBound: intSize - 1)
        return (bit & mask(index: index) != 0)
    }

    private func setValueFor(bit: WordType, value: Bool, atIndex index: Int) -> WordType {
        checkIndexBound(index: index, lowerBound: 0, upperBound: intSize - 1)
        if value {
            return (bit | mask(index: index))
        }
        return bit & negative(index: index)
    }

    //Util
    private func checkIndexBound(index: Int, lowerBound: Int, upperBound: Int) {
        if index < lowerBound || index > upperBound {
            NSException.init(name: NSExceptionName(rawValue: "BitArray Exception"), reason: "index out of bounds", userInfo: nil).raise()
        }
    }
}
