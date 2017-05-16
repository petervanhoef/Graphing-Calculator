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
        }
    }
    
    func getYValue(for xValue: CGFloat) -> CGFloat? {
        if let yValue = unaryFunction?(Double(xValue)) {
            return CGFloat(yValue)
        }
        return nil
    }

    var unaryFunction: ((Double) -> Double?)?
}
