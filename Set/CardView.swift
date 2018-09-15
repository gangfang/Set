//
//  CardView.swift
//  Set
//
//  Created by GANG_FANG on 2018/8/4.
//  Copyright © 2018 gfang. All rights reserved.
//

import UIKit

class CardView: UIView {

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        UIColor.blue.setFill()
        roundedRect.fill()
    }
 

}
