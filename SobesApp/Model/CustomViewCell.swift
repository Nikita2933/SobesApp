//
//  CustomViewCell.swift
//  SobesApp
//
//  Created by Никита on 11.01.2021.
//

import UIKit

class CustomViewCell: UITableViewCell {

    @IBOutlet weak var tempText: UILabel!
    @IBOutlet weak var fellsText: UILabel!
    @IBOutlet weak var pressureText: UILabel!
    @IBOutlet weak var cityNameText: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
