//
//  Parser.swift
//  SwiftDemangler
//
//  Created by Yudai.Hirose on 2018/12/16.
//

import Foundation

class Parser {
    private let whole: String
    private var index: String.Index
    
    var remains: String {
        return String(whole[index...])
    }
    
    init(name: String) {
        self.whole = name
        self.index = whole.startIndex
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
        for (offset, character) in remains.enumerated() {
            if character.asInt() == nil {
                break
            }
            index = String.Index(encodedOffset: offset + 1)
            str.append(character)
        }
        
        return Int(str)
    }
}
