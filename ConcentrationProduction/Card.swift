import Foundation

struct Card : Hashable {
    var isFaceUp = false
    
    var isMatched = false

    private var identifier: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs:Card, rhs:Card) -> Bool {
        lhs.identifier == rhs.identifier
    }

    init(identifier: Int) {
        self.identifier = identifier
    }
}
