//
//  ConverterVC.swift
//  SobesApp
//
//  Created by Никита on 16.01.2021.
//

import UIKit

class ConverterVC: UIViewController, UITableViewDelegate, UIPopoverPresentationControllerDelegate,  PopoverContentControllerDelegate {
    

    @IBOutlet weak var blue: UIView!
    @IBOutlet weak var orange: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var stackTextField: [UITextField]!
    @IBOutlet var arrView: [UIView]!
    @IBOutlet var arrButton: [UIButton]!
    let tableViewtest = UITableView()
    var staticSize: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        staticSize = view.frame.size.height
        for textField in stackTextField {
            textField.addTarget(self, action: #selector(Iteraction), for: .editingChanged)
        }
    }
    
    @IBAction func oneTabToView(_ sender: Any) {
        dismissView()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func hiddenView(_ sender: UIButton) {
        
        
//        for view in arrView.reversed() {
//            if view.isHidden == false {
//                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: .overrideInheritedDuration) {
//                    view.isHidden = true
//                    view.alpha = 0
//                }
//                return
//            }
//        }
    }
    @IBAction func addView(_ sender: Any) {
        let testView = CurrencyView()
        stackView.addArrangedSubview(testView)
//        for view in arrView.sorted(by: {$0.tag < $1.tag}) {
//            if  view.isHidden == true {
//                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: .overrideInheritedDuration) {
//                    view.isHidden = false
//                    view.alpha = 1
//
//                }
//                return
//            }
//        }
    }
    
    func dismissView() {
        for textField in stackTextField {
            textField.resignFirstResponder()
        }
    }
        //MARK: KeyboardSetting
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let tabBarHeight = tabBarController!.tabBar.frame.height
        let viewHeight = view.frame.size.height
            if viewHeight == staticSize  {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: .overrideInheritedDuration) {
                self.view.frame.size.height -= kbFrameSize - tabBarHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardHide()  {
        let viewHeight = view.frame.size.height
            if viewHeight != self.staticSize {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: .overrideInheritedDuration) {
                self.view.frame.size.height = self.staticSize
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: Currency TableView Popover
    @IBAction func testTableButton(_ sender: UIButton) {
        guard let tableCurrency = storyboard?.instantiateViewController(identifier: "tableCurrency") as? CurrencyTableViewPopover else { return }
        tableCurrency.modalPresentationStyle = .popover
        let popoverController = tableCurrency.popoverPresentationController
        popoverController?.delegate = self
        tableCurrency.delegate = self
        tableCurrency.tag = sender.tag
        popoverController?.sourceView = sender
        popoverController?.sourceRect = CGRect(x: sender.bounds.midX,
                                               y: sender.bounds.midY,
                                               width: 0, height: 0)
        tableCurrency.preferredContentSize = CGSize(width: 150, height: 400)
        self.present(tableCurrency, animated: true, completion: nil)
    }


    func popoverContent(charCode: String, value: Double, name: String, tag: Int) {
        for button in arrButton {
            if button.tag == tag{
                let textField = button.superview?.viewWithTag(10) as! UITextField
                let label = button.superview?.viewWithTag(11) as! UILabel
                let valueLabel = button.superview?.viewWithTag(12) as! UILabel
                setCurrentValue(textField)
                dismissView()
                //Iteraction(textField!)
                button.setTitle(charCode, for: .normal)
                valueLabel.text = String(value)
                label.text = name
            }
        }
    }
    
    @objc func Iteraction(_ textField: UITextField){
        let value = textField.superview?.viewWithTag(12) as! UILabel
        let currentValue = Double(value.text!) ?? 0
        let fieldInt = Double(textField.text!) ?? 0
        
        for field in stackTextField {
            if textField != field && field.text != "0" {
                let valueField = field.superview?.viewWithTag(12) as! UILabel
                let secondValue = Double(valueField.text!) ?? 0
                
                field.text = String(format: "%.3f" ,fieldInt * (currentValue / secondValue))
            }
        }
    }
    
    func setCurrentValue(_ field: UITextField) {
        let textFieldBlue = blue.viewWithTag(10) as! UITextField
        let labelBlueValue = blue.viewWithTag(12) as! UILabel
        
        let blueFieldIntValue = Double(textFieldBlue.text!) ?? 0
        let labelIntBlueValue = Double(labelBlueValue.text!) ?? 0
        
        //let fieldValue = field.superview?.viewWithTag(10) as! UITextField
        let labelValue = field.superview?.viewWithTag(12) as! UILabel
        //let fieldIntValue = Double(fieldValue.text!) ?? 0
        let fieldLabelValue = Double(labelValue.text!) ?? 0
        field.text = String(format: "%.3f", blueFieldIntValue * (labelIntBlueValue / fieldLabelValue) )
        
        
    }
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//    return .none
//    }
}
    

