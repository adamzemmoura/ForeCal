//
//  WeatherDetailView.swift
//  Tiempo
//
//  Created by Adam Zemmoura on 24/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import UIKit

class CalendarOrWeatherDetailView: UIView {

    // MARK:- IBOutlets
    
    // Weather
    @IBOutlet weak var weatherForecastTitleLabel: UILabel!
    @IBOutlet weak var noForecastDataLabel: UILabel!
    
    @IBOutlet weak var dayForecastView: UIView!
    @IBOutlet weak var weatherIconLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureHighLabel: UILabel!
    @IBOutlet weak var temperatureLowLabel: UILabel!
    @IBOutlet weak var temperatureUnitsLabel: UILabel!
    @IBOutlet weak var tempStack: UIStackView!
    
    
    func configureWithWeatherData(weatherData : WeatherDataForDay) {
        
//        let time : Double
//        let summary : String?
//        let icon : String?
//        let sunriseTime : Double?
//        let sunsetTime : Double?
//        let moonPhase : Double?
//        let precipIntensity : Double?
//        let precipIntensityMax : Double?
//        let precipIntensityMaxTime : Double?
//        let precipProbability: Double?
//        let temperatureHigh : Double?
//        let temperatureHighTime : Double?
//        let temperatureLow : Double?
//        let temperatureLowTime : Double?
//        let apparentTemperatureHigh : Double?
//        let apparentTemperatureHighTime : Double?
//        let apparentTemperatureLow : Double?
//        let apparentTemperatureLowTime : Double?
//        let temperatureMin : Double?
//        let temperatureMinTime : Double?
//        let temperatureMax : Double?
//        let temperatureMaxTime : Double?
//        let apparentTemperatureMin : Double?
//        let apparentTemperatureMinTime : Double?
//        let apparentTemperatureMax : Double?
//        let apparentTemperatureMaxTime : Double?
//        let dewPoint : Double?
//        let humidity : Double?
//        let pressure : Double?
//        let windSpeed : Double?
//        let windGust : Double?
//        let windGustTime : Double?
//        let windBearing : Double?
//        let cloudCover : Double?
//        let uvIndex : Double?
//        let uvIndexTime : Double?
//        let visibility : Double?
//        let ozone : Double?
        
        configureViewsForWeather(type: .day)
        
        // set the description
        let date = Date(timeIntervalSince1970: weatherData.time)
        let formattedDate : String = date.stringWith(format: "dd MMM")
        let titleLabelText = "Weather in Barcelona on \(formattedDate) is :"
        weatherForecastTitleLabel.text = titleLabelText
        
        // set the description
        var summaryText = weatherData.summary ?? ""
        
        // set the icon
        if let icon = weatherData.icon, let weatherIcon = WeatherIcon(rawValue: icon) {
            weatherIconLabel.text = weatherIcon.image
        } else {
            weatherIconLabel.text = ""
        }
        
        // set the temp label
        if let highTemp = weatherData.temperatureHigh,
            let highTimeInterval =  weatherData.temperatureHighTime,
            let lowTemp = weatherData.temperatureLow,
            let lowTimeInterval = weatherData.temperatureLowTime {
            
//            temperatureHighLabel.text = String(Int(round(highTemp)))
//            temperatureLowLabel.text = String(Int(round(lowTemp)))
            
            tempStack.isHidden = false

            let highTime = Date(timeIntervalSince1970: highTimeInterval).stringWith(format: "HH:MM")
            let lowTime = Date(timeIntervalSince1970: lowTimeInterval).stringWith(format: "HH:MM")
            summaryText += "\n\nThe max temp : \(Int(round(highTemp)))ºC at \(highTime)."
            summaryText += "\n\nThe min temp will be \(Int(round(lowTemp)))ºC at \(lowTime)."
        } else {
//            temperatureHighLabel.text = "-"
            tempStack.isHidden = true
        }
        
        // set the description
        weatherDescriptionLabel.text = summaryText
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViewsForWeather(type: .none)
    }
    
    private enum WeatherType {
        case week
        case day
        case none
    }
    
    private func configureViewsForWeather(type : WeatherType) {
        
        switch type {
            case .week:
                noForecastDataLabel.isHidden = true
                dayForecastView.isHidden = true
            case .day:
                noForecastDataLabel.isHidden = true
                dayForecastView.isHidden = false
            case .none:
                noForecastDataLabel.isHidden = false
                dayForecastView.isHidden = true
            
        }
            
        
    }
    
    func configureWithoutWeatherData() {
        configureViewsForWeather(type: .none)
    }
    
    func configureWithWeatherData(weatherData : WeatherDataForWeek) {
        
//        let summary : String?
//        let icon : String?
//        let data : [WeatherDataForDay]
        configureViewsForWeather(type: .week)
        
    }
    
    
}
