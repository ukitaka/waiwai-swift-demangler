//
//  CommandIO.swift
//  SwiftDemangler
//
//  Created by Yudai.Hirose on 2018/12/16.
//

import Foundation

struct Printer {
    let parser: Parser
    init(parser: Parser) {
        self.parser = parser
    }
    
    func output() -> String {
        var output = parser.whole
        output += " ---> "
        let parsed = parser.parse()
        output += parsed.module + "." + parsed.declName + "("
        
        let argType = parsed.functionSignature.argsType
        let types: [Type]
        switch parsed.functionSignature.argsType {
        case .bool, .int, .string, .float:
            types = [argType]
        case .list(let l):
            types = l
        }
        
        zip(types, parsed.labelList).enumerated().forEach { offset, elements in
            let argTypeName = typeName(type: elements.0)
            let label = elements.1
            switch offset {
            case 0:
                output += label + ": " + argTypeName
            case _:
                output += ", " + label + ": " + argTypeName
            }
        }

        output += ")"
        
        let retType = typeName(type: parsed.functionSignature.returnType)
        
        output += " -> " + retType
        return output
    }
    
    func typeName(type: Type)  -> String {
        switch type {
        case .bool:
            return "Swift.Bool"
        case .int:
            return "Swift.Int"
        case .string:
            return "Swift.String"
        case .float:
            return "Swift.Float"
        case .list:
            fatalError()
        }
    }
}
