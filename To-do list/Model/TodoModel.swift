//
//  TodoListArray.swift
//  To-do list
//
//  Created by tantsunsin on 2020/8/10.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import Foundation

//加入時間
struct TodoItem : Codable{
    var name : String
    var isdone : Bool
    
    var Notes : String?
    var Date : Date?
    var Time : Date?
    
    var EnableNotification : Bool?
    var NotificationType : NotificationTypes?
    enum NotificationTypes : String, Codable, CaseIterable{
        case TenMinutesAgo = "十分鐘前"
        case OneHourAgo = "一小時前"
        case TwoHoursAgo = "兩小時前"
        case OneDayAgo = "一天前"
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveToFile(TodoItems: [Self]){
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(TodoItems){
            let url = Self.documentsDirectory.appendingPathComponent("TodoList")
            try? data.write(to: url)
        }
    }
}
// time 的 format!
//刪到剩4個demo的
//重新命名
var TodoListArray : [TodoItem] = [TodoItem(name: "送洗衣服", isdone: false, Date: Date(), Time: Date(), EnableNotification: true, NotificationType: .OneHourAgo), TodoItem(name: "修電腦", isdone: false), TodoItem(name: "打給客戶", isdone: false), TodoItem(name: "買貓飼料", isdone: true), TodoItem(name: "買貓砂", isdone: false), TodoItem(name: "換燈泡", isdone: false), TodoItem(name: "洗水壺", isdone: false), TodoItem(name: "叫修冷氣", isdone: false), TodoItem(name: "換機油", isdone: false)]

