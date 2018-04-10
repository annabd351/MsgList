//
//  DayMonth.swift
//  MsgList
//
//  Created by Anna Dickinson on 4/9/18.
//  Copyright © 2018 Anna Dickinson. All rights reserved.
//

import Foundation

// Used to compare Dates considering only the month and day of the month.

struct DayMonth {
    let day: Int
    let month: Int
    
    init(date: Date) {
        day = Calendar.current.component(.day, from: date)
        month = Calendar.current.component(.month, from: date)
    }
}

extension DayMonth: Equatable {
    static func ==(lhs: DayMonth, rhs: DayMonth) -> Bool {
        return lhs.day == rhs.day && lhs.month == rhs.month
    }
}
