
//
//  RandomLines.swift
//  Fractals
//
//  Created by Garcia, David on 5/7/19.
//  Copyright © 2019 Ayy Lmao LLC. All rights reserved.
//

import Cocoa

class RandomLines: NSView {

    let fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    let num:Int = Int(2e3)
    let size: Int = 1100
    var g = SystemRandomNumberGenerator()
    var range : ClosedRange<Int>?
    var coord: [CGPoint]?

    //: Create Stars
    var stars: [CAShapeLayer]?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    required init?(coder decoder: NSCoder) {
        range = (0...num)
        super.init(coder: decoder)
        wantsLayer = true
    }
    
    override init(frame frameRect: NSRect) {
        range = (0...num)
        super.init(frame: frameRect)
        wantsLayer = true
    }
    
    func random() -> CGFloat{
        return CGFloat.random(in: 0...CGFloat(frame.size.width), using: &g)
    }
    
    func randPoints() -> [CGPoint]{
        return range?.flatMap{(_:Int) in
            return CGPoint(x: random(), y: random())
            } as! [CGPoint]
    }
    
    override func awakeFromNib() {
        drawLines()
    }
    
    func drawLines(){
        coord = randPoints()
        var path = CGMutablePath()
        path.addLines(between: coord!)
        
        
        var shapeLayer = CAShapeLayer()
        shapeLayer.fillRule = .nonZero
        shapeLayer.path = path
        let color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        stars = coord!.map{ (point:CGPoint) in
            let rect = NSRect(x: point.x/2, y: point.y/2, width: 4, height: 4)
            let star = CGPath(ellipseIn: rect, transform: nil)
            let starLayer = CAShapeLayer()
            starLayer.frame = rect
            starLayer.path = star
            shapeLayer.addSublayer(starLayer)
            return starLayer
        }
        
        stars?.forEach{$0.fillColor = NSColor.white.cgColor}
        
        //: Stroke Animation
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0
        anim.toValue = 1
        anim.autoreverses = true
        anim.repeatCount = .greatestFiniteMagnitude
        anim.duration = 120.0
        
        shapeLayer.add(anim, forKey: "pathAnimation")
        
        
        //: Change Stroke Color
        let strokeColor = CAKeyframeAnimation(keyPath: "strokeColor")
        strokeColor.values = [NSColor.red.cgColor,
                              NSColor.green.cgColor,
                              NSColor.blue.cgColor]
        strokeColor.keyTimes = [0, 0.5, 1]
        strokeColor.duration = 5
        strokeColor.autoreverses = true
        strokeColor.repeatCount = .greatestFiniteMagnitude
        shapeLayer.add(strokeColor, forKey: "strokeColorAnimation")
        
        
        //: Color Changing Animation
        let colorChange = CABasicAnimation(keyPath: "fillColor")
        colorChange.toValue =  #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1).cgColor
        colorChange.duration = 10.0
        colorChange.autoreverses = true
        colorChange.repeatCount = .greatestFiniteMagnitude
        colorChange.timingFunction = CAMediaTimingFunction(controlPoints: 4, 2, 2, 2)
        
        //layer.add(colorChange, forKey: "colorAnimation")
        
        shapeLayer.fillColor = fillColor
        
        //layer.backgroundColor = color.cgColor
        shapeLayer.strokeColor = color.cgColor
        
        layer?.addSublayer(shapeLayer)
        
        layer?.backgroundColor = fillColor
    }
}
