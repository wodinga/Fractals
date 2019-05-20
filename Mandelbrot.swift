//
//  Mandelbrot.swift
//  Fractals
//
//  Created by Garcia, David on 5/7/19.
//  Copyright © 2019 Ayy Lmao LLC. All rights reserved.
//

import Cocoa
import CoreGraphics

let CONSTANTS = (
    xscale: Scale(start: -0.67, end: -0.45, step: 0.0008),
    yscale: Scale(start: -0.67, end: -0.34, step: 0.0006),
    iterations: 10_000,
    escape: 2.0
)

struct Scale {
    let start: Double
    let end: Double
    let step: Double
    
    func toStride() -> StrideThrough<Double>  {
        return stride(from: start, through: end - 0.001, by: step)
    }
    
    func steps() -> Int {
        return Int(floor((end - start) / step))
    }
}

struct ComplexNumber
{
    let real: Double!
    let imaginary: Double!
    
    func normal() -> Double {
        return real * real + imaginary * imaginary
    }
    
    init() {
        real = 0.0
        imaginary = 0.0
    }
    
    init(real: Double, imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
}

func + (x: ComplexNumber, y: ComplexNumber) -> ComplexNumber {
    return ComplexNumber(real: x.real + y.real,
                         imaginary: x.imaginary + y.imaginary)
}

func * (x: ComplexNumber, y: ComplexNumber) -> ComplexNumber {
    return ComplexNumber(real: x.real * y.real - x.imaginary * y.imaginary,
                         imaginary: x.real * y.imaginary + x.imaginary * y.real)
}


class Mandelbrot: NSImageView {

    var arr = [Int]()
    let queue = DispatchQueue.global(qos: .unspecified)
    var datapoints: [DispatchWorkItem] {
        var datapoints = [ComplexNumber](repeating: ComplexNumber(), count: CONSTANTS.xscale.steps() * CONSTANTS.yscale.steps())
        //    var datapoints = [ComplexNumber]()
        var index = 0
        for dx in CONSTANTS.xscale.toStride() {
            for dy in CONSTANTS.yscale.toStride() {
                datapoints[index] = ComplexNumber(real: dy, imaginary: dx)
                //            datapoints.append(ComplexNumber(real: dy, imaginary: dx))
                index += 1
            }
        }
        
        return datapoints.filter{!($0.real == 0 || $0.imaginary == 0)}
            .map{num in
                return DispatchWorkItem{
                    let temp = self.iterationsForLocation(c:num)
                    DispatchQueue.main.async {
                        self.arr.append(temp ?? 0)
                    }
                }
        }
    }
    
    //Naive CoreGraphics drawing
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        print(arr)
        let context = NSGraphicsContext.current?.cgContext
        
        // Drawing code here.
    }
    
    required init?(coder: NSCoder) {
//        arr = [Int]()
        super.init(coder: coder)
        datapoints.forEach{ i in
            queue.async(execute: i)
        }
    }

    
    public func iterationsForLocation(c: ComplexNumber) -> Int? {
        var iteration = 0
        var z = ComplexNumber()
        repeat {
            z = z * z + c
            iteration += 1
        } while (z.normal() < CONSTANTS.escape && iteration < CONSTANTS.iterations)
        
        return iteration < CONSTANTS.iterations ? iteration : nil
    }
    
}
