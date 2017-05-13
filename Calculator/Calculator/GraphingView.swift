//
//  GraphingView.swift
//  Calculator
//
//  Created by Peter Vanhoef on 12/05/17.
//  Copyright © 2017 Peter Vanhoef. All rights reserved.
//

import UIKit

protocol GraphingViewDataSource {
    func getYValue(for xValue: CGFloat) -> CGFloat?
}

class GraphingView: UIView {
    
    var dataSource: GraphingViewDataSource?
    
    private var origin: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    var scale: CGFloat = 50

    private var axesDrawer = AxesDrawer(color: UIColor.black, contentScaleFactor: 1.0)
    
    private func pathForUnaryFunction() -> UIBezierPath {
        let path = UIBezierPath()
        
        if dataSource != nil {
            // iterate over every pixel of the width of the view
            let numberOfPixelsHorizontally = Int(bounds.size.width * contentScaleFactor)
            var firstPixel = true

            for xPixel in 0 ... numberOfPixelsHorizontally {
                if let yValue = dataSource!.getYValue(for: (CGFloat(xPixel) - origin.x) / scale) {
                    if yValue.isNormal || yValue.isZero {
                        let yPixel = origin.y - (yValue * scale)
                        
                        if firstPixel {
                            path.move(to: CGPoint(x: CGFloat(xPixel), y: yPixel))
                            firstPixel = false
                        } else {
                            path.addLine(to: CGPoint(x: CGFloat(xPixel), y: yPixel))
                        }
                    } else {
                        // discontinuity
                        firstPixel = true
                    }
                }
            }
            path.lineWidth = 2
        }
        
        return path
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.red.setStroke()
        pathForUnaryFunction().stroke()
        
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
    }
}
