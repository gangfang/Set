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
    let colorChoices: [UIColor] = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)]
    let shadingChoices: [(alpha: CGFloat, strokeWidth: CGFloat)] = [(1, 3), (0.4, 0), (1, 0)]
    let symbolChoices = ["▲", "●", "■"]
    
    
    @IBOutlet weak var boardView: BoardView!
    
    //TODO: remove stub below
    var cardButtons = [UIButton]()
    @IBOutlet weak var dealThreeMoreCardsButton: UIButton! {
        didSet {
            dealThreeMoreCardsButton.layer.borderWidth = 3.0
            dealThreeMoreCardsButton.layer.borderColor = UIColor(rgb: 0x8DFA00).cgColor
            dealThreeMoreCardsButton.layer.cornerRadius = 8.0
            dealThreeMoreCardsButton.setTitleColor(UIColor(rgb: 0x8DFA00), for: .normal)
        }
    }
    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            newGameButton.layer.borderWidth = 3.0
            newGameButton.layer.borderColor = UIColor(rgb: 0x8DFA00).cgColor
            newGameButton.layer.cornerRadius = 8.0
            newGameButton.setTitleColor(UIColor(rgb: 0x8DFA00), for: .normal)
        }
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            if cardNumber < setGame.cardsOnTable.count {
                setGame.touchACard(at: cardNumber)
                updateViewFromModel()
            }
        }
    }
    @IBAction func pressNewGameButton(_ sender: UIButton) {
        setGame = SetGame()
        updateViewFromModel()
    }
    @IBAction func pressDealThreeMoreCardsButton(_ sender: UIButton) {
        setGame.dealThreeMoreCards()
        updateViewFromModel()
    }
    
    
    private func updateViewFromModel() {
        updateCardsFromModel()
        updateSelectedCardsFromModel()
        configureDealThreeMoreCardsButtonClickability()
    }
    
    
    private func updateCardsFromModel() {
        boardView.cardViews = setGame.cardsOnTable.map { _ in CardView() }
    }
    
    
    private func updateSelectedCardsFromModel() {
        for selectedCard in setGame.selectedCards {
            if let matchedCardIndex = setGame.cardsOnTable.index(of: selectedCard) {
                let button = cardButtons[matchedCardIndex]
                button.layer.borderWidth = 3.0
                button.layer.borderColor = UIColor.orange.cgColor
                
                if setGame.currentlyAMatch {
                    button.backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    
    
    private func configureDealThreeMoreCardsButtonClickability() {
        if setGame.deck.cardsCount == 0 {
            dealThreeMoreCardsButton.isEnabled = false
        } else {
            dealThreeMoreCardsButton.isEnabled = true
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        view.backgroundColor = UIColor(rgb: 0x009051)
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
