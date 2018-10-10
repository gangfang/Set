//
//  Constants.swift
//  Set
//
//  Created by GANG_FANG on 2018/10/10.
//  Copyright © 2018 gfang. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    // MARK: Constants for animation
    struct FlyAwayCard {
        static let elasticity: CGFloat = 0.7
        static let resistance: CGFloat = 0.2
        static let pushAngleRandom: CGFloat = (2 * CGFloat.pi).arc4random
        static let pushMagnitudeRandom: CGFloat = CGFloat(50.0) + CGFloat(50.0).arc4random
    }
    
    struct Duration {
        static let rearrange: TimeInterval = 0.8
        static let chaosFly: TimeInterval = 0.5
        static let flyToDiscardPile: TimeInterval = 0.2
        static let flyFromDeck: TimeInterval = 0.1
        static let flip: TimeInterval = 0.1
        
    }
    
    static let dealCardIntervalFactor: Double = 0.2
    
    
    // MARK: Constants for view and drawing
    struct GridLayout {
        static let aspectRatio: CGFloat = 0.7
        static let spacingDx: CGFloat = 2.5
        static let spacingDy: CGFloat = 2.5
    }
    
    struct CardSizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.1
        static let borderWidthToBoundsHeight: CGFloat = 0.035
        static let maxFaceSizeToBoundsSize: CGFloat = 0.75
        static let pathLineWidthToBoundsHeight: CGFloat = 0.015
        static let pipHeightToFaceHeight: CGFloat = 0.25
    }
    
    struct CardAspectRatio {
        static let faceFrame: CGFloat = 0.6
    }
}





extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
