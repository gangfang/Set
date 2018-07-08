//
//  SetCard.swift
//  Set
//
//  Created by GANG_FANG on 2018/6/26.
//  Copyright © 2018 gfang. All rights reserved.
//

import Foundation

// According to Clean Code, this is a typical example of data strucutre
struct SetCard: Equatable {
    
    let number: Variant
    let symbol: Variant
    let shading: Variant
    let color: Variant
    
    
    // NOTE: after refactoring,
    // Variant replaces the previous 4 enums (Number, Symbol, Shading, Color) at once
    enum Variant: Int {
        case v1 = 1
        case v2
        case v3
        
        static var all: [Variant] = [.v1, .v2, .v3]
        var idx: Int {return (self.rawValue - 1)}
    }
}


extension SetCard: CustomStringConvertible {
    var description: String {
        return "Number: \(number), Symbol: \(symbol), Shading: \(shading), Color: \(color)"
    }
}
