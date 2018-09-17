//
//  CardView.swift
//  Set
//
//  Created by GANG_FANG on 2018/8/4.
//  Copyright © 2018 gfang. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    @IBInspectable
    var symbolInt: Int = 1 {
        didSet {
            switch symbolInt {
            case 1: symbol = .squiggle
            case 2: symbol = .oval
            case 3: symbol = .diamond
            default: break
            }
        }
    }
    
    @IBInspectable
    var fillingInt: Int = 1 {
        didSet {
            switch fillingInt {
            case 1: filling = .unfilled
            case 2: filling = .striped
            case 3: filling = .solid
            default: break
            }
        }
    }
    
    @IBInspectable
    var colorInt: Int = 1 {
        didSet {
            switch colorInt {
            case 1: color = .green
            case 2: color = .red
            case 3: color = .purple
            default: break
            }
        }
    }
    
    @IBInspectable
    var number: Int = 1 {
        didSet { setNeedsDisplay() }
    }
    
    private var symbol: Symbol! { didSet {setNeedsDisplay()} }
    private var filling: Filling! { didSet {setNeedsDisplay()} }
    private var color: UIColor! { didSet {setNeedsDisplay()} }
    
    
    private enum Symbol: Int {
        case diamond
        case squiggle
        case oval
    }
    
    private enum Filling: Int {
        case unfilled
        case striped
        case solid
    }
    
    private struct Colors {
        static let green = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        static let red = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        static let purple = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        
        static let selected = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1).cgColor
    }
    
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        UIColor.blue.setFill()
        roundedRect.fill()
    }
 

}
