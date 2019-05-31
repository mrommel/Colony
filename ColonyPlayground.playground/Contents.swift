import UIKit

class Point {
    
    // MARK: properties
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Point: Equatable {
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Point: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "(\(self.x), \(self.y))"
    }
}

class Labyrinth {
    
    let maze: [[Int]]
    
    init(maze: [[Int]]) {
        self.maze = maze
    }
    
    func isGoal(at point: Point) -> Bool {
        
        return self.maze[point.x][point.y] == 2
    }
    
    func isWall(at point: Point) -> Bool {
        
        return self.maze[point.x][point.y] == 1
    }
    
    func isPath(at point: Point) -> Bool {
        
        return self.maze[point.x][point.y] == 0
    }
}

extension Labyrinth: CustomDebugStringConvertible {
    
    var debugDescription: String {
        
        var result = ""
        
        for x in 0..<self.maze[0].count {
            for y in 0..<self.maze.count {
                if self.isGoal(at: Point(x: x, y: y)) {
                    result = "\(result)\n\(x), \(y) => G"
                }
                if self.isWall(at: Point(x: x, y: y)) {
                    result = "\(result)\n\(x), \(y) => W"
                }
                if self.isPath(at: Point(x: x, y: y)) {
                    result = "\(result)\n\(x), \(y) => P"
                }
            }
        }
        
        return result
    }
}

enum Result {
    case wall
    case goal
    case path
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

class Roboter {
    
    let name: String
    
    init(with name: String) {
        self.name = name
    }
    
    func check(labyrinth: Labyrinth, at point: Point) -> Result {
        
        if labyrinth.isWall(at: point) == true {
            print("Shit I have to quit because \(point) is a wall")
            return .wall
        }
        
        if labyrinth.isGoal(at: point) == true {
            print("Hurrah I found the goal at \(point)")
            return .goal
        }
        
        return .path
    }
    
    func enter(labyrinth: Labyrinth, at point: Point) {

        var check: [Point] = []
        var visited: [Point] = []
        
        check.append(point)
        
        while(check.count > 0) {
            
            if let firstPointInCheck = check.popLast() {
            
                let result = self.check(labyrinth: labyrinth, at: firstPointInCheck)
            
                visited.append(firstPointInCheck)
                
                print("firstPointInCheck: \(firstPointInCheck)")
                print("visited: \(visited)")
                print("old check: \(check)")
                
                if result == .goal {
                    return // found goal
                }
            
                if result == .path {
                    print("this is a path")
                    
                    let pointLeft = Point(x: point.x - 1, y: point.y)
                    if !visited.contains(pointLeft) {
                        check.append(pointLeft)
                    }
                    
                    let pointRight = Point(x: point.x + 1, y: point.y)
                    if !visited.contains(pointRight) {
                        check.append(pointRight)
                    }
                    
                    let pointBelow = Point(x: point.x, y: point.y + 1)
                    if !visited.contains(pointBelow) {
                        check.append(pointBelow)
                    }
                    
                    let pointAbove = Point(x: point.x, y: point.y - 1)
                    if !visited.contains(pointAbove) {
                        check.append(pointAbove)
                    }
                }
                
                check = check.removeDuplicates()
                
                print("new check: \(check)")
                print("---------------------__")
            }
        }
    }
}

// *****
// *  Z*
// * ***
// *  X*
// *****
let labyrinth = Labyrinth(maze: [[1, 1, 1, 1, 1], [1, 0, 0, 2, 1], [1, 0, 1, 1, 1], [1, 0, 0, 0, 1], [1, 1, 1, 1, 1]])
print(labyrinth)

let celli = Roboter(with: "Marcel")

celli.enter(labyrinth: labyrinth, at: Point(x: 3, y: 3))

//print("point: \(point)")
