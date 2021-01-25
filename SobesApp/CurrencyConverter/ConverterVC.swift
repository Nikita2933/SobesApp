//
//  ConverterVC.swift
//  SobesApp
//
//  Created by Никита on 16.01.2021.
//

import UIKit

class ConverterVC: UIViewController, UITableViewDelegate, UIPopoverPresentationControllerDelegate, PopoverContentControllerDelegate{

    @IBOutlet weak var stackView: UIStackView!
    var staticSize: CGFloat!
    let testView = CustomViewCurrency()
    let secondTestView = CustomViewCurrency()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        staticSize = view.frame.size.height
        testView.setParametr(charCode: "RUB")
        secondTestView.setParametr(charCode: "EUR")
        stackView.addArrangedSubview(testView)
        stackView.addArrangedSubview(secondTestView)
        testView.currentValue.addTarget(self, action: #selector(testTableButton(_:)), for: .allTouchEvents)
        secondTestView.currentValue.addTarget(self, action: #selector(testTableButton(_:)), for: .allTouchEvents)
    }
    
    @IBAction func oneTabToView(_ sender: Any) {
        testView.textField.resignFirstResponder()
        secondTestView.textField.resignFirstResponder()
    }
    
    @IBAction func removeView(_ sender: UIButton) {
        if stackView.arrangedSubviews.count > 2 {
            let view = stackView.arrangedSubviews.last!
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    @IBAction func addView(_ sender: Any) {
        if stackView.arrangedSubviews.count < 4 {
            let testView = CustomViewCurrency()
            stackView.addArrangedSubview(testView)
        }

    }
    
    //MARK: KeyboardSetting
    
    private func registerNotification(){
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
        popoverController?.sourceView = sender
        popoverController?.sourceRect = CGRect(x: sender.bounds.midX,
                                               y: sender.bounds.midY,
                                               width: 0, height: 0)
        tableCurrency.preferredContentSize = CGSize(width: 150, height: 400)
        self.present(tableCurrency, animated: true, completion: nil)
    }
    
    func popoverContent(charCode: String, value: Double, name: String) {
        testView.addParametr(labelName: name, curse: value, currentValue: charCode)
    }

}


