//
//  ViewController.swift
//  Weather__2
//
//  Created by admin on 6/19/17.
//  Copyright © 2017 Apple lnc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var conditontexLb: UILabel!
    
    var locationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        return locationManager
    }()
    
    var weather: WeatherDays? {
        willSet {
            self.weather = DataServices.shared.weathers
        }
        didSet{
            nameLb.text = self.weather?.cityName
            conditontexLb.text = weather?.conditionTextCurrent
       }
    
 }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NotificationKey.data, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateData() {
        self.weather = DataServices.shared.weathers
    }
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let geoCorder = CLGeocoder()
        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        geoCorder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // City
            if let city = placeMark.addressDictionary?["City"] as? String {
                let trimmedString = city.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                DataServices.shared.searchKey = trimmedString
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                print(trimmedString)
            }
            // Country
            if let country = placeMark.addressDictionary?["Country"] as? NSString {
                print(country)
            }
            manager.stopUpdatingLocation()
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}












