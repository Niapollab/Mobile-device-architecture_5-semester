//
//  ViewController.swift
//  ConcentrationProduction
//
//  Created by Oleg E on 1/10/22.
//  Copyright © 2022 Oleg E. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var emoji = [Card: String]()
    var cardInputBlock = false
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    @IBOutlet weak var useTipButton: UIButton!
    private(set) var emojiChoices = "🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯"
    
    @IBAction func useTip(_ sender: UIButton) {
        if !game.isTipUsed {
            game.useTip()
            updateViewWithNoMatchedCardsFacedUp()
            cardInputBlock = true
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {timer in
                self.updateViewFromModel()
                self.cardInputBlock = false
                timer.invalidate()
            }
        }
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        updateViewFromModel()
        flipCount = 0
    }
    
    
    @IBAction func shuffleCards(_ sender: UIButton) {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if !cardInputBlock, let cardNumber = cardButtons.firstIndex(of: sender) {
            flipCount += game.isNeedIncreaseFlipCount(at: cardNumber) ? 1 : 0
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("no chosen card number")
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private func updateViewWithNoMatchedCardsFacedUp() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if !card.isMatched {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
            }
            
            if !game.isTipUsed {
                useTipButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            } else {
                useTipButton.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
    }
    
    private func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                }
            }
            
            if !game.isTipUsed {
                useTipButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            } else {
                useTipButton.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
