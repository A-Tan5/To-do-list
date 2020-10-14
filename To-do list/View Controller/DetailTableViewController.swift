//
//  DetailTableViewController.swift
//  To-do list
//
//  Created by tantsunsin on 2020/9/25.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import UIKit


class DetailTableViewController: UITableViewController, UITextViewDelegate, NotiTypeDelegate{
   


    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDatePicker()
        tableView.backgroundColor = .systemGroupedBackground
        
        
        if TodoSelected?.notes == nil{
            NotesTextView.text = "附註"
            NotesTextView.textColor = UIColor.lightGray
        }
        

//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(popToVC(sender:)))

    }
    
    //返回前一頁
    @objc func popToVC(sender : UIBarButtonItem){
        print ("日期=\(TodoSendBack?.date)")
        print("時間=\(TodoSendBack?.time)")
        navigationController?.popViewController(animated: true)
    }
    
    var TodoSelected : Todo? // 從前一頁傳來
    
    var TodoSendBack : Todo?{  //傳回前一頁、傳到下一頁
        let Name = NameTextField.text ?? ""
        let IsDone = self.TodoSelected!.isdone
        var Notes : String {
            guard NotesTextView.text != "附註" else {return ""}
            return NotesTextView.text
        }
        var date : Date?{
            guard DateSwitch.isOn == true else{return nil}
            return DateDatePicker.date
        }
        var time : Date?{
            guard TimeSwitch.isOn == true else{return nil}
            return TimeDatePicker.date
        }
        var EnableNotification : Bool? {
            guard IsEnableNotificationShown != false else {return nil}
            return EnableNotificationSwitch.isOn}
        var NotificationType : String? {
            guard EnableNotificationSwitch.isOn == true else {return nil}
            return TodoSelected?.notificationType
        }
                    
        let todo = TodoSelected!
        todo.name = Name
        todo.date = date
        todo.notes = Notes
        todo.time = time
        todo.enableNotification = EnableNotification ?? false
        todo.notificationType = NotificationType
        todo.isdone = IsDone

        container.saveContext()
        return todo
        
    
    }
    
    
    
    var NotiTypeSendBack : String? //從下一頁回傳
    

    var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

    
    
    var IsNotesTextViewStretched = false
    var IsDateDatePickerShown = false
    var IsTimeDatePickerShown = false
    var IsEnableNotificationShown = false
    var IsNotificationTypeShown = false
    
    let NotesTextViewIndex = IndexPath(row: 1, section: 0)
    let DateDatePickerIndex = IndexPath(row: 1, section: 1)
    let TimeTimePickerIndex = IndexPath(row: 3, section: 1)
    let EnableNotificationIndex = IndexPath(row: 0, section: 2)
    let NotificationTypeIndex = IndexPath(row: 1, section: 2)
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var NotesTextView: UITextView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DateSwitch: UISwitch!
    @IBOutlet weak var DateDatePicker: UIDatePicker!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var TimeSwitch: UISwitch!
    @IBOutlet weak var TimeDatePicker: UIDatePicker!
    @IBOutlet weak var EnableNotificationSwitch: UISwitch!
    @IBOutlet weak var NotificationTypeLabel: UILabel!
    
    
    
    //MARK: - configureView
    func configureView(){
        NameTextField.text = TodoSelected?.name
        NotesTextView.text = TodoSelected?.notes
        

        if let date = TodoSelected?.date {
            DateLabel.text = DateAndTimeFormatter.Dateformatter.string(from: date)
        }else{
            DateLabel.text = DateAndTimeFormatter.Dateformatter.string(from: Date())
        }
        
        if let time = TodoSelected?.time{
            TimeLabel.text = DateAndTimeFormatter.Timeformatter.string(from: time)
        }else{
            TimeLabel.text = DateAndTimeFormatter.Timeformatter.string(from: Date())
        }
        
        EnableNotificationSwitch.isOn = TodoSelected?.enableNotification ?? false
        NotificationTypeLabel.text = TodoSelected?.notificationType
        
        if TodoSelected?.date != nil{
            DateSwitch.isOn = true
            IsDateDatePickerShown = true
        }else{
            DateLabel.isHidden = true
            IsDateDatePickerShown = false
        }
        if TodoSelected?.time != nil{
            TimeSwitch.isOn = true
            IsTimeDatePickerShown = true
            IsEnableNotificationShown = true
        }else{
            TimeLabel.isHidden = true
            IsTimeDatePickerShown = false
            IsEnableNotificationShown = false
        }
        
        if let type = TodoSelected?.notificationType{
            NotificationTypeLabel.text = type
            IsEnableNotificationShown = true
            IsNotificationTypeShown = true
        }
    }
    
    func configureDatePicker(){
        DateDatePicker.locale = Locale(identifier: "zh_Hant_TW")
        DateDatePicker.timeZone = TimeZone(abbreviation: "Asia/Taipei")
        DateDatePicker.date = TodoSelected?.date ?? Date()
        
        timeDPRanged(date: TodoSelected?.date)
      
        TimeDatePicker.locale = Locale(identifier: "zh_Hant_TW")
        TimeDatePicker.timeZone = TimeZone(abbreviation: "Asia/Taipei")
        TimeDatePicker.date = TodoSelected?.time ?? Date()
    }
    
    
    //MARK: - IBAction
    @IBAction func dateDPChanged(_ sender: UIDatePicker) {
        // 改變TimeDatePicker的範圍
        
        timeDPRanged(date: sender.date)
        
        DateLabel.text = DateAndTimeFormatter.Dateformatter.string(from: sender.date)
    }
    
    @IBAction func timeDPChanged(_ sender: UIDatePicker) {
        TimeLabel.text = DateAndTimeFormatter.Timeformatter.string(from: sender.date)
    }
    
    // text field 收鍵盤
    @IBAction func keyboardDismissed(_ sender: UITextField) {
    }
    
    @IBAction func dateSwitched(_ sender: UISwitch) {
        IsDateDatePickerShown = sender.isOn ? true : false
        DateLabel.isHidden = sender.isOn ? false : true
        if sender.isOn == false{
            IsTimeDatePickerShown = false
            TimeSwitch.isOn = false
            TimeLabel.isHidden = true
            IsEnableNotificationShown = false
            EnableNotificationSwitch.isOn = false
            IsNotificationTypeShown = false
        }
        
        if let type = TodoSelected!.notificationType{
            NotificationTypeLabel.text = type
        }else{
            TodoSelected!.notificationType = "十分鐘前"
            NotificationTypeLabel.text = TodoSelected!.notificationType
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    @IBAction func timeSwitched(_ sender: UISwitch) {
        IsTimeDatePickerShown = sender.isOn ? true : false
        IsEnableNotificationShown = sender.isOn ? true : false
        EnableNotificationSwitch.isOn = sender.isOn
        IsNotificationTypeShown = sender.isOn ? true : false
        if sender.isOn == true {
            IsDateDatePickerShown = true
            DateSwitch.isOn = true
            DateLabel.isHidden = false
        }
        if sender.isOn == false {IsNotificationTypeShown = false}
        if let type = TodoSelected!.notificationType{
            NotificationTypeLabel.text = type
        }else{
            TodoSelected!.notificationType = "十分鐘前"
            NotificationTypeLabel.text = TodoSelected!.notificationType
        }
        
        TimeLabel.isHidden = sender.isOn ? false : true
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    @IBAction func notificationSwitched(_ sender: UISwitch) {
        IsNotificationTypeShown = sender.isOn ? true : false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row, indexPath.section){
        case(NotesTextViewIndex.row, NotesTextViewIndex.section):
            return IsNotesTextViewStretched ? 100 : 47
        case (DateDatePickerIndex.row, DateDatePickerIndex.section):
            return IsDateDatePickerShown ? 55 : 0
        case (TimeTimePickerIndex.row, TimeTimePickerIndex.section):
            return IsTimeDatePickerShown ? 55 : 0
        case (EnableNotificationIndex.row, EnableNotificationIndex.section):
            return IsEnableNotificationShown ? 47 : 0
        case (NotificationTypeIndex.row, NotificationTypeIndex.section):
            return IsNotificationTypeShown ? 47 : 0
        default:
            return 47
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch(indexPath.row, indexPath.section){
        case (NotesTextViewIndex.row, NotesTextViewIndex.section):
            if NotesTextView.text.isEmpty{
                IsNotesTextViewStretched = IsNotesTextViewStretched ? false : true
            }else{
                IsNotesTextViewStretched = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        case (DateDatePickerIndex.row - 1, DateDatePickerIndex.section):
            DateSwitch.isOn = IsDateDatePickerShown ? false : true
            DateLabel.isHidden = IsDateDatePickerShown ? true : false
            
            //隱藏時間跟通知
            if IsDateDatePickerShown == true{
                IsTimeDatePickerShown = false
                TimeSwitch.isOn = false
                TimeLabel.isHidden = true
                IsEnableNotificationShown = false
                EnableNotificationSwitch.isOn = false
                IsNotificationTypeShown = false
            }
            
            IsDateDatePickerShown = IsDateDatePickerShown ? false : true

            tableView.beginUpdates()
            tableView.endUpdates()

        case (TimeTimePickerIndex.row - 1, TimeTimePickerIndex.section):
            TimeSwitch.isOn = IsTimeDatePickerShown ? false : true
            if IsTimeDatePickerShown == false{
                IsDateDatePickerShown = true
                DateSwitch.isOn = true
                DateLabel.isHidden = false
                
                if let type = TodoSelected!.notificationType{
                    NotificationTypeLabel.text = type
                }else{
                    TodoSelected!.notificationType = "十分鐘前"
                    NotificationTypeLabel.text = TodoSelected!.notificationType
                }
            }
            TimeLabel.isHidden = IsTimeDatePickerShown ? true : false
            IsEnableNotificationShown = IsTimeDatePickerShown ? false : true
            IsNotificationTypeShown = IsTimeDatePickerShown ? false : true
            EnableNotificationSwitch.isOn = TimeSwitch.isOn
            IsTimeDatePickerShown = IsTimeDatePickerShown ? false : true
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (EnableNotificationIndex.row, EnableNotificationIndex.section):
            EnableNotificationSwitch.isOn = IsNotificationTypeShown ? false : true
            IsNotificationTypeShown = IsNotificationTypeShown ? false : true
            tableView.beginUpdates()
            tableView.endUpdates()

        default:
            break
        }
    }
    
    // MARK: - Text View Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        IsNotesTextViewStretched = true
        NotesTextView.setNeedsLayout()
        tableView.beginUpdates()
        tableView.endUpdates()
        
        // 收掉placeholder
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        // 點其他位置收鍵盤
        let tap = UITapGestureRecognizer(target: self, action: #selector( DetailTableViewController.hideKeyboard))
        tap.cancelsTouchesInView = false // 確保鍵盤收掉之後還能繼續按
        self.view.addGestureRecognizer(tap)
    }
    
    // text view 收鍵盤
    @ objc func hideKeyboard(tapG:UITapGestureRecognizer){
        self.NotesTextView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // 如果沒輸入東西就要回到Placeholder
        if textView.text.isEmpty {
            textView.text = "附註"
            textView.textColor = UIColor.lightGray
        }
    }

    
    // MARK: - Notification Type Delegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNotificationType"{
            let controller = segue.destination as! NotificationTypeTableViewController
            controller.delegate = self
            if let type = TodoSendBack?.notificationType{
                controller.NotificationTypeSelected = type
            }
        }
    }
    
    func sendBackType(NotificationType: String?) {
        NotiTypeSendBack = NotificationType
        print("通知形式=\(NotiTypeSendBack)")
        TodoSelected?.notificationType = NotiTypeSendBack
        NotificationTypeLabel.text = NotiTypeSendBack
    }
    
    
    func timeDPRanged(date:Date?){
        if let PreLoadedDate = date {
            TimeDatePicker.minimumDate = Date(timeIntervalSince1970: PreLoadedDate.timeIntervalSince1970 - PreLoadedDate.timeIntervalSince1970.truncatingRemainder(dividingBy: 86400) - 28800)
        
            TimeDatePicker.maximumDate = TimeDatePicker.minimumDate?.addingTimeInterval(86400)
            TimeDatePicker.date = PreLoadedDate
        }
    }
    
    
}
