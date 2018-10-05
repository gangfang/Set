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
        
        var grid = Grid(layout: .aspectRatio(Layout.aspectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        
        for index in cardViews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Animation.flyDuration,
                delay: Animation.delayFactor * TimeInterval(index),
                animations: {
                    self.cardViews[index].frame = grid[index]!.insetBy(dx: Layout.spacingDx,
                                                                       dy: Layout.spacingDy)
                }
            )
            cardViews[index].backgroundColor = .clear
            cardViews[index].isOpaque = false
        }
    }
    
    
    
    
    private struct Layout {
        static let aspectRatio: CGFloat = 0.7
        static let spacingDx: CGFloat = 2.5
        static let spacingDy: CGFloat = 2.5
    }
    private struct Animation {
        static let flyDuration: TimeInterval = 0.8
        static let delayFactor: Double = 0.2
    }
}















