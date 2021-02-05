//
//  CustomDetailCellTwo.swift
//  SobesApp
//
//  Created by Никита on 05.02.2021.
//

import UIKit

class CustomDetailCellTwo: UITableViewCell, UICollectionViewDataSource {
    var hourly: [Hourly] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! CustomDetailCollectionCell
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"// 24 hour
        let hourString = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(hourly[indexPath.row].dt!)) )
        
        if indexPath.row == 0 {
            cell.timeLabel.text = "Now"
        } else {
            cell.timeLabel.text = hourString
        }
        
        cell.temp.text = String(Int(hourly[indexPath.row].temp!)) + "°"
        cell.imageLabel.image = UIImage(named: hourly[indexPath.row].weather![0].icon!)
        
        return cell
    }
    
    override func awakeFromNib() {
        collectionView.register(CustomDetailCollectionCell.self, forCellWithReuseIdentifier: "cellCollection")
        let xib = UINib(nibName: "CustomDetailCollectionCell", bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: "cellCollection")
        collectionView.reloadData()
        collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
