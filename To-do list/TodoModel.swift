//
//  TodoListArray.swift
//  To-do list
//
//  Created by tantsunsin on 2020/8/10.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import Foundation

struct TodoItem : Codable{
    var name : String
    var isdone : Bool
}

var TodoListArray : [TodoItem] = [TodoItem(name: "送洗衣服", isdone: false), TodoItem(name: "修電腦", isdone: false), TodoItem(name: "打給客戶", isdone: false), TodoItem(name: "買貓飼料", isdone: true), TodoItem(name: "買貓砂", isdone: false), TodoItem(name: "換燈泡", isdone: false), TodoItem(name: "洗水壺", isdone: false), TodoItem(name: "叫修冷氣", isdone: false), TodoItem(name: "換機油", isdone: false), TodoItem(name: "帶外套", isdone: false), TodoItem(name: "整理公司桌面", isdone: false), TodoItem(name: "整理業績表格", isdone: false), TodoItem(name: "換被單", isdone: false), TodoItem(name: "約吃飯", isdone: false), TodoItem(name: "訂尾牙餐廳", isdone: false), TodoItem(name: "買洗衣精", isdone: false), TodoItem(name: "修眼鏡", isdone: false), TodoItem(name: "看書", isdone: false), TodoItem(name: "整理書櫃", isdone: false), TodoItem(name: "拖地", isdone: false)]
