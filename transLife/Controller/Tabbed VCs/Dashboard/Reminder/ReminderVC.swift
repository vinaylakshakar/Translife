//
//  SelectDateVC.swift
//  ctb
//
//  Created by Silstone on 30/07/19.
//  Copyright © 2019 Silstone Group. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import SVProgressHUD

class ReminderVC: UIViewController {

    //MARK: IB Outlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var viewForBlur: UIView!
    @IBOutlet weak var viewInsideBlur: UIView!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var weekHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var mondayBtn:UIButton!
    @IBOutlet weak var tuesdayBtn:UIButton!
    @IBOutlet weak var wednesdayBtn: UIButton!
    @IBOutlet weak var thursdayBtn:UIButton!
    @IBOutlet weak var fridayBtn:UIButton!
    @IBOutlet weak var saturdayBtn:UIButton!
    @IBOutlet weak var sundayBtn:UIButton!
    @IBOutlet weak var reminderDateLbl: UILabel!
    @IBOutlet weak var reminderTextViewForTitle: UITextView!
    //MARK: references
    let reminders = Reminders()
    var isMonday = false
    var isTuesday = false
    var isWednesday = false
    var isThursday = false
    var isFriday = false
    var isSaturday = false
    var isSunday = false
    let testCalendar = Calendar(identifier: .gregorian)
    var numberOfRows = 6
    var allReminders = [NSDictionary]()
    var reminderKeys = [String]()
    var cellHeightsDictionary: [AnyHashable : Any] = [:]
    //var eventStore: EKEventStore!
let eventStore = EKEventStore()
    override func viewDidLoad() {
        super.viewDidLoad()
         creatingReminderView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getReminders()
    }
    //MARK: Setup Creating Reminder view
    func creatingReminderView() {
        myDatePicker.setValue(hexStringToUIColor(hex: "#003644"), forKey: "textColor")
        let date = Date()
        myDatePicker.minimumDate = date
        //myDatePicker.setValue(false, forKey: "highlightsToday")
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMMM yyyy h:mm a"
        let dateTxt: String = formatter.string(from:myDatePicker.date)
        reminderDateLbl.text = dateTxt
        viewForBlur.isHidden = true
        switchBtn.isOn = false
        UIView.animate(withDuration: 0.6, animations: {
            self.weekHeightConstraint.constant = 0
         self.weekView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    //MARK: Setup Add Event to Calendar
    func AddReminder(Notes:String,DateTime:Date) {

     eventStore.requestAccess(to: EKEntityType.reminder, completion: {
      granted, error in
      if (granted) && (error == nil) {
        print("granted \(granted)")

        let reminder:EKReminder = EKReminder(eventStore: self.eventStore)
        reminder.title = "Must do this!"
        reminder.priority = 2
        reminder.notes = Notes
        let alarm = EKAlarm(absoluteDate: DateTime)
        reminder.addAlarm(alarm)
        let recurranceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: EKRecurrenceEnd(occurrenceCount: 2))

        //FIX for : recuurence end - Reminder Error = [A repeating reminder must have a due date.]
        let dueDate: NSDate = NSDate(timeIntervalSinceNow: 31536000) // 1 year from now
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: DateTime)
        let endRec = EKRecurrenceEnd(end: dueDate as Date)
        let recur = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: [EKRecurrenceDayOfWeek(.monday),EKRecurrenceDayOfWeek(.friday)], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: endRec)

        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let unitFlag = NSCalendar.Unit(rawValue: UInt.max)
        reminder.dueDateComponents = gregorian?.components(unitFlag, from: dueDate as Date)

        reminder.addRecurrenceRule(recur)
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()

        do {
          try self.eventStore.save(reminder, commit: true)
        } catch {
          print("Cannot save")
            print(error.localizedDescription)
          return
        }
        print("Reminder saved")
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let dateTxt: String = formatter.string(from:DateTime)
        formatter.dateFormat = "h:mm a"
        let timeTxt: String = formatter.string(from:DateTime)
        let reminderDict = ["Date":dateTxt,
                            "Time":timeTxt,
                            "Notes":Notes,
                            "timestamp":Date().timeIntervalSince1970,
                            "reminderStamp":DateTime.timeIntervalSince1970] as [String : Any]
        self.reminders.CreateReminders(Dict: reminderDict, view: self) { (err, ref) in
           if error != nil {
               SVProgressHUD.dismiss()
               print(error?.localizedDescription ?? "translife304")
           }else{
                ref.updateChildValues(["key":ref.key!])
                self.reminderTextViewForTitle.text = ""
               let alertController = UIAlertController(title: "TransLife", message: "Reminder saved successfully", preferredStyle: .alert)
               alertController.setValue(NSAttributedString(string:"TransLife", attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
               // Create the actions
               let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                   UIAlertAction in
                self.viewForBlur.isHidden = true
                self.getReminders()
                   NSLog("OK Pressed")
               }
               let cancelAction = UIAlertAction(title: "Edit", style: UIAlertAction.Style.cancel) {
                   UIAlertAction in
                   NSLog("Cancel Pressed")
               }
               
               // Add the actions
               alertController.addAction(okAction)
               // alertController.addAction(cancelAction)
               
               // Present the controller
               self.present(alertController, animated: true, completion: nil)
               // view.PresentAlert(message:"Event created successfully" , title: "TransLife")
               SVProgressHUD.dismiss()
           }
        }
      }
     })

    }
    //MARK:
    func getReminders() {
        SVProgressHUD.show()
        reminders.GetReminders(view: self) { (snap) in
            if snap.value is NSNull{
                SVProgressHUD.dismiss()
                self.myTableView.reloadData()
                self.PresentAlert(message: "No reminders found.", title: "TransLife")
            }else{
                let snapValue = snap.value  as! NSDictionary
                var nsDict = [NSDictionary]()
                for i in snapValue{
                    nsDict.append(i.value as! NSDictionary)
                }
                self.allReminders =  nsDict.sorted(by: { $0["timestamp"] as! Double > $1["timestamp"] as! Double})
                self.myTableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    //MARK: Set Weeks Background Color
       func setUpWeekDays(btn:UIButton,status:Bool) {
           btn.backgroundColor = status == true ? hexStringToUIColor(hex: "#52DBFB"):hexStringToUIColor(hex: "#FFFFFF")
       }
    // MARK: - Actions
    @IBAction func mondayBtnAction(_ sender: Any) {
        isMonday = !isMonday
        setUpWeekDays(btn: mondayBtn, status: !isMonday)
    }
    @IBAction func tuesdayBtnAction(_ sender: Any) {
        isTuesday = !isTuesday
        setUpWeekDays(btn: tuesdayBtn, status: isTuesday)
    }
    @IBAction func wednesdayBtnAction(_ sender: Any) {
        isWednesday = !isWednesday
        setUpWeekDays(btn:wednesdayBtn,status:isWednesday)
    }
    @IBAction func thursdayBtnAction(_ sender: Any) {
        isThursday = !isThursday
        setUpWeekDays(btn: thursdayBtn, status: isThursday)
    }
    @IBAction func fridayBtnAction(_ sender: Any) {
        isFriday = !isFriday
        setUpWeekDays(btn: fridayBtn, status: isFriday)
    }
    @IBAction func saturdayBtnAction(_ sender: Any) {
        isSaturday = !isSaturday
        setUpWeekDays(btn: saturdayBtn, status: isSaturday)
    }
    @IBAction func sundayBtnAction(_ sender: Any) {
        isSunday = !isSunday
        setUpWeekDays(btn: sundayBtn, status: isSunday)
    }
    @IBAction func switchBtnAction(_ sender: Any) {
        if switchBtn.isOn{
            UIView.animate(withDuration: 0.6, animations: {
                self.weekHeightConstraint.constant = 20
                self.weekView.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }else{
           UIView.animate(withDuration: 0.6, animations: {
               self.weekHeightConstraint.constant = 0
            self.weekView.alpha = 0
               self.view.layoutIfNeeded()
           }, completion: nil)
        }
    }
    @IBAction func crossBackBtnAction(_ sender: Any) {
        viewForBlur.isHidden = true
    }
    @IBAction func NewBtnAction(_ sender: UIButton)
    {
        viewForBlur.isHidden = false
    }

    @IBAction func BackBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMMM yyyy h:mm a"
        let dateTxt: String = formatter.string(from:myDatePicker.date)
        reminderDateLbl.text = dateTxt
    }
    
    @IBAction func doneBtnCreateReminderAction(_ sender: Any) {
        let myTimeStamp = self.myDatePicker?.date
        AddReminder(Notes:reminderTextViewForTitle.text, DateTime: myTimeStamp!)
    }
   
}
extension ReminderVC:UITableViewDelegate{
    //MARK:TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let DeleteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            if let CurrentUser = UserDefaults.standard.value(forKey: "username") as? String{
                let reminderkey = self.allReminders[indexPath.section]["key"] as? String
            ref.child("UserReminders").child(CurrentUser).child(reminderkey!).removeValue()
                self.getReminders()
                       }
            
            completionHandler(true)
        }
        DeleteAction.image = UIImage(named: "noun_Delete")
        DeleteAction.backgroundColor = hexStringToUIColor(hex: "#FF2D2C")
        let editAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            self.viewForBlur.isHidden = false
            //Edit title
            self.reminderTextViewForTitle.text = self.allReminders[indexPath.section]["Notes"] as? String
            //Edit date and time
            let reminderTime = self.allReminders[indexPath.section]["reminderStamp"] as? Int
            let date = Date(timeIntervalSince1970: Double(reminderTime ?? Int(Date().timeIntervalSince1970)))
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, d MMMM yyyy h:mm a"
            let dateTxt: String = formatter.string(from:date)
            self.reminderDateLbl.text = dateTxt
            self.myDatePicker.setDate(date, animated: false)
            completionHandler(true)
        }
        editAction.image = UIImage(named: "noun_edit")
        editAction.backgroundColor = hexStringToUIColor(hex: "#008DF9")
        let preventSwipeFullAction = UISwipeActionsConfiguration(actions: [DeleteAction,editAction])
        preventSwipeFullAction .performsFirstActionWithFullSwipe = false // set false to disable full swipe action
        return preventSwipeFullAction
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 10
       }
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
       }
}
extension ReminderVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return allReminders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        cell.reminderDate.text = allReminders[indexPath.section]["Date"] as? String
        cell.reminderTime.text = allReminders[indexPath.section]["Time"] as? String
        cell.reminderTextView.text = allReminders[indexPath.section]["Notes"] as? String
       
        return cell
    }
    
    
}

