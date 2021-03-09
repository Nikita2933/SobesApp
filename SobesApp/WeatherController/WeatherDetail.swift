//
//  WeatherDetail.swift
//  SobesApp
//
//  Created by Никита on 04.02.2021.
//

import UIKit
import CoreData

class WeatherDetail: UITableViewController {
    
    var cityName: String = ""

    var hourly: [HourlyCD] = []
    var daily: [DailyCD] = []
    var weatherDetailWeather: WeatherDetailCoreData!
    var currentWeather: CurrentCD!
    
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
        
        settingData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(exitSave), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(exitSave), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc func exitSave() {
        DispatchQueue.main.async { [self] in
            WeatherCoreData.addNewDetailWeather(detailWeather: weatherDetailWeather, cityName: cityName)
            CoreDataManager.shared.saveContext()
        }
        
    }
    
    func settingData() {
        let sectionSortDescriptor = NSSortDescriptor(key: "dt", ascending: true)
        let inputHourly = weatherDetailWeather.hourly?.sortedArray(using: [sectionSortDescriptor])  as! [HourlyCD]
        let inputDaily = weatherDetailWeather.daily?.sortedArray(using: [sectionSortDescriptor])  as! [DailyCD]
        let inputCurrentWeather = weatherDetailWeather.current
        hourly = inputHourly
        daily = inputDaily
        currentWeather = inputCurrentWeather
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let timeCurrentWeatherDetail = Date(timeIntervalSince1970: TimeInterval(currentWeather.dt))
        let timeNow = Date()
        let differenceInSeconds = Int(timeNow.timeIntervalSince(timeCurrentWeatherDetail))
        if differenceInSeconds > 60 { //updateInterval (seconds)
            Network.shared.getWeatherDetail(lon: weatherDetailWeather.lon, lat: weatherDetailWeather.lat) { [self] (result) in
                switch result {
                
                case .success(let newWeatherDetail):
                    let weather = WeatherDetailCoreData.addNew(saved: newWeatherDetail)
                    weatherDetailWeather = weather
                    settingData()
                    WeatherCoreData.updateData {result in
                        switch result {
                        case .success(()):
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        case .failure(let error):
                            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "sure", style: .cancel, handler: nil))
                            present(alert, animated: true, completion: nil)
                        }
                        
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "sure", style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
                    }
                    break
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exitSave()
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
        case 2: return daily.count - 1
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
            cell.tempLabel.text = String(currentWeather.temp) + "°"
            cell.maxLabel.text = String(daily[0].temp!.max)
            cell.minLabel.text = String(daily[0].temp!.min)
            cell.weatherDescriptionLabel.text = currentWeather.weather!.descriptions
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
            let row = daily[indexPath.row + 1]
            let tempDay = String(row.temp!.day) + "°"
            let tempNight = String(row.temp!.night) + "°"
            let icon = UIImage(named: row.temp!.weather!.icon!)
            
            cell.tempDay.text = tempDay
            cell.tempNight.text = tempNight
            cell.weatherImage.image = icon
            cell.weekDayLabel.text = currentDateString
            
            return cell
            
        } else if indexPath.section == 3, let current = currentWeather {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFour", for: indexPath) as! CustomCurrentWeatherCell
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm" // - weekDay
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
