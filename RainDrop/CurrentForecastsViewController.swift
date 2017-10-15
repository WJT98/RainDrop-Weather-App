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
        if let location =  UserDefaults.standard.string(forKey: "defaultLocation") {
            getCoordinates(locationString: location)
        }
        searchBar2.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCurrentForecast(latitude: Double, longitude: Double, location: CLPlacemark) {
        let path = "https://api.darksky.net/forecast/a1be0ea6be0bef0fb1d19302c8acb208/" + "\(latitude),\(longitude)"
        guard let jsonURL = URL(string: path) else {return}
        URLSession.shared.dataTask(with: jsonURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let currentForecastData = try decoder.decode(WeatherForecasts.self, from: data)
                DispatchQueue.main.async {
                    self.tempLbl.text = String(currentForecastData.currently.temperature)
                    self.currentForecastIcon.image = UIImage(named: currentForecastData.currently.icon)
                    self.apparentTempLbl.text=String(currentForecastData.currently.apparentTemperature)
                    self.windLbl.text = String(currentForecastData.currently.windSpeed)
                    //self.cityLbl = location
                    self.humidityLbl.text = String(currentForecastData.currently.humidity)
                    self.cityLbl.text = location.name! + ", " + location.country!
                }
            } catch{
            }
            }.resume()
    }
    
    func getCoordinates(locationString:String) {
        CLGeocoder().geocodeAddressString(locationString) { (placemarks:[CLPlacemark]?, error:Error?) in
            guard let locationCoordinate = placemarks?.first?.location?.coordinate, let location = placemarks?.first
                else {
                    // create the alery
                    let alert = UIAlertController(title: "Location not found", message: "Please enter a valid location", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            self.updateCurrentForecast(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude, location: location)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar2: UISearchBar) {        searchBar2.resignFirstResponder()
        if let locationString = searchBar2.text, !locationString.isEmpty {
            getCoordinates(locationString: locationString)
        }
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
