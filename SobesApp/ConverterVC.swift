//
//  ConverterVC.swift
//  SobesApp
//
//  Created by Никита on 16.01.2021.
//

import UIKit

class ConverterVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var SecondView: UIView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonAnimation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    @IBAction func deleteButton(_ sender: UIButton) {
        CurrencyTest.deleteAllData()
        CoreDataManager.shared.saveContext()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func Cancel(_ sender: Any) {
        SecondView.isHidden = true
    }
    @IBAction func oneTabToView(_ sender: Any) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        UIView.transition(with: SecondView, duration: 0.4, options: .beginFromCurrentState) {
            self.SecondView.isHidden = true
        }
    }
    @IBAction func tapPickerSV(_ sender: Any) {
        
    }
    @IBAction func TestTab(_ sender: UIButton) {
        UIView.transition(with: SecondView, duration: 0.4, options: .beginFromCurrentState) {
            self.SecondView.isHidden = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row].name
        
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
