//
//  DashboardVC.swift
//  transLife
//
//  Created by Developer Silstone on 10/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import UserNotifications

var ispendingMandSurvey = false
var isAnsweredQOTD = false
var quesID = String()
var needToRefresh = false
//var userDefaultHaveSurveyData = false
//var userDefaultHaveMoodData = false

class DashboardVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ans = ""
    var options = [String]()
    let question = QuestionOfTheDay()
    var todayQues = [String:Any]()
    let announce = Announcements()
    let events = Events()
    let UserMood = MoodLog()
    var SurveyRows = [String]()
    var totalSurvey = Int()
    var mandatoryArr = [NSDictionary]()
    var sortedMandArr = [NSDictionary]()
    var MoodDict = [AnyObject]()
    var SortedMoodDict = [AnyObject]()
    var allEventsDate = [Date]()
    var FinalallEventsDate = [Date]()
    var finalEventsDay = [String]()
    var finalEventsMonth = [String]()
    var timeStampMood = Int()
    var timeStampMoodarr = [Int]()
    var announcementReadStatus = [Bool]()
    
    
    var cellHeightsDictionary: [AnyHashable : Any] = [:]
    var extraTVCell = 0
    var extraTVCellsurvey = 0
    var totalCell = 0
    
    var isMoodNegative = false
    var userHasLoggedMood = false
    var DailyQuote:String?
    var myQuoteArray = ["daily quotes 1","daily quotes 2","daily quotes 3","daily quotes 4","daily quotes 5","daily quotes 6","daily quotes 7"]
    var DailyQuotelabel = String()
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        markUserOnline()
        if Reachability.isConnectedToNetwork(){
            GetUnreadAnnouncements()
        }else{
            self.PresentAlert(message: "Please connect to cellular or Wi-Fi.", title: "Translife")
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
       self.navigationController?.navigationBar.isHidden = true
    }
    //MARK:PULL TO REFRESH
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(DashboardVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
       GetUnreadAnnouncements()
      
        refreshControl.endRefreshing()
    }
    
    //MARK: ADD LOCAL NOTIFICATION
    func localNotification() {
        // 1
        let content = UNMutableNotificationContent()
        content.title = "Pending Mandatory Survey"
       // content.subtitle = "from ioscreator.com"
        content.body = "You have \(sortedMandArr.count) mandatory survey left. You will not be able to use the application untill you complete the left mandatory surveys."
        content.sound = UNNotificationSound.default
        
        // 2
//        let imageName = "applelogo"
//        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
//
//        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
//
//        content.attachments = [attachment]
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:3600, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: "notification.id.01", actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    //MARK: REMOVE LOCAL NOTIFICATION
    func removeLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["notification.id.01"])
        center.removeDeliveredNotifications(withIdentifiers: ["notification.id.01"])
    }
    //MARK:GET UNREAD ANNOUNCEMENT
    func GetUnreadAnnouncements() {
        needToRefresh = false
        SVProgressHUD.show()
        print(auth.currentUser?.email ?? "trns12")
        if let currentuser = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("users").child(currentuser).observeSingleEvent(of: .value, with: { (snap) in
                if snap.value is NSNull{
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        SVProgressHUD.dismiss()
                    } catch let signOutError as NSError {
                        
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let loginView = storyboard.instantiateViewController(withIdentifier: "RootNav")
                    UIApplication.shared.keyWindow?.rootViewController = loginView
                }
            })
            announce.getAnnouncements(view: self) { (snap) in
                 self.announcementReadStatus.removeAll()
                if snap.value is NSNull{
                    self.GetDailyQuotes()
                }else{
                    let snapValue = snap.value  as! NSDictionary
                    for i in snapValue{
                        let snapKeys = i.key
                ref.child("userAnnouncementDetail").child(currentuser).child(snapKeys as! String).observeSingleEvent(of:.value, with: {
                            (dataSnap) in
                            if dataSnap.value is NSNull{
                                let status = false
                                 self.announcementReadStatus.append(status)
                                // self.GetDailyQuotes()
                            }else{
                                let snap = dataSnap.value as! [String:Any]
                                    let status = snap["readStatus"] as! Bool
                                    if status == false{
                                        self.announcementReadStatus.append(status)
                               }
                            }
                        })
                    }
                    self.GetDailyQuotes()
                }
            }
            
        }else{
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snap) in
            self.announcementReadStatus.removeAll()
            if snap.value is NSNull{
              
            }else{
                let snapValue = snap.value as! [String:AnyObject]
                for i in snapValue{
                    let detail = i.value
                    if let email = detail["Email"] {
                
                        if email as? String == auth.currentUser?.email{
                        let username = detail["username"] as! String
         ref.child("userAnnouncementDetail").child(username).observeSingleEvent(of:.value, with: {
                                (dataSnap) in
                                if dataSnap.value is NSNull{
                                }else{
                                let snap = dataSnap.value as! [String:AnyObject]

                                for i in snap{
                                    let readStatusval = i.value
                                    let status = readStatusval["readStatus"] as! Bool

                                    if status == false{
                                        self.announcementReadStatus.append(status)
                                    }
                                }
                               // self.GetEventDate()
                        }
                            })
                    }
                  }
                }
             }
            self.GetDailyQuotes()
        })
        }
    }
    //MARK:GET DAILY QUOTES
    func GetDailyQuotes() {
        ref.child("DailyQuotes").observeSingleEvent(of: .value) { (snap) in
            self.DailyQuote?.removeAll()
            if snap.value is NSNull{
                self.userLastLoggedMood()
            }else{
                let snapValue = snap.value as! [String:AnyObject]
                
                for i in snapValue {
                    let values = i.value as! [String:AnyObject]
                    let datStamp = values["createdDate"] as! Double
                    let datefromstamp = Date(timeIntervalSince1970: datStamp )
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM dd, yyyy"
                    dateFormatter.timeZone = NSTimeZone.local//NSTimeZone(abbreviation: "GMT") as TimeZone?
                    let StrDate = dateFormatter.string(from: datefromstamp)
                    let day = Date()
                    dateFormatter.dateFormat = "MMMM dd, yyyy"
                    dateFormatter.timeZone = NSTimeZone.local
                    let StrDay = dateFormatter.string(from: day)
                    if StrDay == StrDate {
                        let dailyQuote = values["quote"] as! String
                      self.DailyQuote = dailyQuote
                        break
                    }else{
                       self.DailyQuote = nil
                    }
                }
                self.userLastLoggedMood()
            }
        }
    }
    //MARK:GETTING USER MOODLOG
    func GettingUserMoodLog() {
        UserMood.GetUserMoodLog(view: self) { (snap) in
            self.timeStampMoodarr.removeAll()
            if snap.value is NSNull{
                self.userHasLoggedMood = false
                self.GettingQuestion()
            }else{
                self.userHasLoggedMood = true
                let snapValue = snap.value as! [String:AnyObject]
                for i in snapValue {
                    let detail = i.value
                    let timeStamp = detail["currentTimeStamp"] as! NSNumber
                    let orderNumberInt  = timeStamp.intValue
                    self.timeStampMoodarr.append(orderNumberInt)
                    self.MoodDict.append(detail)
                }
                let sortedArr =  self.MoodDict.sorted(by: { $0["currentTimeStamp"] as! Double > $1["currentTimeStamp"] as! Double })
                self.SortedMoodDict = sortedArr
                let lastMood = sortedArr.first?["mood"] as! String
                
                if self.userHasLoggedMood == true{
                    if let mostRecent = self.timeStampMoodarr.max() {
                        self.timeStampMood = mostRecent
                        let currentTimestemp = Int(Date().timeIntervalSince1970)
                        let timediffernece = Double(currentTimestemp - mostRecent)
                        let timeInHours = abs(timediffernece/3600)
                        let timeInMin = abs(timediffernece/60)
//                        let remainderMin = timediffernece.truncatingRemainder(dividingBy: 3600)
//                        let remainderSec = timediffernece.truncatingRemainder(dividingBy: 60)
                        UserDefaults.standard.set(true, forKey: "userhasloggedmood")
                        UserDefaults.standard.set(mostRecent, forKey: "lastmoodloggedstamp")
                        UserDefaults.standard.set(lastMood, forKey: "mood")
                        if timeInHours < 24{
                            if timeInHours<1{
                                if timeInMin<1{
                                }
                            }
                        }else{
//                            let days = timeInHours / 24
//                            let hours = timeInHours.truncatingRemainder(dividingBy: 24)
                            if lastMood == "Awful" || lastMood == "Bad" || lastMood == "Not Good" {
                                self.extraTVCell = 0
                                self.isMoodNegative = false
                            }else{
                                self.extraTVCell = 0
                                self.isMoodNegative = false
                            }
                        }
                    }
                }
                 self.GettingQuestion()
            }
        }
    }
    func userLastLoggedMood() {
        
        if let userLoggedMood = UserDefaults.standard.value(forKey: "userhasloggedmood") {
            userHasLoggedMood = userLoggedMood as! Bool
                let lastMood = UserDefaults.standard.value(forKey: "mood") as! String
                self.timeStampMood = UserDefaults.standard.value(forKey: "lastmoodloggedstamp") as! Int
              let mostRecent = self.timeStampMood as Int
                let currentTimestemp = Int(Date().timeIntervalSince1970)
                let timediffernece = Double(currentTimestemp - mostRecent)
                let timeInHours = abs(timediffernece/3600)
                let timeInMin = abs(timediffernece/60)
          
                if timeInHours < 24{
                    if timeInHours<1{
                        
                        if timeInMin<1{
                        }
                    }
                }else{
                    if lastMood == "Awful" || lastMood == "Bad" || lastMood == "Not Good" {
                        self.extraTVCell = 0
                        self.isMoodNegative = false
                    }else{
                        self.extraTVCell = 0
                        self.isMoodNegative = false
                    }
                }
            self.GettingQuestion()
        
        }else{
            GettingUserMoodLog()
          
        }
      
    }
    //MARK:GETTING QUESTION
    func GettingQuestion() {
        //  SVProgressHUD.show()
        
        question.GetQuestion(view: self) { (snap) in
            self.todayQues.removeAll()
            self.options.removeAll()
            quesID.removeAll()
            if snap.value is NSNull{
                     self.GetEventDate()
            }else{
                let snapValue = snap.value as! [String:AnyObject]
            
            for i in snapValue {
                let values = i.value as! [String:AnyObject]
                let datStamp = values["createdDate"] as? Double
                let datefromstamp = Date(timeIntervalSince1970: datStamp ?? 0 )
                let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM dd, yyyy"
                    dateFormatter.timeZone = NSTimeZone.local//NSTimeZone(abbreviation: "GMT") as TimeZone?
                 let StrDate = dateFormatter.string(from: datefromstamp)
                    let day = Date()
                    dateFormatter.dateFormat = "MMMM dd, yyyy"
                    dateFormatter.timeZone = NSTimeZone.local//NSTimeZone(abbreviation: "GMT") as TimeZone?
                let StrDay = dateFormatter.string(from: day)
                    if StrDay == StrDate {
                        let ques = values["question"] as! String
                        self.todayQues = values
                        quesID = i.key
                        let opt = values["AnswerOptions"]
                        let optionsArr = opt ?? "" as AnyObject
                        self.options = optionsArr.components(separatedBy: ",")
                    }

            }
                if let currentuser = UserDefaults.standard.value(forKey: "username") as? String{
                    isAnsweredQOTD = false
                    ref.child("UsersAnswerForDailyQuestion").child(currentuser).observeSingleEvent(of: .value, with: { (DataSnapshot) in
                        if DataSnapshot.value is NSNull{
                            
                        }else{
                            let value = DataSnapshot.value as! NSDictionary
                            for i in value{
                                if quesID == i.key as! String{
                                    let optionIndex = Int(i.value as! String)
                                    UserDefaults.standard.set( self.options[optionIndex!], forKey: "userAnswer")
                                    UserDefaults.standard.synchronize()
                                    isAnsweredQOTD = true
                                }
                            }
                        }
                    
                    })
                }
//                self.question.GetAllAnswersOfCommunity(view: self) { (snap) in
//                    if snap.value is NSNull{
//
//                    }else{
//                        let snapValue = snap.value as! NSDictionary
//                        for i in snapValue{
//                            let val = i.value as! NSDictionary
//                            for n in val{
//                                print(n)
//                                if quesID == n.key as! String{
//                                     isAnsweredQOTD = true
//
//                                }
//                            }
//                        }
//                    }
//                }
        self.GetEventDate()
        }
        }
    }
    //MARK:GET EVENT DATE
    func GetEventDate() {
        events.GetEvents(view: self) { (snap) in
            self.allEventsDate.removeAll()
            self.FinalallEventsDate.removeAll()
            self.finalEventsDay.removeAll()
            self.finalEventsMonth.removeAll()
            if snap.value is NSNull{
                self.getUserSurveyStatus()
            }else{
            let snapValue = snap.value as! [String:AnyObject]
                for i in snapValue{
                let detail = i.value
                     let timestamp = detail["EventTimeStamp"] as? Double
                    let today = Date().timeIntervalSince1970
                    let datefromstamp = Date(timeIntervalSince1970: timestamp ?? 0 )
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd,yyyy"
                    
                    let date = dateFormatter.date(from: (dateFormatter.string(from: datefromstamp)))
                    
                    if today <= timestamp ?? -65000 + 65000 {
                    self.allEventsDate.append(date!)
                }
                let uniqueOrdered = Array(NSOrderedSet(array: self.allEventsDate))
                let ready = uniqueOrdered.sorted(by: {($0 as AnyObject).timeIntervalSince1970 < ($1 as AnyObject).timeIntervalSince1970})
                self.FinalallEventsDate = ready as! [Date]
            }
            self.getUserSurveyStatus()
            }
        }
        
    }
    //MARK:GETTING SURVEY STATUS
    func getUserSurveyStatus() {
//        if  let SurveyRows = UserDefaults.standard.value(forKey: "SurveyRows") {
//            if  (SurveyRows as! [String]).count != 0 {
//
//                if let mandatoryArr = UserDefaults.standard.value(forKey: "MandatoryArr") {
//                    self.mandatoryArr = mandatoryArr as! [NSDictionary]}
//                if let totalSurvey = UserDefaults.standard.value(forKey: "TotalSurvey"){
//                    self.totalSurvey = totalSurvey as! Int}
//                if let SurveyRows = UserDefaults.standard.value(forKey: "SurveyRows"){
//                    self.SurveyRows = SurveyRows as! [String]}
//            if self.mandatoryArr.count != 0{
//                let sortedMand =  self.mandatoryArr.sorted(by: { $0["currentTimeStamp"] as! Double > $1["currentTimeStamp"] as! Double })
//                self.sortedMandArr = sortedMand
//                let timeStmp = sortedMand.last?["currentTimeStamp"] as! NSNumber
//                let currentTimestemp = Int(Date().timeIntervalSince1970)
//                let timediffernece = Double(currentTimestemp - Int(truncating: timeStmp))
//                let timeInHours = abs(timediffernece/3600)
//                let timeInMin = abs(timediffernece/60)
//                if timeInHours > 24{
//                    self.extraTVCellsurvey = 1
//                    ispendingMandSurvey = true
//                }else{
//                    self.extraTVCellsurvey = 0
//                    ispendingMandSurvey = false
//                }
//                self.totalCell = self.extraTVCellsurvey + self.extraTVCell
//                self.tableView.dataSource = self
//                self.tableView.delegate = self
//                self.tableView.reloadData()
//                SVProgressHUD.dismiss()
//            }else{
//                self.extraTVCellsurvey = 0
//                ispendingMandSurvey = false
//                self.totalCell = self.extraTVCellsurvey + self.extraTVCell
//                self.tableView.dataSource = self
//                self.tableView.delegate = self
//                self.tableView.reloadData()
//                SVProgressHUD.dismiss()
//            }
//
//        }
//
//    }else{
            if let username = UserDefaults.standard.value(forKey: "username") as? String{
                let DEVICE_TOKEN = UserDefaults.standard.value(forKey: "device_token") as? String
                
                ref.child("userSurveyDetail").child(username).observeSingleEvent(of: .value) { (snap) in
//                    ref.child("users").child(username).updateChildValues(["device_token":DEVICE_TOKEN as Any])
                    self.totalCell = 0
                    self.SurveyRows.removeAll()
                    self.mandatoryArr.removeAll()
                    self.sortedMandArr.removeAll()
                    if snap.value is NSNull{
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }else{
                        let snapValue = snap.value as! [String:AnyObject]
                        self.totalSurvey = snapValue.count
                        for i in snapValue{
                            if i.value["status"] as? Bool == false{
                                self.SurveyRows.append(i.key)
                            }
                            if i.value["status"] as? Bool == false && i.value["type"] as? String == "mandatory"{
                                self.mandatoryArr.append(i.value as! NSDictionary)
                            }
                        }
                        if self.mandatoryArr.count != 0{
                            let sortedMand =  self.mandatoryArr.sorted(by: { $0["currentTimeStamp"] as! Double > $1["currentTimeStamp"] as! Double })
                            self.sortedMandArr = sortedMand
                            let timeStmp = sortedMand.last?["currentTimeStamp"] as! NSNumber
                            let currentTimestemp = Int(Date().timeIntervalSince1970)
                            let timediffernece = Double(currentTimestemp - Int(truncating: timeStmp))
                            let timeInHours = abs(timediffernece/3600)
                            let timeInMin = abs(timediffernece/60)
                            if timeInHours > 24{
                                self.extraTVCellsurvey = 1
                                ispendingMandSurvey = true
                                self.localNotification()
                            }else{
                                self.extraTVCellsurvey = 0
                                ispendingMandSurvey = false
                                self.removeLocalNotification()
                            }
                            UserDefaults.standard.set( self.SurveyRows, forKey: "SurveyRows")
                            UserDefaults.standard.set( self.mandatoryArr, forKey: "MandatoryArr")
                            UserDefaults.standard.set( self.totalSurvey, forKey: "TotalSurvey")
                            UserDefaults.standard.set( true, forKey: "userDefaultHaveSurveyData")
                            self.totalCell = self.extraTVCellsurvey + self.extraTVCell
                        
                        }else{
                            self.extraTVCellsurvey = 0
                            ispendingMandSurvey = false
                            self.totalCell = self.extraTVCellsurvey + self.extraTVCell
                          
                        }
                        
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.tableView.reloadData()
                            SVProgressHUD.dismiss()
                        
                       
                    }
                }
            }
       // }
    }
    override func viewDidAppear(_ animated: Bool) {
     navigationController?.navigationBar.barStyle = .default
    }
    //Mark user online
    func markUserOnline() {
        //make user online
        let usersRef = Database.database().reference(withPath: "usersChat")
        
        usersRef.observe(.value, with: { snapshot in
            
            for user in snapshot.children {
                let currentUser = User(snapshot: user as! DataSnapshot)
                
                if(currentUser.key == Auth.auth().currentUser?.uid){
                    currentUser.ref?.updateChildValues([
                        "online": true
                        ])
                    let currentUserRef = usersRef.child(currentUser.key)
                    currentUserRef.onDisconnectSetValue(currentUser.toOffline())
                    
                }
            }
            
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        needrefreshforEvents = true
        needRefreshResource = true
        needRefreshforlocal = true
        if needToRefresh == true{
            if Reachability.isConnectedToNetwork(){
                GetUnreadAnnouncements()
            }else{
                self.PresentAlert(message: "Translife", title: "Please connect to cellular or Wi-Fi.")
            }
        }else{
            
        }
        isAnsweredQOTD = (UserDefaults.standard.value(forKey: "qotd_answered") != nil)
        DispatchQueue.main.async {
            //Do UI Code here.
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.addSubview(self.refreshControl)
        }
        
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem.imageInsets.bottom = -5
        self.tabBarItem.imageInsets.top = 5
        self.tabBarItem.image = UIImage(named: "nav_dashboard_unselected")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "nav_dashboard_selected")?.withRenderingMode(.alwaysOriginal)
        
    }
    //MARK:ACTIONS
    
    @IBAction func chatBtn(_ sender: Any) {
        PushTo(FromVC: self, ToStoryboardID: "UsersViewController")
    }
    
    @IBAction func SettingsBtnAct(_ sender: Any) {
        PushTo(FromVC: self, ToStoryboardID: "SettingsVC")
    }
    @IBAction func calendarBtnAct(_ sender: Any) {
        PushTo(FromVC: self, ToStoryboardID: "ReminderVC")
    }
}

extension DashboardVC:UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate{
    
    //MARK:TABLEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cell = totalCell != 0 ? totalCell : 0
        return 6 + cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if totalCell == 1 && isMoodNegative == true{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
                cell.contentView.backgroundColor = hexStringToUIColor(hex: "#FF2D2C")
                //  if let mostRecent = self.timeStampMood.max() {
                let mostRecent = self.timeStampMood
                let currentTimestemp = Int(Date().timeIntervalSince1970)
                let timediffernece = Double(currentTimestemp - mostRecent)
                let timeInHours = abs(timediffernece/3600)
                let timeInMin = abs(timediffernece/60)
                let remainderMin = timediffernece.truncatingRemainder(dividingBy: 3600)
                let remainderSec = timediffernece.truncatingRemainder(dividingBy: 60)
                
                let days = timeInHours / 24
                let hours = timeInHours.truncatingRemainder(dividingBy: 24)
                
                cell.textLbl.text = "Your mood has been negative for the past \(Int(days).description) Days."
                cell.textLbl.addCharacterSpacing()
                return cell
                // }
            }
        }else if totalCell == 1 && ispendingMandSurvey == true{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
                let leftMandatorySurvey = self.sortedMandArr.count != 0 ? sortedMandArr.count:0
                cell.textLbl.text = "You have \(leftMandatorySurvey) Pending mandatory surveys left. You will not be able to use the application untill you complete the mandatory surveys."
                cell.textLbl.addCharacterSpacing()
                cell.clickHereLbl.text = "Click here to fill your left surveys."
                cell.contentView.backgroundColor = hexStringToUIColor(hex: "#0064F9")
                return cell
            }
        }else if totalCell == 2{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
                let mostRecent = self.timeStampMood
                let currentTimestemp = Int(Date().timeIntervalSince1970)
                let timediffernece = Double(currentTimestemp - mostRecent)
                let timeInHours = abs(timediffernece/3600)
                let timeInMin = abs(timediffernece/60)
                let remainderMin = timediffernece.truncatingRemainder(dividingBy: 3600)
                let remainderSec = timediffernece.truncatingRemainder(dividingBy: 60)
                let days = timeInHours / 24
                let hours = timeInHours.truncatingRemainder(dividingBy: 24)
                cell.textLbl.text = "Your mood has been negative for the past \(Int(days).description) Days."
                cell.textLbl.addCharacterSpacing()
                cell.contentView.backgroundColor = hexStringToUIColor(hex: "#FF2D2C")
                return cell
            }
            if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
                let leftMandatorySurvey = sortedMandArr.count != 0 ? sortedMandArr.count:0
                cell.textLbl.text = "You have \(leftMandatorySurvey) Pending mandatory surveys left. You will not be able to use the application untill you complete the mandatory surveys."
                cell.textLbl.addCharacterSpacing()
                cell.clickHereLbl.text = "Click here to fill your left surveys."
                cell.contentView.backgroundColor = hexStringToUIColor(hex: "#0064F9")
                
                return cell
            }
        }
        if indexPath.row == 0+totalCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTVCell", for: indexPath) as! DashboardTVCell
            let quote = DailyQuote != nil ? DailyQuote: "Daily quotes appear here."
            cell.textLbl.text = "\(quote ?? "Daily quotes appear here.")"
            cell.textLbl.addCharacterSpacing()
            
            return cell
        }else if indexPath.row == 1+totalCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnouncementsCell", for: indexPath) as! AnouncementsCell
            cell.BlurForLockCell.isHidden = true
            cell.HeadlineLabel.text = "Announcements"
            cell.BackgroundImg.image = UIImage(named: "backgroundAnnouncements")
            cell.ClickhereLabel.text = "Click here to View the latest announcements."
            cell.alertImg.isHidden = true
            if announcementReadStatus.count > 0{
                cell.newEventsLabel.text = "\(announcementReadStatus.count) unread announcement."
                cell.alertImg.isHidden = false
            }else{
                cell.newEventsLabel.text = "No new announcements yet."
                cell.alertImg.isHidden = true
            }
            return cell
        }else if indexPath.row == 2+totalCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnouncementsCell", for: indexPath) as! AnouncementsCell
            if ispendingMandSurvey == true{
                cell.BlurForLockCell.isHidden = false
            }else{
                cell.BlurForLockCell.isHidden = true
            }
            cell.HeadlineLabel.text = "Mood Log"
            cell.BackgroundImg.image = UIImage(named: "backgroundMood")
            cell.ClickhereLabel.text = "Click to log mood now."
            
            if userHasLoggedMood == true{
                 // if let mostRecent = self.timeStampMoodarr.max() {
                let mostRecent = self.timeStampMood
                let currentTimestemp = Int(Date().timeIntervalSince1970)
                let timediffernece = Double(currentTimestemp - mostRecent)
                let timeInHours = abs(timediffernece/3600)
                let timeInMin = abs(timediffernece/60)
                let remainderMin = timediffernece.truncatingRemainder(dividingBy: 3600)
                let remainderSec = timediffernece.truncatingRemainder(dividingBy: 60)
                if timeInHours < 48{
                    cell.newEventsLabel.text = "You logged your mood \(Int(timeInHours).description) hour ago"
                    
                    if timeInHours<1{
                        cell.newEventsLabel.text = "You logged your mood \(Int(timeInMin).description) minutes ago"
                        
                        if timeInMin<1{
                            cell.newEventsLabel.text = "You logged your mood \(Int(timediffernece).description) second ago"
                        }
                        
                    }
                    
                }else{
                    let days = timeInHours / 24
                    let hours = timeInHours.truncatingRemainder(dividingBy: 24)
                    cell.newEventsLabel.text = "You have not logged your mood since the last \(Int(days).description) Days and \(Int(hours).description) hour. Please do so to continue getting value from this application."
                    cell.newEventsLabel.addCharacterSpacing()
                }
                // }
            }else{
                cell.newEventsLabel.text = "You have not logged your mood yet."
                cell.newEventsLabel.addCharacterSpacing()
            }
            cell.alertImg.isHidden = true
            return cell
        }else if indexPath.row == 3+totalCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnouncementsCell", for: indexPath) as! AnouncementsCell
            cell.BlurForLockCell.isHidden = true
            cell.HeadlineLabel.text = "Question of the Day"
            cell.BackgroundImg.image = UIImage(named: "backgroundQuestionofTheDay")
            if todayQues["question"] as? String != nil{
                cell.newEventsLabel.text = todayQues["question"] as? String
                cell.newEventsLabel.font = UIFont(name:"SegoeUI-Regular", size: 18)
                cell.newEventsLabel.addCharacterSpacing()
            }else{
                cell.newEventsLabel.text = "Question of the day is to be published."
                cell.newEventsLabel.font = UIFont(name:"SegoeUI-Regular", size: 18)
                cell.newEventsLabel.addCharacterSpacing()
            }
            cell.ClickhereLabel.text = "Click to find out what your peers have answered."
            cell.ClickhereLabel.addCharacterSpacing()
            cell.alertImg.isHidden = true
            return cell
        }else if indexPath.row == 4+totalCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as! EventsCell
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if FinalallEventsDate.count == 0{
                cell.noeventslbl.isHidden = false
                cell.secondEventDateView.isHidden = true
                cell.thirdEventDateView.isHidden = true
                cell.CountremainingEventsDateView.isHidden = true
                cell.firstEventDateView.isHidden = true
            }else if FinalallEventsDate.count == 1{
                cell.noeventslbl.isHidden = true
                cell.secondEventDateView.isHidden = true
                cell.thirdEventDateView.isHidden = true
                cell.CountremainingEventsDateView.isHidden = true
                cell.firstEventDateView.isHidden = false
                formatter.dateFormat = "LLL"
                let month1 = formatter.string(from: self.FinalallEventsDate[0])
                formatter.dateFormat = "dd"
                let day1 = formatter.string(from: self.FinalallEventsDate[0])
                cell.firstEventMonthLbl.text = month1
                cell.firstEventDateLbl.text = day1
            }else if FinalallEventsDate.count == 2{
                cell.noeventslbl.isHidden = true
                cell.CountremainingEventsDateView.isHidden = true
                cell.firstEventDateView.isHidden = false
                cell.secondEventDateView.isHidden = false
                cell.thirdEventDateView.isHidden = true
                formatter.dateFormat = "LLL"
                let month1 = formatter.string(from: self.FinalallEventsDate[0])
                let month2 = formatter.string(from: self.FinalallEventsDate[1])
                formatter.dateFormat = "dd"
                let day1 = formatter.string(from: self.FinalallEventsDate[0])
                let day2 = formatter.string(from: self.FinalallEventsDate[1])
                cell.firstEventMonthLbl.text = month1
                cell.SecondEventMonthLbl.text = month2
                cell.firstEventDateLbl.text = day1
                cell.SecondEventDateLbl.text = day2
            }else if FinalallEventsDate.count == 3{
                cell.noeventslbl.isHidden = true
                cell.CountremainingEventsDateView.isHidden = true
                cell.firstEventDateView.isHidden = false
                cell.secondEventDateView.isHidden = false
                cell.thirdEventDateView.isHidden = false
                formatter.dateFormat = "LLL"
                let month1 = formatter.string(from: self.FinalallEventsDate[0])
                let month2 = formatter.string(from: self.FinalallEventsDate[1])
                let month3 = formatter.string(from: self.FinalallEventsDate[2])
                formatter.dateFormat = "dd"
                let day1 = formatter.string(from: self.FinalallEventsDate[0])
                let day2 = formatter.string(from: self.FinalallEventsDate[1])
                let day3 = formatter.string(from: self.FinalallEventsDate[2])
                cell.firstEventMonthLbl.text = month1
                cell.SecondEventMonthLbl.text = month2
                cell.firstEventDateLbl.text = day1
                cell.SecondEventDateLbl.text = day2
                cell.thirdEventMonthLbl.text = month3
                cell.thirdEventDateLbl.text = day3
            }else if FinalallEventsDate.count > 3{
                cell.noeventslbl.isHidden = true
                cell.CountremainingEventsDateView.isHidden = false
                cell.firstEventDateView.isHidden = false
                cell.secondEventDateView.isHidden = false
                cell.thirdEventDateView.isHidden = false
                let remainingEvents = String(self.allEventsDate.count - 3)
                formatter.dateFormat = "LLL"
                let month1 = formatter.string(from: self.FinalallEventsDate[0])
                let month2 = formatter.string(from: self.FinalallEventsDate[1])
                let month3 = formatter.string(from: self.FinalallEventsDate[2])
                formatter.dateFormat = "dd"
                let day1 = formatter.string(from: self.FinalallEventsDate[0])
                let day2 = formatter.string(from: self.FinalallEventsDate[1])
                let day3 = formatter.string(from: self.FinalallEventsDate[2])
                cell.firstEventMonthLbl.text = month1
                cell.SecondEventMonthLbl.text = month2
                cell.firstEventDateLbl.text = day1
                cell.SecondEventDateLbl.text = day2
                cell.thirdEventMonthLbl.text = month3
                cell.thirdEventDateLbl.text = day3
                cell.CountremainingEventsLbl.text = "+\(remainingEvents)"
            }else{
                return cell
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveysCell", for: indexPath) as! SurveysCell
            let surveyCount = SurveyRows.count
            let progress = (1 - (Float(surveyCount)/Float(totalSurvey)) )
            UIView.animate(withDuration: 0.4) {
                cell.ProgressBAR.progress = progress
                self.view.layoutIfNeeded()
            }
            if sortedMandArr.count > 0{
                cell.alertImg.isHidden = false
                cell.PendingSurveyStatusText.text = "You have total \(surveyCount) Pending surveys left. You will not be able to use the application till you complete the \(sortedMandArr.count) left mandatory surveys."
                cell.PendingSurveyStatusText.addCharacterSpacing()
            }else if surveyCount > 0{
                cell.alertImg.isHidden = true
                cell.PendingSurveyStatusText.text = "You have total \(surveyCount) Pending surveys left."
                cell.PendingSurveyStatusText.addCharacterSpacing()
            }else if surveyCount == 0{
                cell.alertImg.isHidden = true
                cell.PendingSurveyStatusText.text = "You are awesome.You have submitted all surveys."
                cell.PendingSurveyStatusText.addCharacterSpacing()
            }
            return cell
        }
    }
    
    //MARK: TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary[indexPath] = cell.frame.size.height
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = cellHeightsDictionary[indexPath] as? NSNumber
        if height != nil {
            return CGFloat(Double(truncating: height ?? 0.0))
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if totalCell == 1 && isMoodNegative == true && self.DailyQuote == nil{
            if indexPath.row == 1{
               return 0
            }else{
                return 165
            }
        }else if totalCell == 1 && ispendingMandSurvey == true && self.DailyQuote == nil{
            if indexPath.row == 1{
                return 0
            }else{
                return 165
            }
        }else if totalCell == 2 && self.DailyQuote == nil{
            if indexPath.row == 2{
                return 0
            }else{
                return 165
            }
        }else if self.DailyQuote == nil{
            if indexPath.row == 0{
                return 0
            }else{
                return 165
            }
        }else{
            return 165
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("totalCell:\(totalCell)")
        if totalCell == 1 && isMoodNegative == true{
            if indexPath.row == 0{
                 PushTo(FromVC: self, ToStoryboardID: "CheerUpVC")
            }
        }else if totalCell == 1 && ispendingMandSurvey == true{
            if indexPath.row == 0{
                PushTo(FromVC: self, ToStoryboardID: "ResearchVC")
            }
        }else if totalCell == 2{
            if indexPath.row == 0{
                PushTo(FromVC: self, ToStoryboardID: "CheerUpVC")
            }
            if indexPath.row == 1{
                PushTo(FromVC: self, ToStoryboardID: "ResearchVC")
            }
        }
     
        if indexPath.row == 1+totalCell{
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "AnnouncementsVC") as! AnnouncementsVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 2+totalCell{
        
             PushTo(FromVC: self, ToStoryboardID: "QuestioningMoodLogVC")
//            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
//            UIApplication.shared.keyWindow?.rootViewController = loginView
//            let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
//            tabBarController.selectedIndex = 2
            
        }else if indexPath.row == 3+totalCell{
            if isAnsweredQOTD == true{
                let vc = storyboard?.instantiateViewController(withIdentifier: "QuestionDayAnswerVC") as! QuestionDayAnswerVC
                vc.options = options
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let cell = self.tableView.cellForRow(at: indexPath) as! AnouncementsCell
                if cell.newEventsLabel.text == "Question of the day is to be published."{
                    self.PresentAlert(message: "Question of the day is not published yet.", title: "TransLife")
                }else{
                    let vc = storyboard?.instantiateViewController(withIdentifier: "QuestionDayQuesVC") as! QuestionDayQuesVC
                    vc.quesID = quesID
                    vc.options = options
                    vc.todayQues = todayQues
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
            
     } else if indexPath.row == 4+totalCell{
            PushTo(FromVC: self, ToStoryboardID: "EventsListVC")
        }else if indexPath.row == 5+totalCell{
            PushTo(FromVC: self, ToStoryboardID: "ResearchVC")
        }
    }
    
    
    
}
extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
