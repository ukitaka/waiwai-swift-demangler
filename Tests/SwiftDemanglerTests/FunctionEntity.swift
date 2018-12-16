//
//  FunctionEntity.swift
//  SwiftDemangler
//
//  Created by Yudai.Hirose on 2018/12/16.
//

import Foundation

struct FunctionEntity: Equatable {
    let module: String
    let declName: String
    let labelList: [String]
    let functionSignature: FunctionSignature
}
