//
//  Extensions.swift
//  Tiempo
//
//  Created by Adam Zemmoura on 21/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import Foundation

extension String {
    
    static var dateFormatter : DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date : Date? {
        return String.dateFormatter.date(from: self)
    }
    
}

extension Date {
    var weekday: Int {
        let weekday = Calendar.current.component(.weekday, from: self)
        print("Weekday : ", weekday)
        // week starts at sunday ie. 1 correlates to Sunday so adjust so that 1 correlates to Monday
        if weekday == 1 { return 7 }
        return weekday - 1
    }
    var firstDayOfTheMonth: Date {
        let firstDay = Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        print("First day : ", firstDay)
        return firstDay
    }
}
