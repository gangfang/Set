//
//  ControlButton.swift
//  Set
//
//  Created by GANG_FANG on 2018/9/28.
//  Copyright © 2018 gfang. All rights reserved.
//

import UIKit

@IBDesignable
class ControlButton: UIButton {

    override func draw(_ rect: CGRect) {
        setTitleColor(UIColor(rgb: 0x8DFA00), for: .normal)
        setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .disabled)
        
        layer.borderWidth = 3.0
        layer.cornerRadius = 8.0
        alterBorderColor()
    }

    
    
    private func alterBorderColor() {
        if isEnabled {
            layer.borderColor = UIColor(rgb: 0x8DFA00).cgColor
        } else {
            layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        layer.borderColor = #colorLiteral(red: 0.1882352941, green: 0.6039215686, blue: 0.262745098, alpha: 1).cgColor
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        layer.borderColor = UIColor(rgb: 0x8DFA00).cgColor
    }
}
