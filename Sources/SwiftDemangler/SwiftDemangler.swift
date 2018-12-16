
public func isSwiftSymbol(name: String) -> Bool {
    return name.prefix(2) == "$0"
}

public func isFunctionEntitySpec(name: String) -> Bool {
    return name.suffix(1) == "F"
}

public func demangle(name: String) -> String {
    return name //TODO: implement
}
