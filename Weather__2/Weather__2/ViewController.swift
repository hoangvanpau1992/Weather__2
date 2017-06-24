//
//  ViewController.swift
//  Weather__2
//
//  Created by admin on 6/19/17.
//  Copyright © 2017 Apple lnc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var conditontexLb: UILabel!
    var weather: WeatherDays? {
        willSet {
            self.weather = DataServices.shared.weathers
        }
        didSet{
            nameLb.text = self.weather?.cityName
//            guard let degree = self.weather?.degreeTemp else {
//                return
//            }
//            degre.text = "\(degree)"
            conditontexLb.text = weather?.conditionTextCurrent
//            guard let urlImage = weather?.imgURLIcon else {
//                return
//            }
//            image.downloadImage(from: urlImage)
       }
    
 }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NotificationKey.data, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateData() {
        self.weather = DataServices.shared.weathers
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DataServices.shared.searchKey = searchBar.text ?? ""
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
