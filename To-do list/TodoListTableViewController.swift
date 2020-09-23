//
//  TodoListTableViewController.swift
//  To-do list
//
//  Created by tantsunsin on 2020/8/10.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 讀取user defaults
        if let data = UserDefaults.standard.data(forKey: "TodoList"), let TodoListData = try? PropertyListDecoder().decode([TodoItem].self, from: data){
            TodoListArray = TodoListData
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TodoListArray.count
    }

    
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

        return cell
    }
    
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        let controller = UIAlertController(title: "NEW TO-DO", message: "", preferredStyle: .alert)
        
        controller.addTextField{ (textField) in
            textField.placeholder = "add in"
        }
        
        let action = UIAlertAction(title: "DONE", style: .default) { (UIAlertAction) in
            let textfield = controller.textFields?[0]
            let TodoName = textfield!.text
            TodoListArray.append(TodoItem(name: TodoName!, isdone: false))
            self.tableView.reloadData()}
            
            controller.addAction(action)
            present(controller, animated: true)
    
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
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
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let MovedTodo = TodoListArray[fromIndexPath.row]
        TodoListArray.remove(at: fromIndexPath.row)
        TodoListArray.insert(MovedTodo, at: to.row)
    }
    

    
    // Override to support conditional rearranging of the table view.
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
            })
            
            CheckDoneAction.backgroundColor = UIColor.systemPink
            
        
            let ActionsConfig = UISwipeActionsConfiguration(actions: [CheckDoneAction])
            return ActionsConfig
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIAlertController(title: "Edit Todo", message: "", preferredStyle: .alert)
        controller.addTextField { (textFields) in
            textFields.text = TodoListArray[indexPath.row].name
        }
        let action = UIAlertAction(title: "DONE", style: .default) { (UIAlertAction) in
            let TodoName = controller.textFields![0].text
            TodoListArray[indexPath.row].name = TodoName!
            tableView.reloadData()
        }
        controller.addAction(action)
        
        present(controller, animated: true)
        
        
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 寫入user defaults
        if let data = try? PropertyListEncoder().encode(TodoListArray){
            let userdefault = UserDefaults.standard
            userdefault.set(data, forKey: "TodoList")
        }
    }

        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



}
