import Foundation

public func demangle(name: String) -> String {
    //TODO: implement
    return name
}

func isSwiftSymbol(name: String) -> Bool {
    return name.hasPrefix("$S")
}

func isFunctionEntitySpec(name: String) -> Bool {
    return name.hasSuffix("F")
}
