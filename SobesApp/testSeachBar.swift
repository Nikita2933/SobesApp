//
//  testSeachBar.swift
//  SobesApp
//
//  Created by Никита on 12.01.2021.
//

import UIKit
import IIDadata

class testSeachBar: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private var dadata: DadataSuggestions?
    var timer = Timer()
    private var suggestions: [String] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    // MARK: table View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [self] (timer) in
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




        
        
      
