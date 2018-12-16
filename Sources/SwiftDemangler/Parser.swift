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
        index = String.Index(encodedOffset: offset)
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
        
        advance(to: currentOffset + str.count)
        return Int(str)
    }
}

extension Parser {
    func parseIdentifier(length: Int) -> String {
        let identifier = remains.prefix(length)
        advance(to: currentOffset + length)
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

