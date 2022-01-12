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
    
    private var pointsManager = PointsManager(canBeLessZero: true)
    
    override func viewDidLoad() {
        rebuildView()
        updateViewFromModel()
    }
    
    var emoji = [Card: String]()
    private var cardInputBlock = false
    
    @IBOutlet private weak var cardsStack: UIStackView!
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private func updatePointsCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Points: \(pointsManager.points)", attributes: attributes)
        scoreCountLabel.attributedText = attributedString
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var totalEmojis = 12
    
    var difficulty: String? {
        didSet {
            switch difficulty {
            case "Easy":
                totalEmojis = 8
            case "Medium":
                totalEmojis = 12
            case "Hard":
                totalEmojis = 24
            default:
                totalEmojis = 12
                print("Unknown difficulty, totalEmojis was set to 12")
            }
            print(totalEmojis)
            rebuildGameWithNewDifficulty()
        }
    }
    
    private func rebuildView() {
        cardButtons.removeAll()
        
        var rows: Int
        if difficulty == "Easy" {
            rows = 2
        } else {
            //UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
            //UIApplication.shared.statusBarOrientation.isLandscape
            if UIDevice.current.orientation.isValidInterfaceOrientation ? UIDevice.current.orientation.isLandscape :
                UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false {
                print("on rebuild state: landscape")
                rows = Int(totalEmojis / 6)
            } else {
                print("on rebuildstate: portrait")
                rows = Int(totalEmojis / 4)
            }
        }
        let cols = Int(totalEmojis / rows)
        print("New config: cols: \(cols), rows: \(rows)")
        cardsStack.arrangedSubviews.forEach {view in
            cardsStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        var fontSize: CGFloat
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            fontSize = 50
        } else {
            switch difficulty {
            case "Easy":
                fontSize = 48
            case "Medium":
                fontSize = 40
            default:
                fontSize = 30
            }
        }
        
        for _ in 1...rows {
            let newStack = UIStackView()
            newStack.distribution = UIStackView.Distribution.fillEqually
            newStack.spacing = 5
            for _ in 1...cols {
                let button = UIButton()
                button.addTarget(self, action: #selector(touchCard), for: .touchUpInside)
                
                button.titleLabel?.font = .systemFont(ofSize: fontSize)
                cardButtons.append(button)
                newStack.addArrangedSubview(button)
            }
            cardsStack.addArrangedSubview(newStack)
        }
    }
    
    private func rebuildGameWithNewDifficulty() {
        if cardButtons != nil {
            rebuildView()
            restartGame()
            updateViewFromModel()
        }
    }
    
    @IBOutlet private weak var useTipButton: UIButton!
    private(set) var emojiChoices = "🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🐥🐴"
    
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
    
    private func restartGame () {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        updateViewFromModel()
        pointsManager = PointsManager(canBeLessZero: true)
        updatePointsCountLabel()
    }
    
    @IBAction private func touchRestart(_ sender: UIButton) {
        restartGame()
    }
    
    
    @IBAction private func shuffleCards(_ sender: UIButton) {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if !cardInputBlock, let cardNumber = cardButtons.firstIndex(of: sender) {
            if game.isNeedIncreaseFlipCount(at: cardNumber) {
                switch game.getPairCardStatus(at: cardNumber) {
                    case .equalsCards:
                        pointsManager.add()
                        updatePointsCountLabel()
                    case .notEqualsCards:
                        pointsManager.remove()
                        updatePointsCountLabel()
                    default: ()
                }
            }
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
    
    @IBOutlet private weak var scoreCountLabel: UILabel! {
        didSet {
            updatePointsCountLabel()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if cardButtons != nil {
            rebuildView()
            updateViewFromModel()
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
