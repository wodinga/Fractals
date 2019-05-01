//
//  Tree.swift
//  Fractals
//
//  Created by David Garcia on 4/6/19.
//  Copyright © 2019 Ayy Lmao LLC. All rights reserved.
//

import Cocoa
// This code shamelessly copies from this blog post as a starting point: http://www.knowstack.com/swift-fractal-tree/

@IBDesignable
class Tree: NSView {

    let PI = 3.14156
    var leftAngle:Double = 10
    var rightAngle:Double = 10
    var treeDepth:Float = 15
    var backgroundColor:NSColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var leafColor:NSColor = NSColor(calibratedRed: 0, green: 30, blue: 0, alpha: 1.0)
    var trunkColor:NSColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    let shapeLayer = CAShapeLayer()
    @IBOutlet weak var treeView: NSView!
    required override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        treeView.wantsLayer = true
        treeView.layer?.addSublayer(shapeLayer)
        self.drawBranch(x1: 300, y1: 100.0, angle: 90.0, depth: self.treeDepth)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func awakeFromNib() {
        treeView.wantsLayer = true
        treeView.layer?.addSublayer(shapeLayer)
    }
    
    override func prepareForInterfaceBuilder() {
        trunkColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }

    @IBAction func changeDepth(sender:AnyObject){
        self.treeDepth = Float(sender.intValue)
        Swift.print(self.treeDepth)
        self.needsDisplay = true
    }

    @IBAction func changeLeftAngle(sender:AnyObject){
        self.leftAngle = sender.doubleValue
        self.needsDisplay = true
    }

    @IBAction func changeRightAngle(sender:AnyObject){
        self.rightAngle = sender.doubleValue
        self.needsDisplay = true
    }

    @IBAction func changeBackgroundColor(sender:AnyObject){
        self.backgroundColor = ((sender as? NSColorWell)?.color)!
        self.needsDisplay = true
    }

    @IBAction func changeLeafColor(sender:AnyObject){
        self.leafColor = ((sender as? NSColorWell)?.color)!
        self.needsDisplay = true
    }
    @IBAction func changeTrunkColor(sender:AnyObject){
        self.trunkColor = ((sender as? NSColorWell)?.color)!
        self.needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
//        treeView.layer?.backgroundColor
//        treeView.backgroundColor.setFill()
        self.drawBranch(x1: Float(self.frame.size.width/5), y1: 100.0, angle: 90.0, depth: 10)
        dirtyRect.fill()

    }

    func drawBranch(x1:Float, y1:Float, angle:Double,depth:Float){
        var branchArmLength = depth
        if depth > 0 && depth < 3{
            branchArmLength = depth * 0.7
        } else if depth > 3 && depth < 7{
            branchArmLength = depth * 0.7
        }
        else{
            branchArmLength = depth*0.7
        }
        if depth != 0{
            let x2 = x1 + (Float(cos(angle * PI/180)) * depth * branchArmLength)
            let y2 = y1 + (Float(sin(angle * PI/180)) * depth * branchArmLength)
            drawLine(lineWidth: depth, fromPoint: CGPoint(x: CGFloat(x1), y: CGFloat(y1)), toPoint: CGPoint(x: CGFloat(x2), y: CGFloat(y2)))
            
            drawBranch(x1: x2, y1: y2, angle: angle - self.leftAngle, depth: depth-1)
            drawBranch(x1: x2, y1: y2, angle: angle + self.rightAngle, depth: depth-1)
        }
    }

    func drawLine(lineWidth:Float, fromPoint:NSPoint, toPoint:NSPoint){
        let path = CGMutablePath()
        let anim = CABasicAnimation(keyPath:"strokeEnd")
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.duration = 2

        path.move(to: fromPoint)
        path.addLine(to: toPoint)

        shapeLayer.add(anim, forKey: "lines")
        shapeLayer.strokeColor = self.leafColor.cgColor
        if (lineWidth < 5){
            shapeLayer.strokeColor = self.leafColor.cgColor
            shapeLayer.lineWidth = 1.0/CGFloat(lineWidth*0.2)
        }
        else{
            shapeLayer.strokeColor = self.trunkColor.cgColor
            shapeLayer.lineWidth = 2.0/CGFloat(lineWidth*0.5)
        }
        if shapeLayer.path != nil {
            let newPath = shapeLayer.path?.mutableCopy()
            newPath?.addPath(path)
            shapeLayer.path = newPath
        } else {
            shapeLayer.path = path
        }
    }

}
