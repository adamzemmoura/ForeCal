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
        // week starts at sunday ie. 1 correlates to Sunday so adjust so that 1 correlates to Monday
        if weekday == 1 { return 7 }
        return weekday - 1
    }
    
    func firstOfMonth() -> Date {
        
        let year = Calendar.current.component(.year, from: self)
        let month = Calendar.current.component(.month, from: self)
        let day = 1 // the first of the month
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
    
    /*  Use this function to reset the date to beginning of the day so that dates can be used to check for equality ie. if a date is created at 14:00 and another 17:00 on the same day
    /   they would not match when compared for equality but resetting them both to the start of the day, dates can be used as keys in dictionaries for example.
    */
    func startOfDay() -> Date {
        let year = Calendar.current.component(.year, from: self)
        let month = Calendar.current.component(.month, from: self)
        let day =  Calendar.current.component(.day, from: self)
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
    
    func stringWith(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
