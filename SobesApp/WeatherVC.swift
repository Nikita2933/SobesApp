//
//  WeatherVC.swift
//  SobesApp
//
//  Created by Никита on 10.01.2021.
//

import UIKit

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    @IBOutlet weak var searchBar: UISearchBar!
    
    
   
    @IBOutlet weak var tableView: UITableView!

    var DataReady: Bool = false
    
    var cityNames: [String] = []
    
    var weather: [WeatherData] = [WeatherData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func OneTabAny(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        tableView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.register(CustomViewCell.self, forCellReuseIdentifier: "Cell")
        let xib = UINib(nibName: "CustomViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "Cell")
        //MARK: - load CityData
//        let path = Bundle.main.path(forResource: "CityData", ofType: "plist")
//        let nameDicts = NSArray(contentsOfFile: path!)
//        let cityData = nameDicts as! [[String: Any]]
//       // let testPlistkey
//        print(testPlistkey.first)
    }
    
    //MARK: - SearchBar setting
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Network.shared.getWeather(city: searchBar.text!, units: .met) { (weatherData) in
            if weatherData != nil {
                self.weather.insert(weatherData!, at: 0)
                self.DataReady = true
            }
            
        }
        searchBar.text = ""
    }

    
    

    // MARK: - Table view data source

        func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            if !DataReady {
                return 0
            } else {
                return weather.count
            }
            
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomViewCell
            if DataReady{
                let weatherMain = weather[indexPath.row].main
                cell.cityNameText.text = weather[indexPath.row].name
                cell.tempText.text = String(weatherMain.temp!)
                cell.pressureText.text = String(weatherMain.pressure!)
                cell.fellsText.text = String(weatherMain.feels_like!)
            }
        return cell
    }

    
    // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weather.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }
    

    
    // Override to support rearranging the table view.
     func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
