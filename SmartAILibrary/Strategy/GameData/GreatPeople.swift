//
//  GreatPeople.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 31.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class GreatPersonPoints: Codable {

    enum CodingKeys: CodingKey {

        case greatGeneral
        case greatAdmiral
        case greatEngineer
        case greatMerchant
        case greatProphet
        case greatScientist
        case greatWriter
        case greatArtist
        case greatMusician
    }

    var greatGeneral: Int
    var greatAdmiral: Int
    var greatEngineer: Int
    var greatMerchant: Int
    var greatProphet: Int
    var greatScientist: Int
    var greatWriter: Int
    var greatArtist: Int
    var greatMusician: Int

    init(greatGeneral: Int = 0, greatAdmiral: Int = 0, greatEngineer: Int = 0, greatMerchant: Int = 0, greatProphet: Int = 0, greatScientist: Int = 0, greatWriter: Int = 0, greatArtist: Int = 0, greatMusician: Int = 0) {

        self.greatGeneral = greatGeneral
        self.greatAdmiral = greatAdmiral
        self.greatEngineer = greatEngineer
        self.greatMerchant = greatMerchant
        self.greatProphet = greatProphet
        self.greatScientist = greatScientist
        self.greatWriter = greatWriter
        self.greatArtist = greatArtist
        self.greatMusician = greatMusician
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.greatGeneral = try container.decode(Int.self, forKey: .greatGeneral)
        self.greatAdmiral = try container.decode(Int.self, forKey: .greatGeneral)
        self.greatEngineer = try container.decode(Int.self, forKey: .greatEngineer)
        self.greatMerchant = try container.decode(Int.self, forKey: .greatMerchant)
        self.greatProphet = try container.decode(Int.self, forKey: .greatProphet)
        self.greatScientist = try container.decode(Int.self, forKey: .greatScientist)
        self.greatWriter = try container.decode(Int.self, forKey: .greatWriter)
        self.greatArtist = try container.decode(Int.self, forKey: .greatArtist)
        self.greatMusician = try container.decode(Int.self, forKey: .greatMusician)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.greatGeneral, forKey: .greatGeneral)
        try container.encode(self.greatAdmiral, forKey: .greatAdmiral)
        try container.encode(self.greatEngineer, forKey: .greatEngineer)
        try container.encode(self.greatMerchant, forKey: .greatMerchant)
        try container.encode(self.greatProphet, forKey: .greatProphet)
        try container.encode(self.greatScientist, forKey: .greatScientist)
        try container.encode(self.greatWriter, forKey: .greatWriter)
        try container.encode(self.greatArtist, forKey: .greatArtist)
        try container.encode(self.greatMusician, forKey: .greatMusician)
    }

    func add(other: GreatPersonPoints) {

        self.greatGeneral += other.greatGeneral
        self.greatAdmiral += other.greatAdmiral
        self.greatEngineer += other.greatEngineer
        self.greatMerchant += other.greatMerchant
        self.greatProphet += other.greatProphet
        self.greatScientist += other.greatScientist
        self.greatWriter += other.greatWriter
        self.greatArtist += other.greatArtist
        self.greatMusician += other.greatMusician
    }
}

public protocol AbstractGreatPeople: class, Codable {

    var player: AbstractPlayer? { get set }

    func add(points: GreatPersonPoints)
}

class GreatPeople: AbstractGreatPeople {

    enum CodingKeys: CodingKey {

        case points
    }

    // user properties / values
    var player: AbstractPlayer?
    var points: GreatPersonPoints

    // MARK: constructor

    init(player: Player?) {

        self.player = player
        self.points = GreatPersonPoints()
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.points = try container.decode(GreatPersonPoints.self, forKey: .points)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.points, forKey: .points)
    }

    func add(points value: GreatPersonPoints) {

        self.points.add(other: value)
    }
}
