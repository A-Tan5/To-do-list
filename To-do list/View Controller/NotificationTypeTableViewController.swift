//
//  NotificationTypeTableViewController.swift
//  To-do list
//
//  Created by tantsunsin on 2020/9/25.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import UIKit

protocol NotiTypeDelegate {
    func sendBackType(NotificationType : TodoItem.NotificationTypes?)
}

class NotificationTypeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(sendBack))
        navigationItem.hidesBackButton = true
    }
    
    @objc func sendBack(){
        delegate?.sendBackType(NotificationType: NotificationTypeSelected)
        navigationController?.popViewController(animated: true)
    }
    
    
    var delegate : NotiTypeDelegate?
    var NotificationTypeSelected : TodoItem.NotificationTypes? //準備傳回前一頁

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TodoItem.NotificationTypes.allCases.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = TodoItem.NotificationTypes.allCases[row].rawValue

        if TodoItem.NotificationTypes.allCases[row] == NotificationTypeSelected{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let type = TodoItem.NotificationTypes.allCases[row]
        NotificationTypeSelected = type
        tableView.reloadData()

//        tableView.deselectRow(at: indexPath, animated: true)

    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
//        cell.accessoryType = .none
//    }
}
