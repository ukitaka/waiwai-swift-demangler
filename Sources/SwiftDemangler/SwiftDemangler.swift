public func demangle(name: String) -> String {
    return name
}

class Parser {
    private let name: String
    private var index: String.Index
    
    var remains: String { return String(name[index...]) }
    
    init(name: String) {
        self.name = name
        self.index = name.startIndex
    }
    
    func parseInt() -> Int? {
        let remains = self.remains
        
        if let i = Int(remains) {
            self.index = name.endIndex
            return i
        }
        let decimalDigits = "0123456789"
        guard let index = remains.firstIndex(where: { c in !decimalDigits.contains(c) }) else {
            return nil
        }
        guard let int = Int(remains.prefix(upTo: index)) else {
            return nil
        }
        self.index = self.name.index(self.index, offsetBy: int / 10 + 1)
        return int
    }
}
