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
        
        var grid = Grid(layout: .aspectRatio(0.7), frame: bounds)
        grid.cellCount = cardViews.count
        
        for index in cardViews.indices {
            cardViews[index].frame = grid[index]!.insetBy(dx: 2.0, dy: 2.0)
        }
    }
}
