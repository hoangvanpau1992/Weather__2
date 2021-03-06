//
//  DataServicers.swift
//  Weather__2
//
//  Created by admin on 6/19/17.
//  Copyright © 2017 Apple lnc. All rights reserved.
//

import Foundation
class DataServices {
    static let shared : DataServices = DataServices()
    
    var searchKey: String = "" {
        didSet {
            weatherAtLocation(locationString: searchKey)
        }
    }
    
    var weathers : WeatherDays?
    private var _weatherHour: [WeatherHourDay]?
    var weatherHour: [WeatherHourDay] {
        get {
            if _weatherHour == nil {
                getHour()
            }
            return _weatherHour ?? []
        }
        set {
            _weatherHour = newValue
        }
    }
    func getHour(){
        if let timCurrent = weathers?.lastUpdatEdepochCurrent {
            _weatherHour = weathers?.weatherDays[0].weatherHourDay.filter({ $0.timeHourDay > timCurrent
                
            })
            
        }
    }
    
    private func  weatherAtLocation(locationString: String) {
        let baseUrl = "http://api.apixu.com/v1/forecast.json?&days=7"
        var urlString = baseUrl
        var parameter : Dictionary<String, String> = [:]
        parameter["q"] = searchKey
        parameter["key"] = "f3d902b438a3451c92605731171906"
        
        for (key,value) in parameter {
            urlString += "&" + key + "=" + value
        }
        
        guard let url = URL(string: urlString)   else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        makeDataTaskRequest(request: urlRequest) { self.weathers = WeatherDays(json: $0)
            NotificationCenter.default.post(name: NotificationKey.data, object: nil)
        }
    }
    
    
    private func makeDataTaskRequest(request: URLRequest, completedBlock: @escaping (JSON) -> Void ) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonObject =  try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) else {
                return
            }
            guard let json = jsonObject as? JSON else {
                return
            }
            DispatchQueue.main.async {
                completedBlock(json)
            }
        }
        task.resume()
    }
}
