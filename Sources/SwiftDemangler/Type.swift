//
//  Type.swift
//  SwiftDemangler
//
//  Created by Yudai.Hirose on 2018/12/16.
//

import Foundation

enum Type: Equatable {
    case bool
    case int
    case string
    case float
    indirect case list([Type])
    
    static func == (lhs: Type, rhs: Type) -> Bool {
        switch (lhs, rhs) {
        case (.bool,.bool),
             (.int,.int),
             (.string,.string),
             (.float,.float):
            
            return true
        case (.list(let lList), .list(let rList)):
            if lList.count != rList.count {
                return false
            }
            
            for (l, r) in zip(lList, rList) {
                if l != r {
                    return false
                }
            }
            return true
        case _:
            return false
        }
    }
    
}

//func
//init?(sign: String) {
//    switch sign {
//    case "b":
//        return .bool
//    case "i":
//        return .int
//    case "t"
//        self =
//    }
//}
