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

func parseInt(name: String) -> Int? {
    if let int = Int(name) {
        return int
    }
    let decimalDigits = "0123456789"
    guard let index = name.firstIndex(where: { c in !decimalDigits.contains(c) }) else {
        return nil
    }
    let int = name.prefix(upTo: index)
    return Int(int)
}
