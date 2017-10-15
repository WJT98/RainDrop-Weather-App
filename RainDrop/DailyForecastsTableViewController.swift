//
//  DailyForecastsTableViewController.swift
//  RainDrop
//
//  Created by William Tang on 2017-10-09.
//  Copyright © 2017 WT. All rights reserved.
//

import UIKit
import CoreLocation


class DailyForecastsTableViewController: UITableViewController,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dailyForecasts = [dailyData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let location =  UserDefaults.standard.string(forKey: "defaultLocation") {
        getCoordinates(locationString: location)
        }
        searchBar.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                let dailyForecastData = try decoder.decode(WeatherForecasts.self, from: data)
                self.dailyForecasts = dailyForecastData.daily.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
    
    func fahrenheitToC (temp: Double) -> Double{
        return (temp - 32 ) * 5 / 9
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dailyForecasts.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "dailyForecastCell", for: indexPath)
        let weatherObject = dailyForecasts[indexPath.section]
        
        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "High of : \(Int(weatherObject.temperatureMax)) °F, Low of :\(Int(weatherObject.temperatureMin)) °F"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
     // Configure the cell...
        
    
     
     return cell
     }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return dateFormatter.string(from: date!)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
