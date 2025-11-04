//
//  NotificationsSettingVC.swift
//  transLife
//
//  Created by Developer Silstone on 21/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit


var isStatusForAllNotification = Bool()
var isStatusForPendingSurveyNotification = Bool()
var isStatusForNewSurveyNotification = Bool()
var isStatusForMoodNotification = Bool()
var isStatusForQOTDNotification = Bool()
var isStatusForEventsNotification = Bool()

class NotificationsSettingVC: UIViewController {
    
    @IBOutlet weak var MyTableView: UITableView!
    var NotificationSettingDict = [String:AnyObject]()
    let settingType = ["Allow all Notifications","Allow for Pending Surveys","Allow for New Surveys","Allow for Mood Tracker Updates","Allow for Question of the Day","Allow for Events"]
    
    // MARK: - LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
     getnotificationStatus()
        
    }
    // MARK: - getting notification status
    func getnotificationStatus() {
        let  username = UserDefaults.standard.value(forKey: "username") as! String
        ref.child("notifications_handling").child(username).observeSingleEvent(of: .value) { (snapShot) in
            let snapValue = snapShot.value as! [String:AnyObject]
            self.NotificationSettingDict = snapValue
            self.MyTableView.delegate = self
            self.MyTableView.dataSource = self
            self.MyTableView.reloadData()
        }
    }
    
    // MARK: - ACTIONS
    // MARK: - SWITCH BTN FOR ALLOWING LOCATION ACTION
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        let indexPath = mySwitch.tag
        if indexPath == 0{
            isStatusForAllNotification = value
            if value == true{
                if let username = UserDefaults.standard.value(forKey: "username") as? String{
                    ref.child("notifications_handling").child(username).updateChildValues(["status_all_notifications":value,"status_pending_surveys_notifications":value,"status_new_surveys_notifications":value,"status_mood_notifications":value,"status_qotd_notifications":value,"status_events_notifications":value])
                    
                    getnotificationStatus()
                }
            }else{
                if let username = UserDefaults.standard.value(forKey: "username") as? String{
                    ref.child("notifications_handling").child(username).updateChildValues(["status_all_notifications":value,"status_pending_surveys_notifications":value,"status_new_surveys_notifications":value,"status_mood_notifications":value,"status_qotd_notifications":value,"status_events_notifications":value])
//                    if value == false{
//                        ref.child("notifications_handling").child(username).updateChildValues(["status_all_notifications":false])
//
//                        getnotificationStatus()
//                    }
                    getnotificationStatus()
                }
            }
        }else if indexPath == 1{
            isStatusForPendingSurveyNotification = value
            if let username = UserDefaults.standard.value(forKey: "username") as? String{
                ref.child("notifications_handling").child(username).updateChildValues(["status_pending_surveys_notifications":isStatusForPendingSurveyNotification])
                if value == false{
                    ref.child("notifications_handling").child(username).updateChildValues(["status_all_notifications":false])
               getnotificationStatus()
                }
            }
        }else if indexPath == 2{
            isStatusForNewSurveyNotification = value
            if let username = UserDefaults.standard.value(forKey: "username") as? String{
                ref.child("notifications_handling").child(username).updateChildValues(["status_new_surveys_notifications":isStatusForNewSurveyNotification])
                if value == false{
                    ref.child("notifications_handling").child(username).updateChildValues(["status_all_notifications":false])
                    getnotificationStatus()
                }
            }
        }else if indexPath == 3{
            isStatusForMoodNotification = value
            if let username = UserDefaults.standard.value(forKey: "username") as? String{
                ref.child("notifications_handling").child(username).updateChildValues(["status_mood_notifications":isStatusForMoodNotification])
                if value == false{
                    ref.child("notifications_handling").child(username).updateChildValues(["status_all_notifications":false])
                 getnotificationStatus()
                }
            }
        }else if indexPath == 4{
            isStatusForQOTDNotification = value
            if let username = UserDefaults.standard.value(forKey: "username") as? String{
                ref.child("notifications_handling").child(username).updateChildValues(["status_qotd_notifications":isStatusForQOTDNotification])
                if value == false{
                    ref.child("notifications_handling").child(username).updateChildValues(["status_all_notifications":false])
                  getnotificationStatus()
                }
            }
        }else if indexPath == 5{
            isStatusForEventsNotification = value
            if let username = UserDefaults.standard.value(forKey: "username") as? String{
        ref.child("notifications_handling").child(username).updateChildValues(["status_events_notifications":isStatusForEventsNotification])
                if value == false{
                    ref.child("notifications_handling").child(username).updateChildValues(["status_all_notifications":false])
                    getnotificationStatus()
                }
            }
        }
  
    }
    
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension NotificationsSettingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTVCell", for: indexPath) as! SettingsTVCell
        cell.settingTypeLbl.text = settingType[indexPath.row]
        cell.SwitchBtn.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        cell.SwitchBtn.tag = indexPath.row
        if indexPath.row == 0{
            cell.SwitchBtn.isOn = NotificationSettingDict["status_all_notifications"] as! Bool
        }else if indexPath.row == 1{
            cell.SwitchBtn.isOn = NotificationSettingDict["status_pending_surveys_notifications"] as! Bool
        }else if indexPath.row == 2{
            cell.SwitchBtn.isOn = NotificationSettingDict["status_new_surveys_notifications"] as! Bool
        }else if indexPath.row == 3{
            cell.SwitchBtn.isOn = NotificationSettingDict["status_mood_notifications"] as! Bool
        }else if indexPath.row == 4{
            cell.SwitchBtn.isOn = NotificationSettingDict["status_qotd_notifications"] as! Bool
        }else if indexPath.row == 5{
            cell.SwitchBtn.isOn = NotificationSettingDict["status_events_notifications"] as! Bool
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
}
