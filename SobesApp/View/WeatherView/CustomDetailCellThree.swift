//
//  CustomDetailCellThree.swift
//  SobesApp
//
//  Created by Никита on 05.02.2021.
//

import UIKit

class CustomDetailCellThree: UITableViewCell {
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempDay: UILabel!
    @IBOutlet weak var tempNight: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
