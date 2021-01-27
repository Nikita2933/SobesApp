//
//  WeatherVC.swift
//  SobesApp
//
//  Created by Никита on 10.01.2021.
//

import UIKit
import CoreData

protocol WeatherVCDelegate: class {
    func TabSearchBar(s: String)
}

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, WeatherVCDelegate  {
    

    @IBOutlet weak var tableView: UITableView!

    var searchController: UISearchController!
    weak var resultsController: SearchResultController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsController = storyboard!.instantiateViewController(withIdentifier: "SearchResultController") as? SearchResultController
        searchController = UISearchController(searchResultsController: resultsController)
        resultsController?.weatherVCDelegate = self
        tableView.register(CustomViewCell.self, forCellReuseIdentifier: "Cell")
        let xib = UINib(nibName: "CustomViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "Cell")
        navigationItem.title = "Weather app"
        tableView.rowHeight = 80
        searchSetting()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        WeatherCoreData.reloadData {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func OneTabAny(_ sender: UITapGestureRecognizer) {
        tableView.resignFirstResponder()
    }
    //MARK: - SearchBar
    private func searchSetting(){
        searchController.searchResultsUpdater = resultsController
        searchController.delegate = self
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Press new City"
        searchBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchBar.sizeToFit()
        searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        TabSearchBar(s: searchBar.text!)
        dismiss(animated: true, completion: nil)
            searchBar.text = ""
    }


    //Mark: - WeatherVCDelegate
    func TabSearchBar(s: String) {
        let request: NSFetchRequest<WeatherCoreData> = WeatherCoreData.fetchRequest()
        guard let weatherBool = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(request) else {return}
            if weatherBool.contains(where: {$0.cityName == s}) {
                let message = "This city has been added, choose new city"
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                present(alert, animated: true)
            } else {
                Network.shared.getWeather(city: s, units: .met) { (WeatherData) in
                    DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        searchController.searchBar.text = ""
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

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        WeatherCoreData.reloadData {
            self.tableView.reloadData()
        }
    }
}
