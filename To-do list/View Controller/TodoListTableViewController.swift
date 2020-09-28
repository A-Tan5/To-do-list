//
//  TodoListTableViewController.swift
//  To-do list
//
//  Created by tantsunsin on 2020/8/10.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import UIKit
import UserNotifications

class TodoListTableViewController: UITableViewController{
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //讀取Document Directory
        let url = TodoItem.documentsDirectory.appendingPathComponent("TodoList")
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: url), let TodoList = try? decoder.decode([TodoItem].self, from: data){
            TodoListArray = TodoList
        }

        // 讀取user defaults
        //        if let data = UserDefaults.standard.data(forKey: "TodoList"), let TodoListData = try? PropertyListDecoder().decode([TodoItem].self, from: data){
        //            TodoListArray = TodoListData
        //        }

         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    var RowSelected : Int = 0
    var TodoSelected : TodoItem?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for todoitem in TodoListArray{
            if todoitem.EnableNotification == true{
                createNotification(Todoitem: todoitem)
            }
        }
    }
    
    

    // MARK: - TableView cellForRowAt

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)as! TodoListTableViewCell

        let row = indexPath.row
    
        if TodoListArray[row].isdone == true{
            cell.accessoryType = .checkmark
            // 灰字+刪除線
            let AttributedString = NSMutableAttributedString(string: TodoListArray[row].name)
            AttributedString.setAttributes([.foregroundColor: UIColor.gray, .strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)], range: NSMakeRange(0, AttributedString.length))

            cell.NameLabel.attributedText = AttributedString
            
        }else{
            cell.accessoryType = .none
            cell.NameLabel.attributedText = NSAttributedString(string: TodoListArray[row].name)
            
        }
        
        
        if TodoListArray[row].Date != nil && TodoListArray[row].Time != nil{
            let DateSTR = DateAndTimeFormatter.DateFormatterForTableView.string(from: TodoListArray[row].Date!)
            let WeekDaySTR = DateAndTimeFormatter.DateFormatterForWeekDay.string(from: TodoListArray[row].Date!)
            let TimeSTR =  DateAndTimeFormatter.Timeformatter.string(from: TodoListArray[row].Time!)
            cell.TimeLabel.text =  DateSTR + " " + WeekDaySTR + " " + TimeSTR
            cell.TimeLabel.textColor = .systemBlue
            print (cell.TimeLabel.text!)
            print("DATE = \(TodoListArray[row].Date!)")
            print("TIME = \(TodoListArray[row].Time!)")
        }else if TodoListArray[row].Date != nil{
            let DateSTR = DateAndTimeFormatter.DateFormatterForTableView.string(from: TodoListArray[row].Date!)
            let WeekDaySTR = DateAndTimeFormatter.DateFormatterForWeekDay.string(from: TodoListArray[row].Date!)
            cell.TimeLabel.text = DateSTR + " " + WeekDaySTR
            cell.TimeLabel.textColor = .systemGray
        }else{
            cell.TimeLabel.text = ""
        }

        return cell
    }

    
    // MARK: - Table View Delegate DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TodoListArray.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            TodoListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    
    }
    

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let MovedTodo = TodoListArray[fromIndexPath.row]
        TodoListArray.remove(at: fromIndexPath.row)
        TodoListArray.insert(MovedTodo, at: to.row)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var ActionTitle : String
        ActionTitle = TodoListArray[indexPath.row].isdone ?  "Undone" : "done"
        
        let CheckDoneAction = UIContextualAction(style: .normal, title: ActionTitle, handler: {(action, sourceView, completionHandler) in
            
            TodoListArray[indexPath.row].isdone = !TodoListArray[indexPath.row].isdone
            tableView.cellForRow(at: indexPath)?.textLabel?.text = ""
            tableView.reloadRows(at: [indexPath], with: .automatic)
            print (TodoListArray[indexPath.row].isdone)
            tableView.reloadData()
        })
        
        CheckDoneAction.backgroundColor = UIColor.systemPink
        
    
        let ActionsConfig = UISwipeActionsConfiguration(actions: [CheckDoneAction])
        return ActionsConfig
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        TodoSelected = TodoListArray[row]
        RowSelected = row
        performSegue(withIdentifier: "ShowDetail", sender: self)
        
    }
    
    //MARK: - 新增Button
    
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        let controller = UIAlertController(title: "新增待辦事項", message: "", preferredStyle: .alert)
        
        controller.addTextField{ (textField) in
            textField.placeholder = "待辦事項名稱"
        }
        
        let EasyAction = UIAlertAction(title: "快速新增", style: .default) { (UIAlertAction) in
            let textfield = controller.textFields?[0]
            let TodoName = textfield!.text
            TodoListArray.append(TodoItem(name: TodoName!, isdone: false))
            self.tableView.reloadData()}

        
        let DetailAction = UIAlertAction(title: "編輯詳細資料", style: .default) { (UIAlertAction) in
            let textfield = controller.textFields?[0]
            let TodoName = textfield!.text
            self.TodoSelected = TodoItem(name: TodoName!, isdone: false)
            self.RowSelected = TodoListArray.count
            self.performSegue(withIdentifier: "ShowDetail", sender: nil)
        }
        controller.addAction(DetailAction)
        controller.addAction(EasyAction)
        present(controller, animated: true)
    
    }

    

    
    //MARK: - PREPARE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let controller = segue.destination as! DetailTableViewController
            controller.TodoSelected = TodoSelected
        }
    }
    
    
    //  MARK: -UNWIND
    
    @IBAction func unwindToTodoListTableVC(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? DetailTableViewController, let TodoItemGot = sourceViewController.TodoSendBack{
            if RowSelected <= TodoListArray.count - 1{
                TodoListArray.remove(at: RowSelected)
            }
            TodoListArray.insert(TodoItemGot, at: RowSelected)
            tableView.reloadData()
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    // MARK: -通知功能

    func createNotification(Todoitem : TodoItem){
        guard let NotificationTime = Todoitem.Time else {return}
        
        var SubTitleText : String{
            switch Todoitem.NotificationType{
            case .TenMinutesAgo:
                return "十分鐘後"
            case .OneHourAgo:
                return "一小時後"
            case .TwoHoursAgo:
                return "兩小時後"
            case .OneDayAgo:
                return "一天後"
            default:
                return ""
            }
        }
        
        
        let content = UNMutableNotificationContent()
        content.title = Todoitem.name
        content.subtitle = SubTitleText
        content.body = Todoitem.Notes ?? ""
        content.badge = 1
        content.sound = UNNotificationSound.default
//        content.categoryIdentifier = "ActionButtons"
        
        var date : Date{
            switch Todoitem.NotificationType{
            case .TenMinutesAgo:
                return NotificationTime - 600
            case .OneHourAgo:
                return NotificationTime - 3600
            case .TwoHoursAgo:
                return NotificationTime - 7200
            case .OneDayAgo:
                return NotificationTime - 86400
            default:
                return NotificationTime
            }
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "TodoNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }


    // MARK: - 資料儲存

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    //寫入 document Directory
    TodoItem.saveToFile(TodoItems: TodoListArray)
    
    //        // 寫入user defaults
    //        if let data = try? PropertyListEncoder().encode(TodoListArray){
    //            let userdefault = UserDefaults.standard
    //            userdefault.set(data, forKey: "TodoList")
    //        }
}
    


}
