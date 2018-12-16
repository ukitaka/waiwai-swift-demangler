//
//  Parser.swift
//  SwiftDemangler
//
//  Created by ukitaka on 2018/12/16.
//

import Foundation

class Parser {
    private let name: String
    private var index: String.Index
    
    init(name: String) {
        self.name = name
        self.index = name.startIndex
    }
    
    var remains: String { return String(name[index...]) }
}

// MARK: - Step2
extension Parser {
    func parseInt() -> Int? {
        let remains = self.remains
        if let int = Int(remains) {
            self.index = name.endIndex
            return int
        }
        let decimalDigits = "0123456789"
        guard let index = remains.firstIndex(where: { c in !decimalDigits.contains(c) }) else {
            return nil
        }
        guard let int = Int(remains.prefix(upTo: index)) else {
            return nil
        }
        self.index = self.name.index(self.index, offsetBy: (int / 10) + 1)
        return int
    }
}

extension Parser {
    func parseIdentifier(length: Int) -> String {
        let remains = self.remains
        self.index = self.name.index(self.index, offsetBy: length)
        return String(remains.prefix(length))
    }
}

extension Parser {
    func parseIdentifier() -> String? {
        guard let lengh = self.parseInt() else {
            return nil
        }
        return parseIdentifier(length: lengh)
    }
}

// MARK: - Step3
extension Parser {
    func parsePrefix() -> String {
        guard name.hasPrefix("$S") else {
            fatalError()
        }
        self.index = self.name.index(self.index, offsetBy: 2)
        return "$S"
    }
    
    func parseModule() -> String {
        return parseIdentifier()!
    }
}

// MARK: - Step4
extension Parser {
    func parseDeclName() -> String {
        return parseIdentifier()!
    }
}

extension Parser {
    func parseLabelList() -> [String] {
        var list: [String] = []
        while let label = self.parseIdentifier() {
            list.append(label)
        }
        return list
    }
}

// MARK: - Step5
extension Parser {
    func peek() -> String {
        return self.remains.first.map(String.init) ?? ""
    }
    
    func skip(length: Int) {
        self.index = self.name.index(self.index, offsetBy: length)
    }
}

// MARK: - Step6
enum Type {
    case bool
    case int
    case string
    case float
    indirect case list([Type])
}

extension Type: Equatable {
    static func == (lhs: Type, rhs: Type) -> Bool {
        switch (lhs, rhs) {
        case (.bool, .bool): return true
        case (.int, .int): return true
        case (.string, .string): return true
        case (.float, .float): return true
        case let (.list(list1), .list(list2)):
            return list1 == list2
        default:
            return false
        }
        
    }
}

extension Parser {
    func parseKnownType() -> Type {
        guard peek() == "S" else {
            fatalError()
        }
        switch parseIdentifier(length: 2) {
        case "Sb": return .bool
        case "Si": return .int
        case "Sf": return .float
        case "SS": return .string
        default:
            fatalError()
        }
    }
    
    func parseType() -> Type {
        let firstType = parseKnownType()
        if peek() == "_" {
            skip(length: 1)
            var list: [Type] = [firstType]
            while peek() != "t" {
                list.append(parseKnownType())
            }
            skip(length: 1)
            return .list(list)
        } else {
            return firstType
        }
    }
}

// MARK: - Step7
struct FunctionSignature: Equatable {
    let returnType: Type
    let argsType: Type
}

extension Parser {
    func parseFunctionSignature() -> FunctionSignature {
        let returnType = self.parseType()
        let argsType = self.parseType()
        return FunctionSignature(returnType: returnType, argsType: argsType)
    }
}

// MARK: - Step8
struct FunctionEntity: Equatable {
    let module: String
    let declName: String
    let labelList: [String]
    let functionSignature: FunctionSignature
}

extension Parser {
    func parseFunctionEntity() -> FunctionEntity {
        let module = self.parseModule()
        let declName = self.parseDeclName()
        let labelList = self.parseLabelList()
        let functionSignature = self.parseFunctionSignature()
        return FunctionEntity(module: module, declName: declName, labelList: labelList, functionSignature: functionSignature)
    }
    
    func parse() -> FunctionEntity {
        let _ = self.parsePrefix()
        return self.parseFunctionEntity()
    }
}

// MARK: - Step9

extension Type: CustomStringConvertible {
    var description: String {
        switch self {
        case .bool:
            return "Swift.Bool"
        case .int:
            return "Swift.Int"
        case .string:
            return "Swift.String"
        case .float:
            return "Swift.Float"
        case .list(let list):
            return "(" + list.map { $0.description }.joined(separator: ",") + ")"
        }
    }
}

extension FunctionEntity: CustomStringConvertible {
    private var args: String {
        guard case .list(let argList) = functionSignature.argsType else {
            return "()"
        }
        return "(" + zip(labelList, argList).map { (label, type) in "\(label): \(type)" }.joined(separator: ",") + ")"
    }

    var description: String {
        return "\(module).\(declName)\(args) -> \(functionSignature.returnType)"
    }
}
