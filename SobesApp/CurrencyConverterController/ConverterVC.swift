//
//  ConverterVC.swift
//  SobesApp
//
//  Created by Никита on 16.01.2021.
//

import UIKit

class ConverterVC: UIViewController, UITableViewDelegate, UIPopoverPresentationControllerDelegate, PopoverContentControllerDelegate{

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var updateLabel: UILabel!
    
    var staticSize: CGFloat!
    let viewCellOne = CustomViewCurrency()
    let viewCellTwo = CustomViewCurrency()
    let viewCellThree = CustomViewCurrency()
    let viewCellFour = CustomViewCurrency()
    var arrView: [CustomViewCurrency] = []
    var tagButton = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        staticSize = view.frame.size.height
        viewCellThree.isHidden = true
        viewCellFour.isHidden = true
        viewsSetting()
        
        for view in arrView {
            view.currentValue.addTarget(self, action: #selector(popoverShowFunc(_:)), for: .allTouchEvents)
            view.classField.addTarget(self, action: #selector(calculateValue(_:)), for: .editingChanged)
            stackView.addArrangedSubview(view)
        }
    }
    
    func viewsSetting() {
         let test = CurrencyUserData.getArrData()
        if !test.isEmpty {
            arrView = test
        } else {
            arrView.append(viewCellOne)
            arrView.append(viewCellTwo)
            arrView.append(viewCellThree)
            arrView.append(viewCellFour)
            viewCellOne.setParametr(charCode: "RUB")
            viewCellTwo.setParametr(charCode: "BYN")
            viewCellThree.setParametr(charCode: "USD")
            viewCellFour.setParametr(charCode: "EUR")
            for view in arrView {
                view.currentValue.tag = tagButton
                tagButton += 1
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let dateFor = Date()
//        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //CurrencyCoreData.deleteAllData()
        if currency == [] {
            CurrencyCoreData.deleteAllData()
            Network.shared.getCurrency {
                
            }
        }
        //MARK: Обновлять курсы валют при запуске
    }
    
    //MARK: tapGesture
    @IBAction func oneTabToView(_ sender: UIGestureRecognizer) {
        for view in arrView {
            view.classField.resignFirstResponder()
        }
    }
    
    
    @IBAction func removeView(_ sender: UIButton) {
        for view in arrView.sorted(by: {$0.currentValue.tag > $1.currentValue.tag }) {
            if view.isHidden == false && view.currentValue.tag >= 2 {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: .layoutSubviews) {
                    view.isHidden = true
                    view.alpha = 0
                }
                break
            }
        }
    }
    
    @IBAction func addView(_ sender: UIButton) {
        for view in arrView {
            if view.isHidden == true {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: .layoutSubviews) {
                    view.isHidden = false
                    view.alpha = 1
                }
                break
            }
        }
    }
    
    @objc func exitSave()  {
        CurrencyUserData.deleteData()
        CurrencyUserData.addNew(arrData: arrView)
    }
    
    //MARK: KeyboardSetting
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIApplication.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(exitSave), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(exitSave), name: UIApplication.willTerminateNotification, object: nil)
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
    @IBAction func popoverShowFunc(_ sender: UIButton) {
        guard let tableCurrency = storyboard?.instantiateViewController(identifier: "tableCurrency") as? CurrencyTableViewPopover else { return }
        tableCurrency.modalPresentationStyle = .popover
        let popoverController = tableCurrency.popoverPresentationController
        popoverController?.delegate = self
        tableCurrency.tag = sender.tag
        tableCurrency.delegate = self
        popoverController?.sourceView = sender
        popoverController?.sourceRect = CGRect(x: sender.bounds.midX,
                                               y: sender.bounds.midY,
                                               width: 0, height: 0)
        tableCurrency.preferredContentSize = CGSize(width: 280, height: 400)
        tableCurrency.tableView.reloadData()
        self.present(tableCurrency, animated: true, completion: nil)
    }
    
    func popoverContent(charCode: String, value: Double, name: String, tag: Int) {
        for view in arrView {
            if view.currentValue.tag == tag {
                view.addParametr(labelName: name, curse: value, currentValue: charCode)
                addNewValute(fieldClass: view, arr: arrView)
            }
        }
    }
    
    //MARK: calculateCurrency
    @objc func calculateValue(_ textField: UITextField) {
        let textFieldView = textField.superview!
        let selectedClass = textFieldView.superview as! CustomViewCurrency
        textFieldChange(fieldClass: selectedClass , arr: arrView)
        
        if textField.text == "" {
            textField.text = String(0)
        }
    }
    
    func textFieldChange(fieldClass: CustomViewCurrency, arr: [CustomViewCurrency]){
        for views in arr {
            if fieldClass != views {
                let fieldInt = Double(fieldClass.classField.text!) ?? 0.0
                views.classField.text = String(format: "%.2f", fieldInt * (fieldClass.curse  / views.curse))
            }
        }
    }
    
    func addNewValute(fieldClass: CustomViewCurrency, arr: [CustomViewCurrency]){
        for views in arr {
            if fieldClass != views {
                let viewsInt = Double(views.classField.text!) ?? 0.0
                fieldClass.classField.text = String(format: "%.2f", viewsInt * (views.curse / fieldClass.curse))
                
            }
        }
    }
}


