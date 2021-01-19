//
//  ConverterVC.swift
//  SobesApp
//
//  Created by Никита on 16.01.2021.
//

import UIKit

class ConverterVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var blue: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var stackTextField: [UITextField]!
    @IBOutlet var ArrView: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        
    }
    @IBAction func oneTabToView(_ sender: Any) {
        for textField in stackTextField {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func removeView(_ sender: UIButton) {
        for view in ArrView.reversed() {
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
        for view in ArrView {
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
                    print(textField.superview!.frame.origin.y)
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


    //MARK: textFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
