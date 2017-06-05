//
//  GraphingViewController.swift
//  Calculator
//
//  Created by Peter Vanhoef on 12/05/17.
//  Copyright © 2017 Peter Vanhoef. All rights reserved.
//

import UIKit

class GraphingViewController: UIViewController, GraphingViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var graphingView: GraphingView! {
        didSet {
            graphingView.dataSource = self
            
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphingView, action: #selector(GraphingView.changeScale(byReactingTo:)))
            graphingView.addGestureRecognizer(pinchRecognizer)
            
            let panRecognizer = UIPanGestureRecognizer(target: graphingView, action: #selector(graphingView.moveOrigin(byReactingTo:)))
            graphingView.addGestureRecognizer(panRecognizer)
            
            let tapRecognizer = UITapGestureRecognizer(target: graphingView, action: #selector(graphingView.setOrigin(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 2
            graphingView.addGestureRecognizer(tapRecognizer)
            
            if scale != nil {
                graphingView.scale = scale!
            }
            if origin != nil {
                graphingView.origin = origin
            }
        }
    }
    
    func getYValue(for xValue: CGFloat) -> CGFloat? {
        if let yValue = unaryFunction?(Double(xValue)) {
            return CGFloat(yValue)
        }
        return nil
    }

    var unaryFunction: ((Double) -> Double?)?
    
    private let defaults = UserDefaults.standard
    
    private var scale: CGFloat? {
        get {
            return defaults.value(forKey: Keys.scale) as? CGFloat
        }
        set {
            defaults.set(newValue, forKey: Keys.scale)
        }
    }
    
    private var origin: CGPoint? {
        get {
            if let point = defaults.value(forKey: Keys.origin) as? [CGFloat] {
                return CGPoint(x: point[0], y: point[1])
            }
            return nil
        }
        set {
            defaults.set([newValue?.x, newValue?.y], forKey: Keys.origin)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        scale = graphingView.scale
        origin = graphingView.origin
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let fromViewCenterX = (graphingView.origin?.x)! - graphingView.bounds.midX
        let fromViewCenterY = (graphingView.origin?.y)! - graphingView.bounds.midY
        
        graphingView.origin = CGPoint(x: size.width / 2 + fromViewCenterX, y: size.height / 2 + fromViewCenterY)
    }
}
