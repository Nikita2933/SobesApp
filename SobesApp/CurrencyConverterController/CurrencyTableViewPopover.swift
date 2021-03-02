//
//  CurrencyTableViewPopover.swift
//  SobesApp
//
//  Created by Никита on 19.01.2021.
//

import UIKit

protocol PopoverContentControllerDelegate: class {
    func popoverContent(charCode: String, value: Double, name: String, tag: Int)
}

class CurrencyTableViewPopover: UITableViewController {
    
    var delegate: PopoverContentControllerDelegate?
    var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currency.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currency[indexPath.row].charCode + ":  " + currency[indexPath.row].name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = currency[indexPath.row]
        self.delegate?.popoverContent(charCode: data.charCode, value: data.value, name: data.name, tag: tag)
        dismiss(animated: true, completion: nil)
    }

}
