//
//  CurrentForecastsViewController.swift
//  RainDrop
//
//  Created by William Tang on 2017-10-09.
//  Copyright © 2017 WT. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentForecastsViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var apparentTempLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var currentForecastIcon: UIImageView!
    @IBOutlet weak var searchBar2: UISearchBar!
    @IBOutlet weak var tempLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar2.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(_ searchBar2: UISearchBar) {
        print("1")
        searchBar2.resignFirstResponder()
        if let locationString = searchBar2.text, !locationString.isEmpty {
            CLGeocoder().geocodeAddressString(locationString) { (placemarks:[CLPlacemark]?, error:Error?) in
                if error == nil {
                    if let locationString = placemarks?.first?.location {
                        print("2")
                        self.updateCurrentForecast(withLocation: locationString.coordinate)
                    }
                }
            }
        }
    }
    
    func updateCurrentForecast(withLocation location: CLLocationCoordinate2D) {
        let path = "https://api.darksky.net/forecast/a1be0ea6be0bef0fb1d19302c8acb208/" + "\(location.latitude),\(location.longitude)"
        print("\(path)")
        guard let jsonURL = URL(string: path) else {return}
        print("3")
        URLSession.shared.dataTask(with: jsonURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Something wrong")
                return
            }
            print("downloaded")
            do {
                let decoder = JSONDecoder()
                print("4")
                let currentForecastData = try decoder.decode(WeatherForecasts.self, from: data)
                print("CHANGE TEMP")
                DispatchQueue.main.async {
                    self.tempLbl.text = String(currentForecastData.currently.temperature)
                    self.currentForecastIcon.image = UIImage(named: currentForecastData.currently.icon)
                self.apparentTempLbl.text=String(currentForecastData.currently.apparentTemperature)
                    self.windLbl.text = String(currentForecastData.currently.windSpeed)
                    //self.cityLbl = location
                    self.humidityLbl.text = String(currentForecastData.currently.humidity)
                    
                    
                }
               
            } catch{
                print("something wrong after downloading")
            }
            }.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
