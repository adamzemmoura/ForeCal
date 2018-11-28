//
//  DarkSkyWeatherAPIClient.swift
//  Tiempo
//
//  Created by Adam Zemmoura on 23/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import Foundation

protocol WeatherDataServiceProtocol {
    func getAllWeatherForLocation(lat: Double, long: Double, completion: @escaping (WeatherDataService) -> ())
    func getWeeklyForecastForLocation(lat: Double, long: Double, completion: @escaping (WeatherDataForWeek) -> ())
    func getTodaysForecastForLocation(lat: Double, long: Double, day: Date, completion: @escaping (WeatherDataForDay) -> ())
}

class DarkSkyWeatherAPIClient {
    
    static let shared = DarkSkyWeatherAPIClient()
    
    private let apiKey = ApiKeys.darkSky
    
    private lazy var base_url : URL = URL(string: "https://api.darksky.net/forecast/\(apiKey)/")!
    

    
    private init() {}
    
    // function to get the weather data for a location
    func getWeatherDataForLocation(lat : Double, long : Double, completion: @escaping (WeatherDataService) -> ()) {
        
        // create the url for the api
        var url = base_url.appendingPathComponent("\(lat),\(long)")
        let excludeQueryItem = URLQueryItem(name: "exclude", value: "minutely,hourly,alerts,flags")
        let unitQueryItem = URLQueryItem(name: "units", value: "auto")
        let queryItems : [URLQueryItem] = [excludeQueryItem, unitQueryItem]
        var components = URLComponents(string: url.absoluteString)
        components?.queryItems = queryItems
        url = components!.url!
        print(url)
        
        // call the api service using networking
        let request = URLRequest(url: url)
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error == nil {
                
                guard let data = data else { return }
                
                // parse the response using JSONDecoder
                do {
                   
                    let weatherData = try JSONDecoder().decode(WeatherDataService.self, from: data)
                    completion(weatherData)
                    
                } catch {
                    print("Something went wrong trying to decode the JSON from Dark Sky : ", error)
                }
                
                
                // print the results to the console
            }
            else {
                print("Something went wrong accessing the Dark Sky API : ", error!)
            }
            
        }
        
        session.resume()
           
    }
    
}

extension DarkSkyWeatherAPIClient : WeatherDataServiceProtocol {
    
    func getAllWeatherForLocation(lat: Double, long: Double, completion: @escaping (WeatherDataService) -> ()) {
        
        getWeatherDataForLocation(lat: lat, long: long) { (weatherDataService) in
            completion(weatherDataService)
        }
    }
    
    func getWeeklyForecastForLocation(lat: Double, long: Double, completion: @escaping (WeatherDataForWeek) -> ()) {
        
        getWeatherDataForLocation(lat: lat, long: long) { (weatherDataService) in
            if let weeklyData = weatherDataService.daily {
                completion(weeklyData)
            }
        }
        
    }
    
    func getTodaysForecastForLocation(lat: Double, long: Double, day: Date, completion: @escaping (WeatherDataForDay) -> ()) {
        getWeatherDataForLocation(lat: lat, long: long) { (weatherDataService) in
            if let WeatherDataForDay = weatherDataService.currently {
                completion(WeatherDataForDay)
            }
        }
    }
    

    
}

struct WeatherDataService : Codable {
    
    let latitude : Double
    let longitude : Double
    let timezone : String
    let currently : WeatherDataForDay? // the weather right now
    //let hourly : WeatherDataForWeek? // weather data, hour-by-hour for the next 48hrs
    let daily : WeatherDataForWeek? // weather data, day-by-day for the week
    
}

struct WeatherDataForWeek : Codable {
    
    let summary : String?
    let icon : String?
    let data : [WeatherDataForDay]
    
}

struct WeatherDataForDay : Codable {
    
    let time : Double
    let summary : String?
    let icon : String?
    let sunriseTime : Double?
    let sunsetTime : Double?
    let moonPhase : Double?
    let precipIntensity : Double?
    let precipIntensityMax : Double?
    let precipIntensityMaxTime : Double?
    let precipProbability: Double?
    let temperatureHigh : Double?
    let temperatureHighTime : Double?
    let temperatureLow : Double?
    let temperatureLowTime : Double?
    let apparentTemperatureHigh : Double?
    let apparentTemperatureHighTime : Double?
    let apparentTemperatureLow : Double?
    let apparentTemperatureLowTime : Double?
    let temperatureMin : Double?
    let temperatureMinTime : Double?
    let temperatureMax : Double?
    let temperatureMaxTime : Double?
    let apparentTemperatureMin : Double?
    let apparentTemperatureMinTime : Double?
    let apparentTemperatureMax : Double?
    let apparentTemperatureMaxTime : Double?
    let dewPoint : Double?
    let humidity : Double?
    let pressure : Double?
    let windSpeed : Double?
    let windGust : Double?
    let windGustTime : Double?
    let windBearing : Double?
    let cloudCover : Double?
    let uvIndex : Double?
    let uvIndexTime : Double?
    let visibility : Double?
    let ozone : Double?
    
}
