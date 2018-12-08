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

// MARK: - Scanner

class Scanner {
    private let name: String
    private var index: String.Index

    init(name: String) {
        self.name = name
        self.index = name.startIndex
    }
    
    var remains: String { return String(name[index...]) }
    
    func nextInt() -> Int? {
        let remains = self.remains
        if let int = Int(remains) {
            self.index = name.endIndex
            return int
        }
        let decimalDigits = "0123456789"
        guard let index = remains.firstIndex(where: { c in !decimalDigits.contains(c) }) else {
            return nil
        }
        guard let int = Int(remains.prefix(upTo: index)) else {
            return nil
        }
        self.index = self.name.index(self.index, offsetBy: (int / 10) + 1)
        return int
    }
    
    func nextIdentifier(length: Int) -> String {
        let remains = self.remains
        self.index = self.name.index(self.index, offsetBy: length)
        return String(remains.prefix(length))
    }

    func nextIdentifier() -> String? {
        guard let lengh = self.nextInt() else {
            return nil
        }
        return nextIdentifier(length: lengh)
    }
}
