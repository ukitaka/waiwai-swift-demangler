import Foundation

class Parser {
    private let name: String
    private var index: String.Index
    
    init(name: String) {
        self.name = name
        self.index = name.startIndex
    }
    
    var remains: String { return String(name[index...]) }
    
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
    
    func parseIdentifier(length: Int) -> String {
        let remains = self.remains
        self.index = self.name.index(self.index, offsetBy: length)
        return String(remains.prefix(length))
    }
    
    func parseIdentifier() -> String? {
        guard let lengh = self.parseInt() else {
            return nil
        }
        return parseIdentifier(length: lengh)
    }
}
