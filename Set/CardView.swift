//
//  CardView.swift
//  Set
//
//  Created by GANG_FANG on 2018/8/4.
//  Copyright © 2018 gfang. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    var isSelected = false { didSet {setNeedsDisplay()} }
    var isMatched = false { didSet {setNeedsDisplay()} }
    
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
            case 1: color = Colors.green
            case 2: color = Colors.red
            case 3: color = Colors.purple
            default: break
            }
        }
    }
    
    @IBInspectable
    var number: Int = 1 {
        didSet { setNeedsDisplay() }
    }
    
    private var symbol: Symbol = .squiggle { didSet {setNeedsDisplay()} }
    private var filling: Filling = .striped { didSet {setNeedsDisplay()} }
    private var color: UIColor = Colors.green { didSet {setNeedsDisplay()} }
    
    
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
        
        static let background = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        static let selected = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        static let matched = #colorLiteral(red: 0.07450980392, green: 0.5568627451, blue: 0.3254901961, alpha: 0.2462007705)
    }
    
    
    
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height * SizeRatio.cornerRadiusToBoundsHeight)
        Colors.background.setFill()
        roundedRect.fill()
        
        layer.borderColor = nil
        layer.borderWidth = 0.0
        layer.cornerRadius = 0.0
        if isSelected && !isMatched {
            layer.borderColor = Colors.selected.cgColor
            layer.borderWidth = bounds.height * SizeRatio.borderWidthToBoundsHeight
            layer.cornerRadius = bounds.height * SizeRatio.cornerRadiusToBoundsHeight
        }
        if isMatched {
            Colors.matched.setFill()
            roundedRect.fill()
        }
        
        drawPips()
    }
    
    private func drawPips() {
        color.setFill()
        color.setStroke()
        
        let origin = CGPoint(x: faceFrame.minX, y: faceFrame.midY - pipHeight/2)
        let size = CGSize(width: faceFrame.width, height: pipHeight)
        let rectPip = CGRect(origin: origin, size: size)
        
        switch number {
        case 1:
            drawShape(in: rectPip)
        case 2:
            let firstRect: CGRect = rectPip.offsetBy(dx: 0, dy: -(pipHeight+interPipHeight)/2)
            drawShape(in: firstRect)
            let secondRect: CGRect = rectPip.offsetBy(dx: 0, dy: (pipHeight+interPipHeight)/2)
            drawShape(in: secondRect)
        case 3:
            drawShape(in: rectPip)
            let secondRect: CGRect = rectPip.offsetBy(dx: 0, dy: -(pipHeight+interPipHeight))
            drawShape(in: secondRect)
            let thirdRect: CGRect = rectPip.offsetBy(dx: 0, dy: (pipHeight+interPipHeight))
            drawShape(in: thirdRect)
        default:
            break
        }
    }
    
    
    private func drawShape(in rect: CGRect) {
        let path: UIBezierPath
        
        switch symbol {
        case .diamond:
            path = pathForDiamond(in: rect)
        case .squiggle:
            path = pathForSquiggle(in: rect)
        case .oval:
            path = pathForOval(in: rect)
        }
        
        path.lineWidth = bounds.height * SizeRatio.pathLineWidthToBoundsHeight
        path.stroke()
        
        switch filling {
        case .solid:
            path.fill()
        case .striped:
            stripePath(path: path, rect: rect)
        default:
            break
        }
    }
    
    
    private func pathForDiamond(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.close()
        return path
    }
    
    private func pathForSquiggle(in rect: CGRect) -> UIBezierPath {
        let upperSquiggle = UIBezierPath()
        let sqdx = rect.width * 0.1
        let sqdy = rect.height * 0.2
        upperSquiggle.move(to: CGPoint(x: rect.minX, y: rect.midY))
        upperSquiggle.addCurve(to: CGPoint(x: rect.minX + rect.width * 1/2,
                                           y: rect.minY + rect.height / 8),
                               controlPoint1: CGPoint(x: rect.minX,
                                                      y: rect.minY),
                               controlPoint2: CGPoint(x: rect.minX + rect.width * 1/2 - sqdx,
                                                      y: rect.minY + rect.height / 8 - sqdy))
        upperSquiggle.addCurve(to: CGPoint(x: rect.minX + rect.width * 4/5,
                                           y: rect.minY + rect.height / 8),
                               controlPoint1: CGPoint(x: rect.minX + rect.width * 1/2 + sqdx,
                                                      y: rect.minY + rect.height / 8 + sqdy),
                               controlPoint2: CGPoint(x: rect.minX + rect.width * 4/5 - sqdx,
                                                      y: rect.minY + rect.height / 8 + sqdy))
        upperSquiggle.addCurve(to: CGPoint(x: rect.minX + rect.width,
                                           y: rect.minY + rect.height / 2),
                               controlPoint1: CGPoint(x: rect.minX + rect.width * 4/5 + sqdx,
                                                      y: rect.minY + rect.height / 8 - sqdy ),
                               controlPoint2: CGPoint(x: rect.minX + rect.width,
                                                      y: rect.minY))
        let lowerSquiggle = UIBezierPath(cgPath: upperSquiggle.cgPath)
        lowerSquiggle.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
        lowerSquiggle.apply(CGAffineTransform.identity.translatedBy(x: bounds.width, y: bounds.height))
        upperSquiggle.move(to: CGPoint(x: rect.minX, y: rect.midY))
        upperSquiggle.append(lowerSquiggle)
        return upperSquiggle
    }
    
    private func pathForOval(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let radius = rect.height / 2
        path.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: 0.5*CGFloat.pi,
                    endAngle: 1.5*CGFloat.pi,
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                    radius: radius,
                    startAngle: 1.5*CGFloat.pi,
                    endAngle: 0.5*CGFloat.pi,
                    clockwise: true)
        path.close()
        return path
    }
    
    private func stripePath(path: UIBezierPath, rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        stripeRect(rect)
        context?.restoreGState()
    }
    
    private func stripeRect(_ rect: CGRect) {
        let stripe = UIBezierPath()
        let dashes: [CGFloat] = [1, 4]
        stripe.setLineDash(dashes, count: dashes.count, phase: 0.0)
        stripe.lineWidth = bounds.height
        stripe.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        stripe.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        stripe.stroke()
    }
    
    
    
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.1
        static let borderWidthToBoundsHeight: CGFloat = 0.035
        static let maxFaceSizeToBoundsSize: CGFloat = 0.75
        static let pathLineWidthToBoundsHeight: CGFloat = 0.015
        static let pipHeightToFaceHeight: CGFloat = 0.25
    }
    
    
    private struct AspectRatio {
        static let faceFrame: CGFloat = 0.6
    }
    
    
    private var maxFaceFrame: CGRect {
        return bounds.zoomed(by: SizeRatio.maxFaceSizeToBoundsSize)
    }
    
    private var faceFrame: CGRect {
        let faceWidth = maxFaceFrame.height * AspectRatio.faceFrame
        return maxFaceFrame.insetBy(dx: (maxFaceFrame.width-faceWidth) / 2, dy: 0)
    }
    
    private var pipHeight: CGFloat {
        return faceFrame.height * SizeRatio.pipHeightToFaceHeight
    }
    
    private var interPipHeight: CGFloat {
        return (faceFrame.height - 3 * pipHeight) / 2
    }
}







extension CGRect {
    func zoomed(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width-newWidth)/2, dy: (height-newHeight)/2)
    }
}









