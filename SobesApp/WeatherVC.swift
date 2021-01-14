//
//  WeatherVC.swift
//  SobesApp
//
//  Created by Никита on 10.01.2021.
//

import UIKit
import CoreData

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, WeatherVCDelegate  {

    @IBOutlet weak var tableView: UITableView!

    var searchController: UISearchController!
    var resultsController: testSeachBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultsController = storyboard!.instantiateViewController(withIdentifier: "testSeachBar") as? testSeachBar
        searchController = UISearchController(searchResultsController: resultsController)
        resultsController?.weatherVCDelegate = self
        tableView.register(CustomViewCell.self, forCellReuseIdentifier: "Cell")
        let xib = UINib(nibName: "CustomViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "Cell")
        navigationItem.title = "Weather app"
        tableView.rowHeight = 80
        searchSetting()
        
    }
    @IBAction func OneTabAny(_ sender: UITapGestureRecognizer) {
        tableView.resignFirstResponder()
    }
    
    //MARK: - SearchBar
    func searchSetting(){
        searchController.searchResultsUpdater = resultsController
        searchController.delegate = self
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Press new City"
        searchBar.sizeToFit()
        searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        testFunc(s: searchBar.text!)
        dismiss(animated: true, completion: nil)
        searchBar.text = ""
    }

    //Mark: - WeatherVCDelegate
    func testFunc(s: String) {
        Network.shared.getWeather(city: s, units: .met) { (WeatherData) in
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }
    }
        
    // MARK: - Table view data source
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            let context = CoreDataManager.shared.persistentContainer.viewContext
            do {
                context.delete(weather[indexPath.row])
                try context.save()
            } catch let error as NSError {
                print(error)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
             
        }
    }
}
