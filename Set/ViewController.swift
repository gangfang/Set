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
    var discardPileFrame: CGRect {
        return bottomStackView.convert(discardPileImage.frame, to: view)
    }
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var discardPileImage: UIImageView!
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
    @IBAction func tapDeckToDealThreeMoreCards(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            dealThreeMoreCards()
        default:
            break
        }
    }
    // TODO: fix, deal animation occurs where cards fly to spots previously occupied by matched cards
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
        updateDeckCountLabel()
    }
    

    private func updateCardViewsFromModel() {
        // TODO: refactor
        if boardView.cardViewsCount > setGame.cardsCount {
            boardView.cardViews = boardView.cardViews.filter { (cardView) -> Bool in
                return setGame.cardsOnTable.contains(where: { (setCard) -> Bool in
                    return cardView.colorInt == setCard.color.rawValue &&
                           cardView.fillingInt == setCard.shading.rawValue &&
                           cardView.symbolInt == setCard.symbol.rawValue &&
                           cardView.number == setCard.number.rawValue
                })
            }
        }
        
        let oldCardsCount = boardView.cardViewsCount
        
        for index in setGame.cardsOnTable.indices {
            let setCard = setGame.cardsOnTable[index]
            if index < oldCardsCount {
                let cardView = boardView.cardViews[index]
                updateCardView(cardView, for: setCard)
            } else {
                // TODO: make CardView initializer that create CardView with alpha of 0
                let cardView = CardView()   // should I use var?
                cardView.alpha = 0
                
                updateCardView(cardView, for: setCard)
                addTapGestureFor(cardView)
                
                boardView.cardViews.append(cardView)
            }
        }
        
        matchedCardsFlyAway()
        
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
            
            cardView.alpha = 0
            // refactor
            cardView.isFaceUp = false
            cardView.layer.borderColor = nil
            cardView.layer.borderWidth = 0.0
            cardView.layer.cornerRadius = 0.0
        } else {
            cardView.isMatched = false
        }
    }
    
    
    private func addTapGestureFor(_ cardView: CardView) {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(selectOrDeselectCard(byHandlingGestureRecognizedBy:)))
        cardView.addGestureRecognizer(tap)
    }
    
    
    private func matchedCardsFlyAway() {
        // guard fly away animation from initialization where all cards originate from point (0, 0)
        guard cardViewsToDeal.count > 0 && cardViewsToDeal[0].frame.size.width != 0 else { return }
        let cardViewsToFly = cardViewsToDeal.map { $0.duplicate() as! CardView }
        
        cardViewsToFly.forEach { (cardView) in
            view.addSubview(cardView)
            cardView.alpha = 1
            
            cardBehavior.addItem(cardView)
            collect(cardView)
        }
    }
    private func collect(_ cardView: UIView) {
        Timer.scheduledTimer(withTimeInterval: Constants.Duration.chaosFly, repeats: false) {_ in
            self.cardBehavior.removeItem(cardView)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Constants.Duration.flyToDiscardPile,
                delay: 0,
                animations: { cardView.frame = self.discardPileFrame },
                completion: nil
            )
        }
    }
    
    
    private func dealCardViews() {
        guard !setGame.currentlyAMatch && cardViewsToDeal.count > 0 else { return }
        var currentDealCardIndex = 0

        Timer.scheduledTimer(
            withTimeInterval: Constants.Duration.rearrange,
            repeats: false) { _ in
                for  cardView in self.cardViewsToDeal {
                    cardView.animateDeal(
                        from: self.deckFrame,
                        delay: Constants.dealCardIntervalFactor*TimeInterval(currentDealCardIndex)
                    )
                    currentDealCardIndex += 1
                }
            }
    }

    
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









extension UIView {
    func duplicate() -> UIView {
        let archive = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
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
