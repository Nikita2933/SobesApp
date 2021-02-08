//
//  CustomViewCell.swift
//  SobesApp
//
//  Created by Никита on 11.01.2021.
//

import UIKit

class CustomViewCell: UITableViewCell {
    
    @IBOutlet weak var tempText: UILabel!
    @IBOutlet weak var cityNameText: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var lat: Double?
    var lon: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setImage(_ image : String)  {
        imageWeather.image = UIImage(named: image)
    }
    
}
