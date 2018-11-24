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
    func getWeeklyForecastForLocation(lat: Double, long: Double, completion: @escaping (WeatherDataWeekly) -> ())
    func getTodaysForecastForLocation(lat: Double, long: Double, day: Date, completion: @escaping (WeatherDataToday) -> ())
}

class DarkSkyWeatherAPIClient {
    
    static let shared = DarkSkyWeatherAPIClient()
    
    private let apiKey = ApiKeys.darkSky
    
    private lazy var base_url : URL = URL(string: "https://api.darksky.net/forecast/\(apiKey)/")!
    
    
    
    //https://api.darksky.net/forecast/a030e4e81c219e3867e60cd8d3306561/41.3851,2.1734
    
    private init() {}
    
    // function to get the weather data for a location
    func getWeatherDataForLocation(lat : Double, long : Double, completion: @escaping (WeatherDataService) -> ()) {
        
        // create the url for the api
        let url = base_url.appendingPathComponent("\(lat),\(long)")
        
        print(url)
        
        // call the api service using networking
        var request = URLRequest(url: url)
        
        // exclude data blocks not required ; minutely, hourly, alerts & flags.
        let blocksToExclude = "[minutely,hourly,alerts,flags]"
        request.addValue(blocksToExclude, forHTTPHeaderField: "exclude")
        
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
    
    func getWeeklyForecastForLocation(lat: Double, long: Double, completion: @escaping (WeatherDataWeekly) -> ()) {
        
        getWeatherDataForLocation(lat: lat, long: long) { (weatherDataService) in
            if let weeklyData = weatherDataService.daily {
                completion(weeklyData)
            }
        }
        
    }
    
    func getTodaysForecastForLocation(lat: Double, long: Double, day: Date, completion: @escaping (WeatherDataToday) -> ()) {
        getWeatherDataForLocation(lat: lat, long: long) { (weatherDataService) in
            if let weatherDataToday = weatherDataService.currently {
                completion(weatherDataToday)
            }
        }
    }
    

    
}

struct WeatherDataService : Codable {
    
    let latitude : Double
    let longitude : Double
    let timezone : String
    let currently : WeatherDataToday? // the weather right now
    //let hourly : WeatherDataWeekly? // weather data, hour-by-hour for the next 48hrs
    let daily : WeatherDataWeekly? // weather data, day-by-day for the week
    
}

struct WeatherDataWeekly : Codable {
    
    let summary : String?
    let icon : String?
    let data : [WeatherDataToday]
    
}

struct WeatherDataToday : Codable {
    
    let time : Date
    let summary : String?
    let icon : String?
    let precipIntensity : Double?
    let precipProbability: Double?
    let temperature : Double?
    let apparentTemperature : Double?
    let dewPoint : Double?
    let humidity : Double?
    let pressure : Double?
    let windSpeed : Double?
    let windGust : Double?
    let windBearing : Double?
    let cloudCover : Double?
    let uvIndex : Double?
    let visibility : Double?
    let ozone : Double?
    
    
}
