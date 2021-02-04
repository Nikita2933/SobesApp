//
//  Weather.swift
//  SobesApp
//
//  Created by Никита on 03.02.2021.
//

import UIKit

class WeatherDetail: UIViewController {
    var label: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        test.text = label
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var test: UILabel!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
