//
//  ViewController.swift
//  Calculator
//
//  Created by Peter Vanhoef on 18/03/17.
//  Copyright © 2017 Peter Vanhoef. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var sequence: UILabel!
    @IBOutlet weak var memory: UILabel!
    
    @IBOutlet weak var graphButton: UIButton! {
        didSet {
            // default: disable graphButton
            graphButton.isEnabled = false
            graphButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if !(digit == "." && textCurrentlyInDisplay.contains(".")) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = (digit == ".") ? "0." : digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displays: (result: Double?, isPending: Bool, description: String, errorDescription: String?) {
        get {
            return (Double(display.text!)!, false, sequence.text!, nil)
        }
        set {
            if (newValue.errorDescription != nil) {
                display.text = newValue.errorDescription!
            } else {
                if newValue.result != nil {
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.usesGroupingSeparator = false
                    numberFormatter.maximumFractionDigits = Constants.numberOfDigitsAfterDecimalPoint
                    display.text = numberFormatter.string(from: NSNumber(value: newValue.result!))
                }
            }
            if newValue.description.isEmpty {
                sequence.text = " "
            } else {
                sequence.text = newValue.description + (newValue.isPending ? ( (newValue.description.characters.last != " ") ? " …" : "…") : " =")
            }
            if let memoryValue = dictionary["M"] {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.usesGroupingSeparator = false
                numberFormatter.maximumFractionDigits = Constants.numberOfDigitsAfterDecimalPoint
                memory.text = numberFormatter.string(from: NSNumber(value: memoryValue))
            } else {
                memory.text = " "
            }
            if newValue.description.isEmpty || newValue.isPending {
                graphButton.isEnabled = false
                graphButton.setTitleColor(UIColor.lightGray, for: .normal)
            } else {
                graphButton.isEnabled = true
                graphButton.setTitleColor(UIColor.red, for: .normal)
            }
        }
    }
    
    private var brain = CalculatorBrain()
    private var dictionary = [String: Double]()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displays.result!)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displays = brain.evaluateWithErrorReport(using: dictionary)
    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain = CalculatorBrain()
        dictionary = [:]
        displays = (0, false, "", nil)
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            var textCurrentlyInDisplay = display.text!
            textCurrentlyInDisplay.remove(at: textCurrentlyInDisplay.index(before: textCurrentlyInDisplay.endIndex))
            if textCurrentlyInDisplay.isEmpty {
                userIsInTheMiddleOfTyping = false
                textCurrentlyInDisplay = "0"
            }
            display.text = textCurrentlyInDisplay
        } else {
            brain.undo()
            displays = brain.evaluateWithErrorReport(using: dictionary)
        }
    }
    
    @IBAction func evaluateVariable(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        let symbol = String(sender.currentTitle!.characters.dropFirst())
        dictionary[symbol] = displays.result!
        displays = brain.evaluateWithErrorReport(using: dictionary)
    }
    
    @IBAction func setVariable(_ sender: UIButton) {
        let symbol = sender.currentTitle!
        brain.setOperand(variable: symbol)
        displays = brain.evaluateWithErrorReport(using: dictionary)
    }
  
    private let defaults = UserDefaults.standard

    private var savedSequence: [AnyObject]? {
        get {
            return defaults.value(forKey: Keys.savedSequence) as? [AnyObject]
        }
        set {
            defaults.set(newValue, forKey: Keys.savedSequence)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if savedSequence != nil {
            brain.savedSequence = savedSequence!
            displays = brain.evaluateWithErrorReport(using: dictionary)

            var viewController = splitViewController?.viewControllers.last
            if let navigationController = viewController as? UINavigationController {
                viewController = navigationController.visibleViewController
            }
            if let graphingViewController = viewController as? GraphingViewController {
                graphingViewController.unaryFunction = { [weak weakSelf = self] operand in
                    let graphingDictionary: [String: Double] = ["M": operand]
                    return weakSelf?.brain.evaluate(using: graphingDictionary).result }
                graphingViewController.navigationItem.title = self.brain.evaluate().description
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !brain.evaluate(using: dictionary).isPending {
            savedSequence = brain.savedSequence
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let graphingViewController = destinationViewController as? GraphingViewController {
            if let identifier = segue.identifier {
                if identifier == "graph" {
                    graphingViewController.unaryFunction = { [weak weakSelf = self] operand in
                        let graphingDictionary: [String: Double] = ["M": operand]
                        return weakSelf?.brain.evaluate(using: graphingDictionary).result }
                    graphingViewController.navigationItem.title = self.brain.evaluate().description
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "graph" {
            return !brain.evaluate(using: dictionary).isPending
        }
        return false
    }
}
