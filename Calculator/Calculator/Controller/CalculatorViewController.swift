//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class CalculatorViewController: UIViewController {
    private var savedCalculatorItems: String = ""
    private let numberFormatter = NumberFormatter()
    private let hapticGenerator = UISelectionFeedbackGenerator()
    
    @IBOutlet weak var operandLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var savedCalculatorItemsStackView: UIStackView!
    @IBOutlet weak var savedCalculatorItemsScrollView: UIScrollView!
    
    private func addStackViewLabel() {
        let savedItemlabel = UILabel()
        savedItemlabel.font = UIFont.preferredFont(forTextStyle: .title3)
        savedItemlabel.textColor = .white
        savedItemlabel.adjustsFontSizeToFitWidth = true
        
        if operandLabel.text!.contains(String.decimalPoint) {
            while operandLabel.text!.hasSuffix("0") || operandLabel.text!.hasSuffix(String.decimalPoint) {
                operandLabel.text!.removeLast()
            }
        }
        
        savedItemlabel.text = "\(operatorLabel.text!) \(operandLabel.text!)"
        savedCalculatorItemsStackView.addArrangedSubview(savedItemlabel)
        CalculatorSetting.scrollToBottom(on: savedCalculatorItemsScrollView)
    }
    
    private func clearAllStackViewLabel() {
        let addedStackViewLabels = savedCalculatorItemsStackView.arrangedSubviews
        
        addedStackViewLabels.forEach { subview in
            return subview.removeFromSuperview()
        }
    }
    
    @IBAction func tappedResultButton(_ button: UIButton) {
        switch operatorLabel.text!.isEmpty {
        case true:
            return
        case false:
            saveCalculator(item: "\(operatorLabel.text!)")
            saveCalculator(item: "\(operandLabel.text!)")
            addStackViewLabel()
            resetOperatorLabel()
            var parsedFormula = ExpressionParser.parse(from: savedCalculatorItems)
            let result = parsedFormula.result()
            operandLabel.text = numberFormatter.string(for: result)
            resetSavedCalculatorItems()
        }
    }
    
    @IBAction func tappedOperandButton(_ button: UIButton) {
        switch operandLabel.text! {
        case String.zero:
            operandLabel.text = String.empty
            operandLabel.text! += button.currentTitle!
        default:
            operandLabel.text! += button.currentTitle!
        }
    }
    
    @IBAction func tappedOperatorButton(_ button: UIButton) {
        switch operatorLabel.text!.isEmpty || operandLabel.text! != String.zero {
        case true:
            saveCalculator(item: "\(operatorLabel.text!)")
            saveCalculator(item: "\(operandLabel.text!)")
            addStackViewLabel()
            resetOperandLabel()
            operatorLabel.text = button.currentTitle
        case false:
            operatorLabel.text = button.currentTitle
        }
    }
    
    @IBAction func tappedZeroButton(_ button: UIButton) {
        guard let buttonTitle = button.currentTitle,
              var operandLabelText = operandLabel.text else { return }
        
        if operandLabelText != String.zero {
            operandLabelText += buttonTitle
            operandLabel.text = operandLabelText
        }
    }
    
    @IBAction func tappedDecimalPointButton(_ button: UIButton) {
        switch operandLabel.text!.contains(String.decimalPoint) {
        case true:
            return
        case false:
            operandLabel.text! += button.currentTitle!
        }
    }
    
    @IBAction func tappedChangeSignButton(_ button: UIButton) {
        guard operandLabel.text! != String.zero else {
            return
        }
        
        switch operandLabel.text!.hasPrefix(String.negativeSign) {
        case true:
            operandLabel.text!.removeFirst()
        case false:
            operandLabel.text! = String.negativeSign + operandLabel.text!
        }
    }
    
    @IBAction func tappedAllClearButton(_ button: UIButton) {
        resetSavedCalculatorItems()
        resetOperandLabel()
        resetOperatorLabel()
        clearAllStackViewLabel()
    }
    
    @IBAction func tappedClearEntryButton(_ button: UIButton) {
        resetOperandLabel()
    }
    
    @IBAction func occurHapticFeedback() {
        hapticGenerator.selectionChanged()
    }
    
    private func saveCalculator(item: String) {
        switch item.contains(String.decimalComma) {
        case true:
            let commaRemoveditem = item.components(separatedBy: String.decimalComma).joined()
            savedCalculatorItems += " \(commaRemoveditem)"
        case false:
            savedCalculatorItems += " \(item)"
        }
    }
    
    private func resetSavedCalculatorItems() {
        savedCalculatorItems = String.empty
    }
    
    private func resetOperandLabel() {
        operandLabel.text = String.zero
    }
    
    private func resetOperatorLabel() {
        operatorLabel.text = String.empty
    }
}

