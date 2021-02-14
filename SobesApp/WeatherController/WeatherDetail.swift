//
//  WeatherDetail.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
//

import UIKit
import CoreData

class WeatherDetail: UITableViewController {
    
    var lat: Double = 0
    var lon: Double = 0
    
    var cityName: String = ""
    var temp: String = ""
    var descriptionWeather: String = ""
    var min: String = ""
    var max: String = ""
    var hourly: [Hourly] = []
    var daily: [Daily] = []
    var currentWeather: Current?
    
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
            
        tableView.register(CustomCurrentWeatherCell.self, forCellReuseIdentifier: "cellFour")
        let xibFour = UINib(nibName: "CustomCurrentWeatherCell", bundle: nil)
        tableView.register(xibFour, forCellReuseIdentifier: "cellFour")
        
        NotificationCenter.default.addObserver(self, selector: #selector(exitSave), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(exitSave), name: UIApplication.willTerminateNotification, object: nil)
        
    }
    
    
    
    @objc func exitSave() {
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        Network.shared.getWeatherDetail(lon: lon, lat: lat) { [self] (weatherData) in
            temp = String(weatherData.current.temp)
            descriptionWeather = weatherData.current.weather[0].main
            min = String(weatherData.daily[0].temp.min) + "°"
            max = String(weatherData.daily[0].temp.max) + "°"
            hourly = weatherData.hourly
            daily = weatherData.daily
            currentWeather = weatherData.current
            daily.removeFirst()
            WeatherDetailCoreData.addNew(saved: weatherData)
            CoreDataManager.shared.saveContext()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let request: NSFetchRequest<WeatherDetailCoreData> = WeatherDetailCoreData.fetchRequest()
                let weather = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
                print()
            }
            
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return daily.count
        case 3: return 1
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
        case 3:
            return 280
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath) as! CustomDetailCellOne
            cell.cityNameLabel.text = cityName
            cell.tempLabel.text = temp + "°"
            cell.maxLabel.text = max
            cell.minLabel.text = min
            //cell.tempMaxMinLabel.text = minMax
            cell.weatherDescriptionLabel.text = descriptionWeather
            
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTwo", for: indexPath) as! CustomDetailCellTwo
            cell.hourly = hourly
            cell.awakeFromNib()
            
            return cell
            
        } else if indexPath.section == 2 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE" // - weekDay
            let interval = TimeInterval(daily[indexPath.row].dt)
            let weekDay = Date(timeIntervalSince1970: interval)
            let currentDateString: String = dateFormatter.string(from: weekDay)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellThree", for: indexPath) as! CustomDetailCellThree
            let row = daily[indexPath.row]
            let tempDay = String(row.temp.day) + "°"
            let tempNight = String(row.temp.night) + "°"
            let icon = UIImage(named: row.weather[0].icon)
            
            cell.tempDay.text = tempDay
            cell.tempNight.text = tempNight
            cell.weatherImage.image = icon
            cell.weekDayLabel.text = currentDateString
            
            return cell
            
        } else if indexPath.section == 3, let current = currentWeather {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFour", for: indexPath) as! CustomCurrentWeatherCell
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:MM" // - weekDay
            let sunrise = Date(timeIntervalSince1970: TimeInterval(current.sunrise))
            let sunset = Date(timeIntervalSince1970: TimeInterval(current.sunset))
            let currentSunrice: String = dateFormatter.string(from: sunrise)
            let currentSunset: String = dateFormatter.string(from: sunset)
            
            cell.sunriseLabel.text = currentSunrice
            cell.sunsetLabel.text = currentSunset
            cell.feelsLikeLabel.text = String(current.feelsLike) + "°"
            cell.pressureLabel.text = String(current.pressure) + " hPa"
            cell.dewPointLabel.text = String(current.dewPoint) + "°"
            cell.visibilityLabel.text = String(current.visibility) + " m"
            cell.uvIndexLabel.text = String(current.uvi)
            cell.windSpeedLabel.text = String(current.windSpeed) + " m/h"
            cell.humidityLabel.text = String(current.humidity) + "%"
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "elseCell", for: indexPath)
            cell.textLabel?.text = "--"
            return cell
        }
    }
}
