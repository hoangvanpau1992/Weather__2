//
//  TableViewController.swift
//  Weather__2
//
//  Created by admin on 6/19/17.
//  Copyright © 2017 Apple lnc. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    @IBOutlet var dayOfWeekLbCell: [UILabel]!
    @IBOutlet var iconImageLbCell: [UIImageView]!
    @IBOutlet var maxTempLbCell: [UILabel]!
    @IBOutlet var minTempLbCell: [UILabel]!
    
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var degreeLb: UILabel!
    @IBOutlet weak var maxTempCLb: UILabel!
    @IBOutlet weak var minTempCLb: UILabel!
    @IBOutlet weak var toDayOfWeek: UILabel!
    
     var identifierCountry = "VI"
    var weatherDay: WeatherDay?
    var weather: WeatherDays? {
        willSet {
            self.weather = DataServices.shared.weathers
        }
        didSet{
            guard let degree = self.weather?.degreeTempCurrent else {
            return
        }
            degreeLb.text = "\(degree)"
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
        self.collectionView.reloadData()
        self.weather = DataServices.shared.weathers
        self.weatherDay = DataServices.shared.weathers?.weatherDays[0]
        maxTempCLb.text = "\(weatherDay?.maxtempC ?? 0)"
        minTempCLb.text = "\(weatherDay?.mintempC ?? 0)"
        let dayCurrent = weatherDay?.dateEpoch ?? 0
        toDayOfWeek.text = todayOfWeek(day: dayCurrent)
        
            for index in 0..<dayOfWeekLbCell.count {
                guard let date = DataServices.shared.weathers?.weatherDays[index+1].dateEpoch else {
                    return
                }
                dayOfWeekLbCell[index].text = todayOfWeek(day: date)
                
                guard let icon = DataServices.shared.weathers?.weatherDays[index+1].iconDay else {
                    return
                }
                iconImageLbCell[index].downloadImage(from: icon)
                
                guard let temMax = DataServices.shared.weathers?.weatherDays[index+1].maxtempC else {
                    return
                }
                maxTempLbCell[index].text = "\(temMax)"
                
                guard let temMin = DataServices.shared.weathers?.weatherDays[index+1].mintempC else {
                    return
                }
                minTempLbCell[index].text = "\(temMin)"
            }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return collectionView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
}
extension TableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = DataServices.shared.weathers?.weatherDays[0].weatherHourDay.count else {
            return 0
        }
        return number
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeatherCollectionViewCell
        if let weather = DataServices.shared.weathers?.weatherDays[0].weatherHourDay[indexPath.row] {
            
            cell.tempHour.text = "\(weather.tempCHourDay)"
            cell.timeHour.text = hourDay(hour: weather.timeHourDay)
            cell.iconHour.downloadImage(from: weather.iconHourDay)
        }
        return cell
    }
//    func configureCell(cell: UICollectionViewCell, forItemAtIndexPath: IndexPath) {
//        
//    }


}











