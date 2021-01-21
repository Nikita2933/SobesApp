//
//  ConverterVC.swift
//  SobesApp
//
//  Created by Никита on 16.01.2021.
//

import UIKit

class ConverterVC: UIViewController, UITableViewDelegate, UIPopoverPresentationControllerDelegate,  PopoverContentControllerDelegate {
    
    
    

    @IBOutlet weak var blue: UIView!
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
    }
    @IBAction func oneTabToView(_ sender: Any) {
        for textField in stackTextField {
            textField.resignFirstResponder()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeView(_ sender: UIButton) {
        
        for view in arrView.reversed() {
            if view.isHidden == false {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: .overrideInheritedDuration) {
                    view.isHidden = true
                    view.alpha = 0
                }
                return
            }
        }
    }
    @IBAction func addView(_ sender: Any) {

        for view in arrView {
            if  view.isHidden == true {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: .overrideInheritedDuration) {
                    view.isHidden = false
                    view.alpha = 1

                }
                return
            }
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
            for textField in stackTextField {
                if textField.isEditing == true {
                    if textField.superview!.center.y > (kbFrameSize + tabBarHeight / 1.5) {
                        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .overrideInheritedDuration) {
                            self.view.frame.size.height -= kbFrameSize - tabBarHeight
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
    @objc func keyboardHide()  {
        let viewHeight = view.frame.size.height
            if viewHeight != self.staticSize {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .overrideInheritedDuration) {
                self.view.frame.size.height = self.staticSize
                    self.view.layoutIfNeeded()
            }
        }
    }
    //MARK: Currency TableView
    @IBAction func testTableButton(_ sender: UIButton) {
        guard let tableCurrency = storyboard?.instantiateViewController(identifier: "tableCurrency") as? CurrencyTableViewPopover else { return }
        tableCurrency.modalPresentationStyle = .popover
        let popoverController = tableCurrency.popoverPresentationController
        popoverController?.delegate = self
        tableCurrency.delegate = self
        tableCurrency.tag = sender.tag
        popoverController?.sourceView = sender
        popoverController?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.midY, width: 0, height: 0)
        tableCurrency.preferredContentSize = CGSize(width: 150, height: 400)
        self.present(tableCurrency, animated: true, completion: nil)
        
    }

    func popoverContent(didselectItem name: String, tag: Int) {
        for button in arrButton {
            if button.tag == tag{
                button.setTitle(name, for: .normal)
            }
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
    }
}
    

