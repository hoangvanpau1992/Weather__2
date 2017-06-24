//
//  Weather.swift
//  Weather__2
//
//  Created by admin on 6/19/17.
//  Copyright © 2017 Apple lnc. All rights reserved.
//

import Foundation
typealias JSON = Dictionary<AnyHashable,Any>

struct WeatherDays {
    var degreeTempCurrent: Double
    var conditionTextCurrent: String
    var imgURLIconCurrent: String
    var cityName: String
    var lastUpdatEdepochCurrent: TimeInterval
    var weatherDays: [WeatherDay] = []
    
    init?(json: JSON) {
        guard let location = json["location"] as? JSON,
            let cityName = location["name"] as? String
            else {
                return nil
        }
        guard let current = json["current"] as? JSON,
            let tempCurrent = current["temp_c"] as? Double,
            let lastUpdatEdepoch = current["last_updated_epoch"] as? TimeInterval
            else {
                return nil
        }
        guard let condition = current["condition"] as? JSON,
            let textCurrent = condition["text"] as? String,
            let iconCurrent = condition["icon"] as? String
            else {
                return nil
        }
        guard let forecast = json["forecast"] as? JSON,
            let forecastdays = forecast["forecastday"] as? [JSON]
            else {
                return nil
         }
        for itemDay in forecastdays {
            if let weatherDay = WeatherDay(json: itemDay) {
                weatherDays.append(weatherDay)
            }
        }
        
        //        for item_L in forecastday {
//            let hour = item_L["hour"] as! [JSON]
//            for item in hour {
//                let time_Hour = item["time"] as? String
//                let tempC_Hour = item["temp_c"] as? Double
//                let condition_Hour = item["condition"] as? JSON
//                let text_Hour = condition_Hour?["text"] as? String
//                let icon_Hour = condition_Hour?["icon"] as? String
//                let weatherObject = WeatherOBject(timeHour: time_Hour!, tempCHour: tempC_Hour!, textHour: text_Hour!, iconHour: "http:\(icon_Hour!)")
//                weatherObjectarray.append(weatherObject)
//            }
        
        
        // Initialize properties
        self.cityName = cityName
        self.lastUpdatEdepochCurrent = lastUpdatEdepoch
        self.conditionTextCurrent = textCurrent
        self.degreeTempCurrent = tempCurrent
        self.imgURLIconCurrent = "http:\(iconCurrent)"
    }
}

class WeatherDay {
    var dateEpoch: TimeInterval
    var iconDay: String
    var maxtempC: Double
    var mintempC: Double
    var weatherHourDay: [WeatherHourDay] = []
    
    init?(json: JSON) {
        guard let dateEpoch = json["date_epoch"] as? TimeInterval else{
             return nil
        }
        guard let day = json["day"] as? JSON,
              let maxtempC = day["maxtemp_c"] as? Double,
              let mintempC = day["mintemp_c"] as? Double
            else{
            return nil
        }
        guard let condition = day["condition"] as? JSON,
              let iconDay = condition["icon"] as? String
        else {
            return nil
        }
        guard let hourDay = json["hour"] as? [JSON] else{
            return nil
        }
        for itemHourOfDay in hourDay {
            if let weatherHour = WeatherHourDay(json: itemHourOfDay) {
                weatherHourDay.append(weatherHour)
            }
        }
        self.dateEpoch = dateEpoch
        self.mintempC = mintempC
        self.maxtempC = maxtempC
        self.iconDay = "http:\(iconDay)"
        
        
    }
}
class WeatherHourDay {
    var timeHourDay: TimeInterval
    var tempCHourDay: Double
    var iconHourDay: String
    
    init?(json: JSON) {
        guard let timeEpoch = json["time_epoch"] as? TimeInterval else {
            return nil
        }
        guard let tempC = json["temp_c"] as? Double else {
            return nil
        }
        guard let condition = json["condition"] as? JSON,
              let iconHour = condition["icon"] as? String
        else {
            return nil
        }
        self.timeHourDay = timeEpoch
        self.tempCHourDay = tempC
        self.iconHourDay = "http:\(iconHour)"
    }
}













