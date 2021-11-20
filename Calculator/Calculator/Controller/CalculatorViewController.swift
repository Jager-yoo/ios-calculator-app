//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class CalculatorViewController: UIViewController {
    private var savedCalculatorItems: String = ""
    private let emptyString: String = ""
    private let decimalPoint: String = "."
    private let decimalComma: String = ","
    private let negativeSign: String = "-"
    private let defaultOperandLabel: String = "0"
    private let numberFormatter = NumberFormatter()
    
    @IBOutlet weak var operandLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    
    @IBAction func resultButtonDidTouchUp(_ button: UIButton) {
        numberFormatter.numberStyle = .decimal
        switch operatorLabel.text!.isEmpty {
        case true:
            return
        case false:
            saveCalculator(item: "\(operatorLabel.text!)")
            saveCalculator(item: "\(operandLabel.text!)")
            resetOperatorLable()
            let result = ExpressionParser.parse(from: savedCalculatorItems).result()
            
            guard result.description != "nan" else {
                operandLabel.text = "NaN"
                resetSavedCalculatorItems()
                return
            }
            operandLabel.text = numberFormatter.string(for: result)
            resetSavedCalculatorItems()
        }
    }
    
    @IBAction func operandButtonDidTouchUp(_ button: UIButton) {
        switch operandLabel.text! {
        case defaultOperandLabel:
            operandLabel.text = emptyString
            operandLabel.text! += button.currentTitle!
        default:
            operandLabel.text! += button.currentTitle!
        }
    }
    
    @IBAction func operatorButtonDidTouchUp(_ button: UIButton) {
        switch operatorLabel.text!.isEmpty {
        case true:
            saveCalculator(item: "\(operandLabel.text!)")
            resetOperandLable()
            operatorLabel.text = button.currentTitle
        case false:
            saveCalculator(item: "\(operatorLabel.text!)")
            saveCalculator(item: "\(operandLabel.text!)")
            resetOperandLable()
            operatorLabel.text = button.currentTitle
        }
    }
    
    @IBAction func zeroButtonDidTouchUp(_ button: UIButton) {
        switch operandLabel.text! {
        case defaultOperandLabel:
            return
        default:
            operandLabel.text! += button.currentTitle!
        }
    }
    
    @IBAction func decimalPointButtonDidTouchUp(_ button: UIButton) {
        switch operandLabel.text!.contains(decimalPoint) {
        case true:
            return
        case false:
            operandLabel.text! += button.currentTitle!
        }
    }
    
    @IBAction func changeSignButtonDidTouchUp(_ button: UIButton) {
        guard operandLabel.text! != defaultOperandLabel else {
            return
        }
        
        switch operandLabel.text!.hasPrefix(negativeSign) {
        case true:
            operandLabel.text!.removeFirst()
        case false:
            operandLabel.text! = negativeSign + operandLabel.text!
        }
    }
    
    @IBAction func allClearButtonDidTouchUp(_ button: UIButton) {
        resetSavedCalculatorItems()
        resetOperandLable()
        resetOperatorLable()
    }
    
    @IBAction func clearEntryButtonDidTouchUp(_ button: UIButton) {
        resetOperandLable()
    }
    
    private func saveCalculator(item: String) {
        switch item.contains(decimalComma) {
        case true:
            let commaRemoveditem = item.components(separatedBy: decimalComma).joined()
            savedCalculatorItems += " \(commaRemoveditem)"
        case false:
            savedCalculatorItems += " \(item)"
        }
    }
    
    private func resetSavedCalculatorItems() {
        savedCalculatorItems = emptyString
    }
    
    private func resetOperandLable() {
        operandLabel.text = defaultOperandLabel
    }
    
    private func resetOperatorLable() {
        operatorLabel.text = emptyString
    }
}

