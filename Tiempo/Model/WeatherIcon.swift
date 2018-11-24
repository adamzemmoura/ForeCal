//
//  WeatherIconMap.swift
//  Tiempo
//
//  Created by Adam Zemmoura on 24/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import Foundation

enum WeatherIcon: String {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case rain
    case snow
    case sleet
    case wind
    case fog
    case cloudy
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case hail
    case thunderstorm
    case tornado
    
    var image : String {
        get {
            switch self {
                case .clearDay: return "☀️"
                case .clearNight: return "🌝"
                case .rain: return "☔️"
                case .snow: return "❄️"
                case .sleet: return "🌨"
                case .wind: return "🌬"
                case .fog: return "🌫"
                case .cloudy: return "☁️"
                case .partlyCloudyDay: return "🌤"
                case .partlyCloudyNight: return "🌗"
                case .hail: return "🌨"
                case .thunderstorm: return "⛈"
                case .tornado: return "🌪"
            }
        }
    }
}
