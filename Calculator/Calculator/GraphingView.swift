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

@IBDesignable
class GraphingView: UIView {
    
    var dataSource: GraphingViewDataSource?

    var origin: CGPoint? { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scale: CGFloat = 50 { didSet { setNeedsDisplay() } }
    
    private var snapshotView: UIView?
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .began:
            snapshotView = self.snapshotView(afterScreenUpdates: false)
            snapshotView!.alpha = 0.80
            self.addSubview(snapshotView!)
        case .changed:
            snapshotView!.frame.size.height *= pinchRecognizer.scale
            snapshotView!.frame.size.width *= pinchRecognizer.scale
            let snapShotViewOrigin = CGPoint(x: origin!.x * (snapshotView!.frame.height / self.frame.height), y: origin!.y * (snapshotView!.frame.height / self.frame.height))
            snapshotView!.frame.origin.x = self.frame.origin.x - (snapShotViewOrigin.x - origin!.x)
            snapshotView!.frame.origin.y = self.frame.origin.y - (snapShotViewOrigin.y - origin!.y)
            pinchRecognizer.scale = 1
        case .ended:
            scale *= (snapshotView!.frame.height / self.frame.height)
            snapshotView!.removeFromSuperview()
            snapshotView = nil
        default:
            break
        }
    }

    func moveOrigin(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .began:
            snapshotView = self.snapshotView(afterScreenUpdates: false)
            snapshotView!.alpha = 0.80
            self.addSubview(snapshotView!)
        case .changed:
            let translation = panRecognizer.translation(in: self)
            snapshotView!.center.x += translation.x
            snapshotView!.center.y += translation.y
            panRecognizer.setTranslation(CGPoint.zero, in: self)
        case .ended:
            origin!.x += snapshotView!.frame.origin.x
            origin!.y += snapshotView!.frame.origin.y
            snapshotView!.removeFromSuperview()
            snapshotView = nil
        default:
            break
        }
    }
    
    func setOrigin(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        switch tapRecognizer.state {
        case .changed, .ended:
            origin = tapRecognizer.location(in: self)
        default:
            break
        }
    }
    
    private var axesDrawer = AxesDrawer(color: UIColor.black, contentScaleFactor: 1.0)
    
    private func pathForUnaryFunction() -> UIBezierPath {
        let path = UIBezierPath()
        
        if dataSource != nil && origin != nil {
            // iterate over every pixel of the width of the view
            let numberOfPixelsHorizontally = Int(bounds.size.width * contentScaleFactor)
            var firstPixel = true

            for xPixel in 0 ... numberOfPixelsHorizontally {
                if let yValue = dataSource!.getYValue(for: (CGFloat(xPixel) - origin!.x) / scale) {
                    if yValue.isNormal || yValue.isZero {
                        let yPixel = origin!.y - (yValue * scale)
                        
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
        if (origin == nil) { origin = CGPoint(x: bounds.midX, y: bounds.midY) }
        
        UIColor.red.setStroke()
        pathForUnaryFunction().stroke()
        
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxes(in: bounds, origin: origin!, pointsPerUnit: scale)
    }
}
