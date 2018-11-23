//
//  Month.swift
//  Tiempo
//
//  Created by Adam Zemmoura on 21/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import Foundation

enum Month: Int {
    case jan = 1
    case feb
    case mar
    case apr
    case may
    case jun
    case jul
    case aug
    case sept 
    case oct
    case nov
    case dec
    
    func toString() -> String {
        
        switch self {
            case Month.jan: return "January"
            case Month.feb: return "Febuary"
            case Month.mar: return "March"
            case Month.apr: return "April"
            case Month.may: return "May"
            case Month.jun: return "June"
            case Month.jul: return "July"
            case Month.aug: return "August"
            case Month.sept: return "September"
            case Month.oct: return "October"
            case Month.nov: return "November"
            case Month.dec: return "December"
        }
    }
    
}


