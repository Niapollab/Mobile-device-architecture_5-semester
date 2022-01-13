import Foundation

protocol CardsFactoryProtocol {
    func build(numberOfPairsOfCards: Int) -> [Card]
}

class CardsFactory : CardsFactoryProtocol {

    func build(numberOfPairsOfCards: Int) -> [Card] {
        var currentIdentifier: Int = 0

        var cards = [Card]()
        for _ in 1...numberOfPairsOfCards {
            let card = Card(identifier: currentIdentifier)
            cards += [card, card]
            currentIdentifier += 1
        }

        return cards
    }

}