import Foundation

struct Card : Hashable {
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs:Card,rhs:Card) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    static func resetIdentifierFactory() {
        identifierFactory = 0;
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
