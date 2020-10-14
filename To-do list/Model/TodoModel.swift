//
//  TodoListArray.swift
//  To-do list
//
//  Created by tantsunsin on 2020/8/10.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import Foundation

// 已捨棄，改用Core Data
struct TodoItem : Codable{
    var name : String
    var isdone : Bool
    
    var notes : String?
    var date : Date?
    var time : Date?
    
    var enableNotification : Bool?
//    var NotificationType : NotificationTypes?
    var notificationType : String?

    
//    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//    static func saveToFile(TodoItems: [Self]){
//        let encoder = PropertyListEncoder()
//        if let data = try? encoder.encode(TodoItems){
//            let url = Self.documentsDirectory.appendingPathComponent("TodoList")
//            try? data.write(to: url)
//        }
//    }
}



// time 的 format!
//刪到剩4個demo的
//重新命名
//var TodoListArray : [TodoItem] = [TodoItem(name: "送洗衣服", isdone: false, date: Date(), time: Date(), enableNotification: true, notificationType: "一小時前"), TodoItem(name: "修電腦", isdone: false), TodoItem(name: "打給客戶", isdone: false), TodoItem(name: "買貓飼料", isdone: true), TodoItem(name: "買貓砂", isdone: false), TodoItem(name: "換燈泡", isdone: false), TodoItem(name: "洗水壺", isdone: false), TodoItem(name: "叫修冷氣", isdone: false), TodoItem(name: "換機油", isdone: false)]

var TodoListArray : [Todo] = []
