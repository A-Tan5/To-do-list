//
//  DateAndTimeFormatter.swift
//  To-do list
//
//  Created by tantsunsin on 2020/9/25.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import Foundation

class DateAndTimeFormatter{
    
    static var Dateformatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("YYYY-MM-dd EEEE")
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return formatter
    }()
    
    static var Timeformatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH-mm")
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return formatter
    }()
    
    static var DateFormatterForTableView : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("YYYY.MM.dd")
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return formatter
    }()
    
    static var DateFormatterForWeekDay : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEE")
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return formatter
    }()

}
