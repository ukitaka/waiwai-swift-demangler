public func demangle(name: String) -> String {
    //TODO: implement
    return name
}

func isSwiftSymbol(name: String) -> Bool {
    return name.hasPrefix("$S")
}
