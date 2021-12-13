//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexHelper

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }

    var caves = [String: Cave]()

    lines.forEach { line in
        let components = line.components(separatedBy: "-")
        let cave1 = components[0]
        let cave2 = components[1]

        if var cave = caves[cave1] {
            cave.neighbours.append(cave2)
            caves[cave1] = cave
        } else {
            let type: CaveType = {
                if cave1 == "start" { return .start }
                if cave1 == "end" { return .end }
                if cave1.lowercased() == cave1 { return .small }
                return .big
            }()
            caves[cave1] = Cave(type: type, neighbours: [cave2])
        }

        if var cave = caves[cave2] {
            cave.neighbours.append(cave1)
            caves[cave2] = cave
        } else {
            let type: CaveType = {
                if cave2 == "start" { return .start }
                if cave2 == "end" { return .end }
                if cave2.lowercased() == cave2 { return .small }
                return .big
            }()
            caves[cave2] = Cave(type: type, neighbours: [cave1])
        }
    }

    let routes = process("start", path: [], caves: caves)
    print(routes)

    let routes2 = process2("start", path: [], revisits: 0, caves: caves)
    print(routes2)
}

func process(_ node: String, path: [String], caves: [String: Cave]) -> Int {
    var routes = 0
    var _path = path
    _path.append(node)
    for cave in caves[node]!.neighbours {
        if caves[cave]!.type == .small {
            if path.contains(cave) {
                continue
            }
        }
        if caves[cave]!.type == .end {
            _path.append("end")
            print(_path.joined(separator: ","))
            routes += 1
            continue
        }
        if caves[cave]!.type == .start {
            continue
        }
        routes += process(cave, path: _path, caves: caves)
    }
    return routes
}

func process2(_ node: String, path: [String], revisits: Int, caves: [String: Cave]) -> Int {
    var _revisits = revisits
    var routes = 0
    var _path = path
    _path.append(node)
    for cave in caves[node]!.neighbours {
        if caves[cave]!.type == .small {
            if path.contains(cave) {
                if _revisits == 0 {
                    _revisits = 1
                } else {
                    continue
                }
            }
        }
        if caves[cave]!.type == .end {
            _path.append("end")
            print(_path.joined(separator: ","))
            routes += 1
            _revisits = 0
            continue
        }
        if caves[cave]!.type == .start {
            continue
        }
        routes += process2(cave, path: _path, revisits: _revisits, caves: caves)
    }
    return routes
}

enum CaveType {
    case big
    case small
    case start
    case end
}

struct Cave {
    let type: CaveType
    var neighbours: [String]
}

main()
