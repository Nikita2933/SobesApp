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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2145177126, green: 0.21455428, blue: 0.2145097256, alpha: 1)
    }
    
    // MARK: table View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherVCDelegate?.tabSearchBar(s: suggestions[indexPath.row])
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
    
    //MARK: searchBarResultUpdate Dedata
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != ""  {
            let text = searchController.searchBar.text!
            timer.invalidate()
            let constraints = "{\"country\":\"*\"}"
            timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [self] (timer) in
                try? dadata = DadataSuggestions()
                dadata?.suggestAddress(text, queryType: AddressQueryType.address, resultsCount: 10, language: "ru", constraints: [constraints] , regionPriority: nil, upperScaleLimit: "city", lowerScaleLimit: "city", trimRegionResult: false, completion: {[weak self] (response) in
                    DispatchQueue.main.async {
                        switch response{
                        case .success(let dadataData):
                            if let dsr = dadataData.suggestions?.compactMap({ $0.data?.city }) {
                                self?.suggestions = dsr
                            }
                        case .failure(let error):
                            print(error)
                            self?.suggestions = [error.localizedDescription]
                        }
                    }
                })
            })
        }
    }
}




        
        
      
