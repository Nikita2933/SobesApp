//
//  testSeachBar.swift
//  SobesApp
//
//  Created by Никита on 12.01.2021.
//

import UIKit
import IIDadata

class SearchResultController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    weak var weatherVCDelegate: WeatherVCDelegate?
    private var dadata: DadataSuggestions?
    private var timer = Timer()
    private var suggestions: [String] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    // MARK: table View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherVCDelegate?.TabSearchBar(s: suggestions[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = suggestions[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != nil  {
            let text = searchController.searchBar.text!
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [self] (timer) in
                try? dadata = DadataSuggestions()
                dadata!.suggestAddress(text){[weak self] response in
                    DispatchQueue.main.async {
                        switch response{
                        case .success(let dadataData):
                            print(dadataData)
                            if let dsr = dadataData.suggestions?.compactMap({ $0.data?.city }) {
                                self?.suggestions = dsr
                            }
                        case .failure(let error):
                            print(error)
                            self?.suggestions = [error.localizedDescription]
                        }
                    }
                }
            })
        }
        
    }
}




        
        
      
