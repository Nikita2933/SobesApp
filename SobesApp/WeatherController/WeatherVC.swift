//
//  WeatherVC.swift
//  SobesApp
//
//  Created by Никита on 10.01.2021.
//

import UIKit
import CoreData

protocol WeatherVCDelegate: class {
    func tabSearchBar(s: String)
}

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, WeatherVCDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    let refreshControl = UIRefreshControl()
    weak var resultsController: SearchResultController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchSetting()
        tableViewSetting()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let dt = weatherData.first?.weatherDetail?.current?.dt {
            let timeCurrentWeatherDetail = Date(timeIntervalSince1970: TimeInterval(dt))
            let timeNow = Date()
            let differenceInSeconds = Int(timeNow.timeIntervalSince(timeCurrentWeatherDetail))
            if differenceInSeconds > 60 {
                WeatherCoreData.updateData { [self] in
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func refreshTableView() {
        WeatherCoreData.updateData { [self] in
            DispatchQueue.main.async {
                tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }
    }
    
    //MARK: - SearchBar
    private func searchSetting(){
        resultsController = storyboard!.instantiateViewController(withIdentifier: "SearchResultController") as? SearchResultController
        searchController = UISearchController(searchResultsController: resultsController)
        resultsController?.weatherVCDelegate = self
        searchController.searchResultsUpdater = resultsController
        searchController.delegate = self
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let searchBar = searchController.searchBar
        let atributePlaceholder = NSAttributedString(string: "Press new City", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        searchBar.searchTextField.attributedPlaceholder = atributePlaceholder
        searchBar.sizeToFit()
        searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    private func tableViewSetting(){
        tableView.register(CustomViewCell.self, forCellReuseIdentifier: "customCell")
        let xib = UINib(nibName: "CustomViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customCell")
        navigationItem.title = "Weather app"
        tableView.rowHeight = 80
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tabSearchBar(s: searchBar.text!)
        dismiss(animated: true, completion: nil)
        searchBar.text = ""
    }
    
    //MARK: - WeatherVCDelegate
    func tabSearchBar(s: String) {
        let request: NSFetchRequest<WeatherCoreData> = WeatherCoreData.fetchRequest()
        guard let weatherCoreDataList = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(request) else {return}
        
        if weatherCoreDataList.contains(where: {$0.cityName == s}) {
            let message = "This city has been added, choose new city"
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true)
        } else {
            Network.shared.getWeather(city: s, units: .met) {weather in
                let thisWeather = WeatherCoreData.addNew(save: weather)
                Network.shared.getWeatherDetail(lon: thisWeather.lon, lat: thisWeather.lat) { (weatherDetail) in
                    DispatchQueue.main.async {
                        let weather = WeatherDetailCoreData.addNew(saved: weatherDetail)
                        WeatherCoreData.addNewDetailWeather(detailWeather: weather, cityName: thisWeather.cityName!)
                        CoreDataManager.shared.saveContext()
                        self.tableView.reloadData()
                    }
                }
            }
        }
        searchController.searchBar.text = ""
    }
    
    // MARK: - table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomViewCell
        let weatherMain = weatherData[indexPath.row]
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(weatherMain.time))
        let currentTime: String = dateFormatter.string(from: date)
        
        cell.cityNameText.text = weatherMain.cityName
        cell.tempText.text = String(Int(weatherMain.temp)) + "°"
        cell.setImage(weatherMain.imageWeather!)
        cell.weatherDescriptionLabel.text = weatherMain.imageLabel
        cell.timeLabel.text = currentTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = CoreDataManager.shared.persistentContainer.viewContext
            do {
                context.delete(weatherData[indexPath.row])
                try context.save()
            } catch let error as NSError {
                print(error)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }		
    }
    
    //MARK: - table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = weatherData[indexPath.row]
        
        var detailController: WeatherDetail!
        detailController = storyboard!.instantiateViewController(withIdentifier: "weatherDetail") as? WeatherDetail
        
        if let weatherDetailRow = row.weatherDetail {
            detailController.cityName = row.cityName!
            detailController.weatherDetailWeather = weatherDetailRow
            self.show(detailController, sender: nil)
            
        } else {
            Network.shared.getWeatherDetail(lon: row.lon, lat: row.lat) { (resultWeather) in
                
                let weather = WeatherDetailCoreData.addNew(saved: resultWeather)
                WeatherCoreData.addNewDetailWeather(detailWeather: weather, cityName: row.cityName!)
                CoreDataManager.shared.saveContext()
                
                detailController.cityName = row.cityName!
                detailController.weatherDetailWeather = row.weatherDetail
                
            }
//            navigationItem.backBarButtonItem = UIBarButtonItem(title: " Back", style: .plain, target: nil, action: nil)
            self.show(detailController, sender: nil)
        }
    }
}
