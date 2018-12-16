
public struct Const {
    static let swiftSymbol = "$S"
}

public func isSwiftSymbol(name: String) -> Bool {
    return name.prefix(2) == Const.swiftSymbol
}

public func isFunctionEntitySpec(name: String) -> Bool {
    return name.suffix(1) == "F"
}

public func demangle(name: String) -> String {
    return name //TODO: implement
}
