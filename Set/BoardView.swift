//
//  BoardView.swift
//  Set
//
//  Created by GANG_FANG on 2018/8/2.
//  Copyright © 2018 gfang. All rights reserved.
//

import UIKit

class BoardView: UIView {

    var cardViews = [CardView]() {
        willSet {
            removeSubviews()
        }
        didSet {
            addSubviews()
            setNeedsLayout()
        }
    }
    var cardViewsCount: Int {
        return cardViews.count
    }
    
    
    private func removeSubviews() {
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
    }
    
    private func addSubviews() {
        for cardView in cardViews {
            addSubview(cardView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var grid = Grid(layout: .aspectRatio(Constants.GridLayout.aspectRatio), frame: bounds)
        grid.cellCount = cardViewsCount
        
        for index in cardViews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Constants.Duration.rearrange,
                delay: 0,
                animations: {
                    self.cardViews[index].frame = grid[index]!.insetBy(dx: Constants.GridLayout.spacingDx,
                                                                       dy: Constants.GridLayout.spacingDy)
                }
            )
            cardViews[index].backgroundColor = .clear
            cardViews[index].isOpaque = false
        }
    }
}















