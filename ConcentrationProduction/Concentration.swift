import Foundation

enum PairCardsStates {
    case openedFirst
    case equalsCards
    case notEqualsCards
}

struct Concentration {
    private var cardsFactory: CardsFactoryProtocol = CardsFactory()
    private(set) var cards = [Card]()
    private(set) var isTipUsed = false
    
    mutating func useTip() {
        isTipUsed = true
    }
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        
        set(newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func getPairCardStatus(at index: Int)-> PairCardsStates {
        assert(cards.indices.contains(index), "Concentration.choosesCard(at: \(index)): chosen index not in the cards)")
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    return .equalsCards
                }
                else {
                    return .notEqualsCards
                }
            }
        }

        return .openedFirst
    }
    
    mutating func shuffleCards() {
        cards.shuffle()
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.choosesCard(at: \(index)): chosen index not in the cards)")
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")

        cards = cardsFactory.build(numberOfPairsOfCards: numberOfPairsOfCards)
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
