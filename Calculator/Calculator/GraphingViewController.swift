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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var graphingView: GraphingView! {
        didSet {
            graphingView.dataSource = self
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
