import Foundation

class Parser {
    private let name: String
    private var index: String.Index
    
    init(name: String) {
        self.name = name
        self.index = name.startIndex
    }
    
    var remains: String { return String(name[index...]) }
}

// MARK: - Step2

extension Parser {
    func parseInt() -> Int? {
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
}

extension Parser {
    func parseIdentifier(length: Int) -> String {
        let remains = self.remains
        self.index = self.name.index(self.index, offsetBy: length)
        return String(remains.prefix(length))
    }
}

extension Parser {
    func parseIdentifier() -> String? {
        guard let lengh = self.parseInt() else {
            return nil
        }
        return parseIdentifier(length: lengh)
    }
}

// MARK: - Step3

extension Parser {
    func parsePrefix() -> String {
        guard name.hasPrefix("$S") else {
            fatalError()
        }
        self.index = self.name.index(self.index, offsetBy: 2)
        return "$S"
    }
    
    func parseModule() -> String {
        return parseIdentifier()!
    }
}

// MARK: - Step4

extension Parser {
    func parseDeclName() -> String {
        return parseIdentifier()!
    }
}

extension Parser {
    func parseLabelList() -> [String] {
        var list: [String] = []
        while let label = self.parseIdentifier() {
            list.append(label)
        }
        return list
    }
}
