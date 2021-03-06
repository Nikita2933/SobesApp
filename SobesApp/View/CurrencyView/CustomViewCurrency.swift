//
//  CurrencyView.swift
//  SobesApp
//
//  Created by Никита on 25.01.2021.
//

import UIKit

class CustomViewCurrency: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var currentValue: UIButton!
    @IBOutlet weak var classField: UITextField!
    @IBOutlet var contentView: UIView!
    var curse = Double()
    var count = Int()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitializer()
        classField.text = "0.0"
        classField.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func addParametr(labelName: String, curse: Double, currentValue: String ) { //
        self.labelName.text = labelName
        self.curse = curse
        self.currentValue.setTitle(currentValue, for: .normal)
        
    }
    
    func setParametr(charCode: String) { 
        DispatchQueue.main.async {
            if let result = currency.filter({$0.charCode == charCode}).first {
                self.labelName.text = result.name
                self.curse = result.value
                self.currentValue.setTitle(result.charCode, for: .normal)
            } 
        }
    }
    
    
    
    private func commonInitializer() {
        Bundle.main.loadNibNamed("CustomViewCurrency", owner:self, options: nil)
        addSubview(contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
    }
    
}



