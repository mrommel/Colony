//
//  AbstractProjects.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum ProjectError: Error {
    case alreadyBuild
}

protocol AbstractProjects: Codable {

    var city: AbstractCity? { get set }

    // projects
    func has(project: ProjectType) -> Bool
    func build(project: ProjectType) throws
}

class Projects: AbstractProjects {

    enum CodingKeys: String, CodingKey {

        case projects
    }

    internal var city: AbstractCity?
    private var projects: [ProjectType]

    init(city: AbstractCity?) {

        self.city = city
        self.projects = []
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.projects = try container.decode([ProjectType].self, forKey: .projects)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.projects, forKey: .projects)
    }

    func has(project: ProjectType) -> Bool {

        return self.projects.contains(project)
    }

    func build(project: ProjectType) throws {

        if self.projects.contains(project) {
            throw ProjectError.alreadyBuild
        }

        self.projects.append(project)
    }
}
