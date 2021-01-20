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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()

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
        let kbFrameSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if view.frame.origin.y == 0  {
            for textField in stackTextField {
                if textField.isEditing == true {
                    if textField.superview!.frame.origin.y > (kbFrameSize.height + tabBarController!.tabBar.frame.height / 2) {
                        self.view.center.y -= kbFrameSize.height - tabBarController!.tabBar.frame.height
                    }
                }
            }
        }
    }
    @objc func keyboardHide()  {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10.0, options: .overrideInheritedDuration) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
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
        popoverController?.sourceView = sender
        popoverController?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.midY, width: 0, height: 0)
        tableCurrency.preferredContentSize = CGSize(width: 150, height: 400)
        self.present(tableCurrency, animated: true, completion: nil)
        let test = sender.superview?.viewWithTag(2) as! UITextField
        test.text = String(currency[4].nominal)
        
    }

    func popoverContent( didselectItem name: String) {
        let test = blue.viewWithTag(2) as! UITextField
        test.text = name
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
    }
}
    

