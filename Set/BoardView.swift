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
    
    // TODO: group all number into a struct, and may add methods at intermidate abstraction level
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var grid = Grid(layout: .aspectRatio(Layout.aspectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        
        for index in cardViews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.0,
                delay: TimeInterval(index) * 0.5,
                animations: {
                    self.cardViews[index].frame = grid[index]!.insetBy(dx: Layout.verticalInterCardDistance,
                                                                       dy: Layout.horizonalInterCardDistance)
                },
                completion: { _ in
                    UIView.transition(with: self.cardViews[index],
                                      duration: 0.4,
                                      options: [.transitionFlipFromLeft],
                                      animations: { self.cardViews[index].isFaceUp = true }
                    )
                }
            )

            cardViews[index].backgroundColor = .clear
            cardViews[index].isOpaque = false
        }
    }
    
    
    private struct Layout {
        static let aspectRatio: CGFloat = 0.7
        static let verticalInterCardDistance: CGFloat = 2.5
        static let horizonalInterCardDistance: CGFloat = 2.5
    }
}
