//
//  DateHelper.swift
//  PhotoBoi
//
//  Created by Jackson Tubbs on 8/27/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let formatter = DateFormatter()
    
    static func getStringForDate(date: Date) -> String{
        formatter.dateFormat = "M D yyyy"
        return formatter.string(from: date)
    }
}
