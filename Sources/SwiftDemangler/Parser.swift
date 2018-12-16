//
//  Parser.swift
//  SwiftDemangler
//
//  Created by Yudai.Hirose on 2018/12/16.
//

import Foundation

class Parser {
    let whole: String
    var index: String.Index
    
    var currentOffset: Int {
        return whole.count - remains.count
    }
    
    var remains: String {
        return String(whole[index...])
    }
    
    init(name: String) {
        self.whole = name
        self.index = whole.startIndex
    }
    
    func advance(to offset: Int) {
        index = String.Index(encodedOffset: currentOffset + offset)
    }
}

extension Character {
    func asInt() -> Int? {
        return Int(String(self))
    }
}

extension Parser {
    func parseInt() -> Int? {
        var str: String = ""
        for character in remains {
            if character.asInt() == nil {
                break
            }
            str.append(character)
        }
        
        advance(to: str.count)
        return Int(str)
    }
}

extension Parser {
    func parseIdentifier(length: Int) -> String {
        let identifier = remains.prefix(length)
        advance(to: length)
        return String(identifier)
    }
    
}
extension Parser {
    func parseIdentifier() -> String? {
        guard let length = parseInt() else {
            return nil
        }
        return parseIdentifier(length: length)
    }
}

extension Parser {
    func parsePrefix() -> String {
        if !isSwiftSymbol(name: remains) {
            return remains
        }
        
        advance(to: Const.swiftSymbol.count)
        return remains
    }

}
extension Parser {
    func parseModule() -> String {
        let _ = parsePrefix()
        guard let identifier = parseIdentifier() else {
            fatalError()
        }
        return identifier
    }
}

extension Parser {
    func parseDeclName() -> String? {
        return parseIdentifier()
    }
}

extension Parser {
    func parseLabelList() -> [String] {
        var list: [String] = []
        while let label = parseIdentifier() {
            list.append(label)
        }
        return list
    }
}

extension Parser {
    func peek() -> String {
        return String(remains.prefix(1))
    }
}

extension Parser {
    func skip(length: Int) {
        advance(to: length)
    }
}

extension Parser {
    func isType() -> Bool {
        return "S" == peek()
    }
    
    func parseType() -> Type {
        var parsed: [Type] = []
        parsed.append(parseKnownType())
        
        switch peek() {
        case "_":
            break
        case _:
            return parsed.first!
        }
        
        skip(length: 1)
        
        while isType() {
            parsed.append(parseKnownType())
        }
        
        skip(length: 1)
        return Type.list(parsed)
    }
    
    func parseKnownType() -> Type {
        if !isType() {
            fatalError()
        }
        
        skip(length: 1)
        
        defer {
            skip(length: 1)
        }
        
        switch peek() {
        case "b":
            return .bool
        case "i":
            return .int
        case "S":
            return .string
        case "f":
            return .float
        case _:
            fatalError()
        }
    }
    
}

extension Parser {
    func parseFunctionSignature() -> FunctionSignature {
        return FunctionSignature(
            returnType: parseType(),
            argsType: parseType()
        )
    }
}


extension Parser {
    func parseFunctionEntity() -> FunctionEntity {
        return FunctionEntity(
            module: parseModule(),
            declName: parseDeclName()!,
            labelList: parseLabelList(),
            functionSignature: parseFunctionSignature()
        )
    }
}

extension Parser {
    func parse() -> FunctionEntity {
        let _ = self.parsePrefix()
        return self.parseFunctionEntity()
    }
}
