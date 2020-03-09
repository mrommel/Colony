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

protocol AbstractProjects {
    
    // projects
    func has(project: ProjectType) -> Bool
    func build(project: ProjectType) throws
}

class Projects: AbstractProjects {
    
    private var city: AbstractCity?
    private var projects: [ProjectType]
    
    init(city: AbstractCity?) {
        
        self.city = city
        self.projects = []
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
