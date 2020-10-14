//
//  TodoListTableViewController.swift
//  To-do list
//
//  Created by tantsunsin on 2020/8/10.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class TodoListTableViewController: UITableViewController{
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //讀取CORE DATA
        getTodoList()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    var RowSelected : Int = 0
    var TodoSelected : Todo?
    var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for todoitem in TodoListArray{
            if todoitem.enableNotification == true{
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
            let AttributedString = NSMutableAttributedString(string: TodoListArray[row].name!)
            AttributedString.setAttributes([.foregroundColor: UIColor.gray, .strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)], range: NSMakeRange(0, AttributedString.length))

            cell.NameLabel.attributedText = AttributedString
            
        }else{
            cell.accessoryType = .none
            cell.NameLabel.attributedText = NSAttributedString(string: TodoListArray[row].name!)
            
        }
        
        
        if TodoListArray[row].date != nil && TodoListArray[row].time != nil{
            let DateSTR = DateAndTimeFormatter.DateFormatterForTableView.string(from: TodoListArray[row].date!)
            let WeekDaySTR = DateAndTimeFormatter.DateFormatterForWeekDay.string(from: TodoListArray[row].date!)
            let TimeSTR =  DateAndTimeFormatter.Timeformatter.string(from: TodoListArray[row].time!)
            cell.TimeLabel.text =  DateSTR + " " + WeekDaySTR + " " + TimeSTR
            cell.TimeLabel.textColor = .systemBlue
            print (cell.TimeLabel.text!)
            print("DATE = \(TodoListArray[row].date!)")
            print("TIME = \(TodoListArray[row].time!)")
        }else if TodoListArray[row].date != nil{
            let DateSTR = DateAndTimeFormatter.DateFormatterForTableView.string(from: TodoListArray[row].date!)
            let WeekDaySTR = DateAndTimeFormatter.DateFormatterForWeekDay.string(from: TodoListArray[row].date!)
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
//            container.viewContext.delete(TodoListArray[indexPath.row])
            TodoListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
//            container.saveContext()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    
    }
    

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let MovedTodo = TodoListArray[fromIndexPath.row]
        TodoListArray.remove(at: fromIndexPath.row)
        TodoListArray.insert(MovedTodo, at: to.row)
//        container.saveContext()
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
            
            let context = self.container.viewContext
            let todo = Todo(context: context)
            todo.name = TodoName
            TodoListArray.append(todo)
            self.container.saveContext()

            self.tableView.reloadData()}

        
        let DetailAction = UIAlertAction(title: "編輯詳細資料", style: .default) { (UIAlertAction) in
            let textfield = controller.textFields?[0]
            let TodoName = textfield!.text
            let context = self.container.viewContext
            let todo = Todo(context: context)
            todo.name = TodoName
            self.TodoSelected = todo
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
    }
    
    
    // MARK: -通知功能

    func createNotification(Todoitem : Todo){
        guard let NotificationTime = Todoitem.time else {return}
        
        var SubTitleText : String{
            switch Todoitem.notificationType{
            case "十分鐘前":
                return "十分鐘後"
            case "一小時前":
                return "一小時後"
            case "兩小時前":
                return "兩小時後"
            case "一天前":
                return "一天後"
            default:
                return ""
            }
        }
        
        
        let content = UNMutableNotificationContent()
        content.title = Todoitem.name!
        content.subtitle = SubTitleText
        content.body = Todoitem.notes ?? ""
        content.badge = 1
        content.sound = UNNotificationSound.default


        var date : Date{
            switch Todoitem.notificationType{
            case "十分鐘前":
                return NotificationTime - 600
            case "一小時前":
                return NotificationTime - 3600
            case "兩小時前":
                return NotificationTime - 7200
            case "一天前":
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


    // MARK: - 資料儲存、Core Data

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deleteAll()
        for todo in TodoListArray{
            save(TodoItem: todo)
        }

    }
    
    func deleteAll(){
        let context = container.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch  {
            print("DELETION ERROR!!")
        }
    }
    
    func save(TodoItem: Todo){
        let context = container.viewContext
        
        let todo = Todo(context: context)
        todo.name = TodoItem.name
        todo.date = TodoItem.date
        todo.notes = TodoItem.notes
        todo.time = TodoItem.time
        todo.enableNotification = TodoItem.enableNotification ?? false
        todo.notificationType = TodoItem.notificationType
        todo.isdone = TodoItem.isdone

        container.saveContext()
    }
    

    func getTodoList(){
        let context = container.viewContext
        let entityName = String(describing: Todo.self)
        let request = NSFetchRequest<Todo>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let array = try context.fetch(request)
            TodoListArray = array as [Todo]

        } catch  {
            print("error")
        }
    }

    
}
