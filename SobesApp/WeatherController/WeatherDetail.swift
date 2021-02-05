//
//  WeatherDetail.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
//

import UIKit

class WeatherDetail: UITableViewController {
    
    var lat: Double = 0
    var lon: Double = 0
    
    var cityName: String = ""
    var temp: String = ""
    var descriptionWeather: String = ""
    var minMax: String = ""
    
    var hourly: [Hourly] = []
    var daily: [Daily] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CustomDetailCellOne.self, forCellReuseIdentifier: "cellOne")
        let xibOne = UINib(nibName: "CustomDetailCellOne", bundle: nil)
        tableView.register(xibOne, forCellReuseIdentifier: "cellOne")
        
        tableView.register(CustomDetailCellTwo.self, forCellReuseIdentifier: "cellTwo")
        let xibTwo = UINib(nibName: "CustomDetailCellTwo", bundle: nil)
        tableView.register(xibTwo, forCellReuseIdentifier: "cellTwo")
        
        tableView.register(CustomDetailCellThree.self, forCellReuseIdentifier: "cellThree")
        let xibThree = UINib(nibName: "CustomDetailCellThree", bundle: nil)
        tableView.register(xibThree, forCellReuseIdentifier: "cellThree")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Network.shared.getCurrencyDetail(lon: lon, lat: lat) { [self] (weatherData) in
            temp = String(weatherData.current!.temp!)
            descriptionWeather = weatherData.current!.weather![0].main!.description
            minMax = "max: " + String(weatherData.daily![0].temp!.max!) + "° min: " + String((weatherData.daily![0].temp?.min)!) + "°"
            self.hourly = weatherData.hourly!
            self.daily = weatherData.daily!
            daily.removeFirst()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return daily.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 130
        case 1:
            return 90
        case 2:
            return 40
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath) as! CustomDetailCellOne
            cell.cityNameLabel.text = cityName
            cell.tempLabel.text = temp + "°"
            cell.tempMaxMinLabel.text = minMax
            cell.weatherDescriptionLabel.text = descriptionWeather
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTwo", for: indexPath) as! CustomDetailCellTwo
            cell.hourly = hourly
            cell.awakeFromNib()
            return cell
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let currentDateString: String = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(daily[indexPath.row].dt!)))
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellThree", for: indexPath) as! CustomDetailCellThree
            
            cell.tempDay.text = String(daily[indexPath.row].temp!.day!) + "°"
            cell.tempNight.text = String(daily[indexPath.row].temp!.night!) + "°"
            cell.weatherImage.image = UIImage(named: daily[indexPath.row].weather![0].icon!)
            cell.weekDayLabel.text = currentDateString
            return cell
        }
    }
    
}
