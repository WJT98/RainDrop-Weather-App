//
//  WeatherForecasts.swift
//  RainDrop
//
//  Created by William Tang on 2017-10-09.
//  Copyright © 2017 WT. All rights reserved.
//

import Foundation
import UIKit
//
//  Weather2.swift
//  Raindrop
//
//  Created by William Tang on 2017-10-09.
//  Copyright © 2017 WT. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherForecasts: Codable {
    let currently: currentForecast
    let daily: dailyForecast
    
    init(currently: currentForecast, daily: dailyForecast) {
        self.currently = currently
        self.daily = daily
    }
}

struct currentForecast: Codable {
    let time: Int
    let summary: String
    let temperature: Double
    let apparentTemperature: Double
    let windSpeed: Double
    let icon: String
    let humidity: Double
    
    init(time: Int, summary:String, temperature: Double, apparentTemperature: Double, windSpeed: Double, icon: String, humidity: Double) {
        self.time = time
        self.summary = summary
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.windSpeed = windSpeed
        self.icon = icon
        self.humidity = humidity
    }
}

struct dailyForecast: Codable {
    let data: [dailyData]
     init(data: [dailyData]) {
        self.data = data
    }
 
}

struct dailyData: Codable {
    let windSpeed: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let summary: String
    let icon: String
    init(windSpeed: Double, temperatureMin: Double, temperatureMax: Double, summary: String,icon: String) {
        self.summary = summary
        self.windSpeed = windSpeed
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
        self.icon = icon
    }
}




