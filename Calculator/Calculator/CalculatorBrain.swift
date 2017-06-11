//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Peter Vanhoef on 18/03/17.
//  Copyright © 2017 Peter Vanhoef. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    // MARK: - Internal
    
    private enum ExpressionLiteral {
        case operand(Double)
        case operation(String)
        case variable(String)
    }
    
    private var sequence = [ExpressionLiteral]()
    
    private enum Operation {
        case constant(Double)
        case nullaryOperation(() -> Double, () -> String)
        case unaryOperation((Double) -> Double, (String) -> String, (Double) -> String?)
        case binaryOperation((Double,Double) -> Double, (String,String) -> String, (Double,Double) -> String?)
        case equals
    }

    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "Rand" : Operation.nullaryOperation({Double(arc4random()) / 0xFFFFFFFF}, {"Rand"}),
        "√" : Operation.unaryOperation(sqrt, {"√(\($0))"}, {$0 < 0 ? "Sqrt of negative number" : nil}),
        "cos" : Operation.unaryOperation(cos, {"cos(\($0))"}, {_ in nil}),
        "sin" : Operation.unaryOperation(sin, {"sin(\($0))"}, {_ in nil}),
        "tan" : Operation.unaryOperation(tan, {"tan(\($0))"}, {_ in nil}),
        "x²" : Operation.unaryOperation({ $0 * $0 }, {"(\($0))²"}, {_ in nil}),
        "x⁻¹" : Operation.unaryOperation({ 1 / $0 }, {"(\($0))⁻¹"}, {_ in nil}),
        "±" : Operation.unaryOperation({ -$0 }, {"-\($0)"}, {_ in nil}),
        "×" : Operation.binaryOperation({ $0 * $1 }, {"\($0) × \($1)"}, {_,_ in nil}),
        "÷" : Operation.binaryOperation({ $0 / $1 }, {"\($0) ÷ \($1)"}, {$1 == 0 ? "Division by zero" : nil}), // equal comparison doubles is dangerous
        "+" : Operation.binaryOperation({ $0 + $1 }, {"\($0) + \($1)"}, {_,_ in nil}),
        "−" : Operation.binaryOperation({ $0 - $1 }, {"\($0) − \($1)"}, {_,_ in nil}),
        "=" : Operation.equals
    ]
    
    // MARK: - API

    mutating func undo() {
        if !sequence.isEmpty {
            sequence.removeLast()
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        sequence.append(ExpressionLiteral.operation(symbol))
    }
    
    mutating func setOperand(_ operand: Double) {
        sequence.append(ExpressionLiteral.operand(operand))
    }
    
    @available(*, deprecated, message: "Use evaluate instead")
    var result: Double? {
        get {
            return evaluate().result
        }
    }
    
    @available(*, deprecated, message: "Use evaluate instead")
    var resultIsPending: Bool {
        get {
            return evaluate().isPending
        }
    }
    
    @available(*, deprecated, message: "Use evaluate instead")
    var description: String? {
        get {
            return evaluate().description
        }
    }
    
    mutating func setOperand(variable named: String) {
        sequence.append(ExpressionLiteral.variable(named))
    }

    func evaluate(using variables: Dictionary<String,Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        let (result, isPending, description, _) = evaluateWithErrorReport(using: variables)
        return (result, isPending, description)
    }
    
    func evaluateWithErrorReport(using variables: Dictionary<String,Double>? = nil) -> (result: Double?, isPending: Bool, description: String, errorDescription: String?) {
        var accumulator: (value: Double?, description: String?, errorString: String?)
        var pendingBinaryOperation: PendingBinaryOperation?

        // Old functions are moved into this one as nested functionality
        func setOperand(_ operand: Double) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.usesGroupingSeparator = false
            numberFormatter.maximumFractionDigits = Constants.numberOfDigitsAfterDecimalPoint
            
            accumulator = (operand, numberFormatter.string(from: NSNumber(value: operand)), nil)
        }
        
        func setOperand(variable named: String) {
            accumulator = (variables?[named] ?? 0, named, nil)
        }

        func performPendingBinaryOperation() {
            if pendingBinaryOperation != nil && accumulator.value != nil {
                accumulator = (pendingBinaryOperation!.perform(with: accumulator.value!), pendingBinaryOperation!.buildDescription(with: accumulator.description!), pendingBinaryOperation!.validate(with: accumulator.value!))
                pendingBinaryOperation = nil
            }
        }
        
        struct PendingBinaryOperation {
            let function: (Double,Double) -> Double
            let firstOperand: Double
            
            let descriptionFunction: (String, String) -> String
            let descriptionOperand: String
            
            let errorFunction: (Double,Double) -> String?
            
            func perform(with secondOperand: Double) -> Double {
                return function(firstOperand, secondOperand)
            }
            
            func buildDescription(with secondOperand: String) -> String {
                return descriptionFunction(descriptionOperand, secondOperand)
            }
            
            func validate(with secondOperand: Double) -> String? {
                return errorFunction(firstOperand, secondOperand)
            }
        }
        
        func performOperation(_ symbol: String) {
            if let operation = operations[symbol] {
                switch operation {
                case .constant(let value):
                    accumulator = (value, symbol, nil)
                case .nullaryOperation(let function, let description):
                    accumulator = (function(), description(), nil)
                case .unaryOperation(let function, let descriptionFunction, let errorFunction):
                    if accumulator.value != nil {
                        accumulator = (function(accumulator.value!), descriptionFunction(accumulator.description!), errorFunction(accumulator.value!))
                    }
                case .binaryOperation(let function, let descriptionFunction, let errorFunction):
                    performPendingBinaryOperation()
                    if accumulator.value != nil {
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.value!, descriptionFunction: descriptionFunction, descriptionOperand: accumulator.description!, errorFunction: errorFunction)
                        accumulator = (nil, nil, nil)
                    }
                case .equals:
                    performPendingBinaryOperation()
                }
            }
        }
        
        // Entered sequence is parsed
        for item in sequence {
            switch item {
            case .operand(let operand):
                setOperand(operand)
            case .operation(let operation):
                performOperation(operation)
            case .variable(let variable):
                setOperand(variable: variable)
            }
        }
        
        if pendingBinaryOperation != nil {
            return (accumulator.value, true, pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand, accumulator.description ?? ""), accumulator.errorString)
        } else {
            return (accumulator.value, false, accumulator.description ?? "", accumulator.errorString)
        }
        
    }
    
    var savedSequence: [AnyObject] {
        get {
            var encodedSequence = [AnyObject]()
            for item in sequence {
                switch item {
                case .operand(let operand):
                    encodedSequence.append(operand as AnyObject)
                case .operation(let operation):
                    encodedSequence.append(operation as AnyObject)
                case .variable(let variable):
                    encodedSequence.append(variable as AnyObject)
                }
            }
            return encodedSequence
        }
        set {
            var decodedSequence = [ExpressionLiteral]()
            for item in newValue {
                if let operand = item as? Double {
                    decodedSequence.append(.operand(operand))
                } else {
                    if let name = item as? String {
                        if operations[name] != nil {
                            decodedSequence.append(.operation(name))
                        } else {
                            decodedSequence.append(.variable(name))
                        }
                    }
                }
            }
            sequence = decodedSequence
        }
    }
}
