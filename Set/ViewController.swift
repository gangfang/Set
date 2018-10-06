//
//  ViewController.swift
//  Set
//
//  Created by GANG_FANG on 2018/6/25.
//  Copyright © 2018 gfang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var setGame = SetGame()
    var cardViewsToDeal: [CardView] {
        return boardView.cardViews.filter { $0.alpha == 0 }
    }
    var deckFrame: CGRect {
        return bottomStackView.convert(deckImage.frame, to: boardView)
    }
    
    @IBOutlet weak var boardView: BoardView!
//    @IBOutlet weak var dealThreeMoreCardsButton: UIButton!
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var deckCountLabel: UILabel!
    
    
    // MARK: UI events
    @IBAction func rotateToReshuffleCards(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            reshuffleCards()
        default:
            break
        }
    }
    @IBAction func swipeToDealThreeMoreCards(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            dealThreeMoreCards()
        default:
            break
        }
    }
//    @IBAction func pressDealThreeMoreCardsButton(_ sender: UIButton) {
//        dealThreeMoreCards()
//    }
    @IBAction func pressNewGameButton(_ sender: UIButton) {
        setGame = SetGame()
        updateViewFromModel()
    }
    @objc func selectOrDeselectCard(byHandlingGestureRecognizedBy recognizer: UITapGestureRecognizer) {
        if let card = recognizer.view as? CardView, let cardNumber = boardView.cardViews.index(of: card) {
            setGame.touchACard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    
    private func reshuffleCards() {
        setGame.reshuffleCards()
        updateViewFromModel()
    }
    
    
    private func dealThreeMoreCards() {
        setGame.dealThreeMoreCards()
        updateViewFromModel()
    }
    
    
    private func updateViewFromModel() {
        updateCardViewsFromModel()
//        configureDealThreeMoreCardsButtonClickability()
        updateDeckCountLabel()
    }
    

    private func updateCardViewsFromModel() {
        if boardView.cardViewsCount > setGame.cardsCount {
            boardView.cardViews = Array(boardView.cardViews[..<setGame.cardsCount])
        }
        
        let oldCardsCount = boardView.cardViewsCount
        
        for index in setGame.cardsOnTable.indices {
            let setCard = setGame.cardsOnTable[index]
            if index < oldCardsCount {
                let cardView = boardView.cardViews[index]
                updateCardView(cardView, for: setCard)
            } else {
                let cardView = CardView()   // should I use var?
                
                updateCardView(cardView, for: setCard)
                addTapGestureFor(cardView)
                cardView.alpha = 0
                boardView.cardViews.append(cardView)
            }
        }
        
        // fly away animation
        
        dealCardViews()
    }
    

    private func updateCardView(_ cardView: CardView, for setCard: SetCard) {
        cardView.symbolInt = setCard.symbol.rawValue
        cardView.fillingInt = setCard.shading.rawValue
        cardView.colorInt = setCard.color.rawValue
        cardView.number = setCard.number.rawValue
        
        cardView.isSelected = setGame.selectedCards.contains(setCard)
        if setGame.currentlyAMatch && cardView.isSelected {
            cardView.isMatched = true
        } else {
            cardView.isMatched = false
        }
    }
    
    
    private func addTapGestureFor(_ cardView: CardView) {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(selectOrDeselectCard(byHandlingGestureRecognizedBy:)))
        cardView.addGestureRecognizer(tap)
    }

    
    private func dealCardViews() {
        var currentDealCard = 0
        
        Timer.scheduledTimer(
            withTimeInterval: BoardView.Animation.flyDuration,
            repeats: false) { _ in
                for  cardView in self.cardViewsToDeal {
                    cardView.animateDeal(from: self.deckFrame,
                                         delay: 0.2*TimeInterval(currentDealCard))
                    currentDealCard += 1
                }
            }
    }
    
    
//    private func configureDealThreeMoreCardsButtonClickability() {
//        if setGame.deck.cardsCount == 0 {
//            dealThreeMoreCardsButton.isEnabled = false
//        } else {
//            dealThreeMoreCardsButton.isEnabled = true
//        }
//    }

    
    private func updateDeckCountLabel() {
        deckCountLabel.text = "Deck: \(setGame.deck.cardsCount)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        
        boardView.backgroundColor = .clear
        boardView.isOpaque = false
    }
}





extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
