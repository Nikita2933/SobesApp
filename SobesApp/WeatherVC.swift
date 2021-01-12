//
//  WeatherVC.swift
//  SobesApp
//
//  Created by Никита on 10.01.2021.
//

import UIKit
import CoreData

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    
    var weather: [WeatherCoreData] = []


      
    @IBAction func OneTabAny(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        tableView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataLoad()
        
        tableView.rowHeight = 80
        tableView.register(CustomViewCell.self, forCellReuseIdentifier: "Cell")
        let xib = UINib(nibName: "CustomViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "Cell")
    }
    
    //MARK: - SearchBar setting

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Network.shared.getWeather(city: searchBar.text!, units: .met) { (weatherData) in
            if weatherData != nil {
                self.CoreDataSave(save: weatherData!)
            }
        }
        searchBar.text = ""

    }
    // MARK: - Table view data source
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            weather.count
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomViewCell
                let weatherMain = weather[indexPath.row]
                cell.cityNameText.text = weatherMain.cityName
                cell.tempText.text = String(weatherMain.temp)
                cell.pressureText.text = String(weatherMain.pressure)
                cell.fellsText.text = String(weatherMain.feels)
                return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = CoreDataManager.shared
            let context = appDelegate.persistentContainer.viewContext
            context.delete(weather[indexPath.row])
            CoreDataLoad()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }
    
    //MARK: - CoreData (WeatherEntity)
    func CoreDataSave(save: WeatherData)  {
        DispatchQueue.main.async {
            let appDelegate = CoreDataManager.shared
            let context = appDelegate.persistentContainer.viewContext
            let entity = WeatherCoreData(context: context)
            entity.cityName = save.name
            entity.feels = save.main.feels_like
            entity.pressure = Int64(save.main.pressure)
            entity.temp = save.main.temp
            do {
                try context.save()
                self.CoreDataLoad()
                self.tableView.reloadData()
            } catch  {
                print(error)
            }
        }
    }
    
    func CoreDataLoad(){
        let appDelegate = CoreDataManager.shared
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherCoreData> = WeatherCoreData.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            weather = result
        } catch let error as NSError {
            print(error)
        }
    }
}
