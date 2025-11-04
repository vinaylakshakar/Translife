//
//  InsigthVC.swift
//  transLife
//
//  Created by Developer Silstone on 11/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import CSPieChart
import SVProgressHUD


var AmazingMoodArr = [String]()
var veryGoodMoodArr = [String]()
var GoodMoodArr = [String]()
var OkayMoodArr = [String]()
var NotGoodMoodArr = [String]()
var BadMoodArr = [String]()
var AwfulMoodArr = [String]()
class InsigtsVC: UIViewController {
    //MARK:IB Outlets
    @IBOutlet weak var NoMoodLbl: UILabel!
    @IBOutlet weak var NoLoggedMoodLbl: UILabel!
    @IBOutlet weak var stackViewForMonths: UIStackView!
    @IBOutlet weak var spaceBar: UILabel!
    @IBOutlet weak var clickdateforDetail: UILabel!
    @IBOutlet weak var firstLabelForWeek: UILabel!
    @IBOutlet weak var secondLabelForWeek: UILabel!
    @IBOutlet weak var pieChartContainerView: UIView!
    @IBOutlet weak var tableContentView: UIView!
    @IBOutlet weak var StackBarChartView: UIView!
    @IBOutlet weak var Greenline: UIView!
    @IBOutlet weak var pieChartView: CSPieChart!
    @IBOutlet weak var StackBarCollectionView: UICollectionView!
    @IBOutlet weak var StackBarDateMonthCollectionView: UICollectionView!
    @IBOutlet weak var Line: UILabel!
    @IBOutlet weak var NavView: UIView!
    @IBOutlet weak var TableVIEW: UITableView!
    @IBOutlet weak var WeekBtn: UIButton!
    @IBOutlet weak var MonthBtn: UIButton!
    @IBOutlet weak var YearBtn: UIButton!
    @IBOutlet weak var amazingMoodCountLbl: UILabel!
    @IBOutlet weak var veryGoodMoodCountLbl: UILabel!
    @IBOutlet weak var GoodMoodCountLbl: UILabel!
    @IBOutlet weak var OkayMoodCountLbl: UILabel!
    @IBOutlet weak var notgoodMoodCountLbl: UILabel!
    @IBOutlet weak var BadMoodCountLbl: UILabel!
    @IBOutlet weak var AwfulMoodCountLbl: UILabel!
    //MARK:References
    var UserMoodLog = MoodLog()
    var weekfirstLabel = ""
    var weeksecondLabel = ""
    var weekfromindex = 0
    var InsightsForYear = 2019
    var monthsToAdd = 0
    var currentMonth = Date()
    var arr = [String]()
    var moodarr = [[String]]()
    var reversedmoodarr = [[String]]()
    var Dict = [NSDictionary]()
    var DateDict = [String:AnyObject]()
    var monthly_mood_count = 0
    var SameDateArr = [AnyObject]()
    var DifferentDateArr = [AnyObject]()
    var PreviousDate = ""
    var yearActive = false
    var monthActive = false
    var weekActive = false
    var monthasDate = Date()
    let month = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
    var janMoodArr = [String]()
    var febMoodArr = [String]()
    var marMoodArr = [String]()
    var aprMoodArr = [String]()
    var mayMoodArr = [String]()
    var junMoodArr = [String]()
    var julMoodArr = [String]()
    var augMoodArr = [String]()
    var sepMoodArr = [String]()
    var octMoodArr = [String]()
    var novMoodArr = [String]()
    var decMoodArr = [String]()
    var containAllMoodForYear = [String]()
    var titleSection = [String]()
    var uniquetitleSection = [String]()
    var prefixtitleSection = [String]()
    var reversedUniquetitleSection = [String]()
    let backgroundColors = ["#FFA739","#02A452","#44296B","#008DF9","#FFA739","#02A452","#44296B","#008DF9","#FFA739","#02A452"]
    var numberOfItems = 4
    var ItemSpace = CGFloat()
    var dataList = [CSPieChartData]()
    var colorList = ["#FFEE00","#FF5801","#FE003A","#C501FF","#00FFEE","#008DF9","#4400CF"]
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        StackBarChartView.dropShadow()
  self.navigationController?.navigationBar.isHidden = true
    }
    //MARK: SETUP PIE CHART
    func setUpPieChart() {
        
        dataList.removeAll()
        pieChartView?.pieChartRadiusRate = 0.9
        pieChartView?.pieChartLineLength = 12
        pieChartView?.seletingAnimationType = .touch
        pieChartView?.show(animated: true)
        amazingMoodCountLbl.text = "\(AmazingMoodArr.count)"
        veryGoodMoodCountLbl.text = "\(veryGoodMoodArr.count)"
        GoodMoodCountLbl.text = "\(GoodMoodArr.count)"
        OkayMoodCountLbl.text = "\(OkayMoodArr.count)"
        notgoodMoodCountLbl.text = "\(NotGoodMoodArr.count)"
        BadMoodCountLbl.text = "\(BadMoodArr.count)"
        AwfulMoodCountLbl.text = "\(AwfulMoodArr.count)"
        self.dataList.append(CSPieChartData(key:"amazing",value:Double(AmazingMoodArr.count)))
        self.dataList.append(CSPieChartData(key:"verygood",value:Double(veryGoodMoodArr.count)))
        self.dataList.append(CSPieChartData(key:"good",value:Double(GoodMoodArr.count)))
        self.dataList.append(CSPieChartData(key:"okay",value:Double(OkayMoodArr.count)))
    self.dataList.append(CSPieChartData(key:"notgood",value:Double(NotGoodMoodArr.count)))
        self.dataList.append(CSPieChartData(key:"bad",value:Double(BadMoodArr.count)))
        self.dataList.append(CSPieChartData(key:"awful",value:Double(AwfulMoodArr.count)))
        pieChartView?.dataSource = self
        pieChartView?.delegate = self
        pieChartView.reloadPieChart()
    }
    //MARK: SETUP TOUCH ON PIE SLICES
    fileprivate var touchDistance: CGFloat = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: view) else {
            return
        }
        touchDistance = location.x
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: view) else {
            return
        }
        touchDistance -= location.x
        if touchDistance > 100 {
            print("Right")
        } else if touchDistance < -100 {
            print("Left")
        }
        touchDistance = 0
    }
    //MARK:viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
    }
    //MARK:viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: self.TableVIEW.frame.height - 250, right: 0)
        self.TableVIEW.contentInset = insets
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: now)
        GetMoodTrackUserforYear(year: Int(currentYear) ?? 2019)
        clickdateforDetail.text = "Click on month to view details"
        monthActive = false
        weekActive = false
        yearActive = true
        numberOfItems = 12
        firstLabelForWeek.text = currentYear
        getPhoneModelForItemSpacing()
        WeekBtn.alpha = 0.5
        MonthBtn.alpha = 0.5
        YearBtn.alpha = 1
        spaceBar.isHidden = true
        firstLabelForWeek.isHidden = false
        secondLabelForWeek.isHidden = true
        tableContentView.bringSubviewToFront(StackBarChartView)
        WeekBtn.isUserInteractionEnabled = true
        YearBtn.isUserInteractionEnabled = false
        MonthBtn.isUserInteractionEnabled = true
        
    }
    //MARK:GET USER MOOD TRACK
    func GetMoodTrackUserForWeek(from:Int,to:Int) {
        SVProgressHUD.show()
        UserMoodLog.GetUserMoodLog(view: self) { (snap) in
            self.Dict.removeAll()
            self.titleSection.removeAll()
            self.uniquetitleSection.removeAll()
            self.reversedmoodarr.removeAll()
            self.moodarr.removeAll()
            self.DateDict.removeAll()
            self.prefixtitleSection.removeAll()
            if snap.value is NSNull{
                self.TableVIEW.delegate = self
                self.TableVIEW.dataSource = self
                self.TableVIEW.reloadData()
                
                        let alertController = UIAlertController(title: "TransLife", message: "you have no logged mood in this week.", preferredStyle: .alert)
                        alertController.setValue(NSAttributedString(string:"TransLife", attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
                        let okAction = UIAlertAction(title: "Log mood now", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            PushTo(FromVC: self, ToStoryboardID: "QuestioningMoodLogVC")
//                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                            let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
//                            UIApplication.shared.keyWindow?.rootViewController = loginView
//                            let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
//                            tabBarController.selectedIndex = 2
                            
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) {
                            UIAlertAction in
                        }
                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                self.NoMoodLbl.text = "you have no logged mood in \(self.InsightsForYear)"
                self.tableContentView.bringSubviewToFront(self.NoLoggedMoodLbl)
                SVProgressHUD.dismiss()
            }else{
                let snapValue = snap.value as! [String:AnyObject]
                // print(snapValue)
                for i in snapValue{
                    let val = i.value
                    self.Dict.append(val  as! NSDictionary)
                }
                let sortedArr =  self.Dict.sorted(by: { $0["currentTimeStamp"] as! Double > $1["currentTimeStamp"] as! Double })
                //print(sortedArr)
                for n in sortedArr{
                    if  let  timeResult = (n["currentTimeStamp"] as? Double) {
                        let date = Date(timeIntervalSince1970: timeResult)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = DateFormatter.Style.none
                        dateFormatter.dateFormat = "MMMM dd, yyyy"//Set time style
                        // dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
                        let localDate = dateFormatter.string(from: date)
                        // print(localDate)
                        dateFormatter.dateFormat = "MMMM dd, yyyy"
                        let localDat = dateFormatter.date(from: localDate)
                        dateFormatter.dateFormat = "yyyy"
                        let year = dateFormatter.string(from: localDat!)
                        if year == String(self.InsightsForYear){
                            self.titleSection.append(localDate)
                            self.prefixtitleSection = Array(NSOrderedSet(array: self.titleSection)) as! [String]
                            
                            if self.DateDict.keys.contains(localDate){
                                self.SameDateArr.append(n as AnyObject)
                                self.DateDict.updateValue(self.SameDateArr as AnyObject, forKey: localDate)
                            }else{
                                self.SameDateArr.removeAll()
                                self.SameDateArr.append(n as AnyObject)
                                self.DateDict.updateValue(self.SameDateArr as AnyObject, forKey: localDate)
                            }
                        }
                    }
                }
                
                if self.prefixtitleSection.count == 0{
                    self.NoMoodLbl.text = "you have no logged mood in \(self.InsightsForYear)"
                   self.tableContentView.bringSubviewToFront(self.NoLoggedMoodLbl)
                }else{
                    self.tableContentView.sendSubviewToBack(self.NoLoggedMoodLbl)
                    let div = self.prefixtitleSection.count % 7
                    if self.prefixtitleSection.count > from && from >= 0{
                        self.tableContentView.sendSubviewToBack(self.NoLoggedMoodLbl)
                        if self.prefixtitleSection.count > to {
                            self.tableContentView.sendSubviewToBack(self.NoLoggedMoodLbl)
                            if  (from == 0 || from > 0){
                                self.uniquetitleSection = Array(self.prefixtitleSection[from...to])
                                self.reversedUniquetitleSection = self.uniquetitleSection.reversed()
                                for i in self.uniquetitleSection{
                                    self.arr.removeAll()
                                    let val = self.DateDict[i] as! [AnyObject]
                                    for n in 0..<val.count{
                                        let Mood = val[n]["mood"] as? String
                                        self.arr.append(Mood ?? "")
                                    }
                                    self.moodarr.append(self.arr)
                                }
                                self.reversedmoodarr = self.moodarr.reversed()
                                self.getFirstSevenObjects()
                                
                            }else{
                        
                               self.NoMoodLbl.text = "you have no logged mood in this week"
                                self.tableContentView.bringSubviewToFront(self.NoLoggedMoodLbl)
                                
                            }
                        }else{
                            let To = from + div - 1
                            if div == 1{
                                self.uniquetitleSection = [self.prefixtitleSection[0]]
                                self.reversedUniquetitleSection = self.uniquetitleSection.reversed()
                                for i in self.uniquetitleSection{
                                    self.arr.removeAll()
                                    let val = self.DateDict[i] as! [AnyObject]
                                    for n in 0..<val.count{
                                        let Mood = val[n]["mood"] as? String
                                        self.arr.append(Mood ?? "")
                                    }
                                    self.moodarr.append(self.arr)
                                }
                                self.reversedmoodarr = self.moodarr.reversed()
                                self.getFirstSevenObjects()
                                
                            }else if (div > 1) && (from < To) {
                                self.uniquetitleSection = Array(self.prefixtitleSection[from...To])
                                self.reversedUniquetitleSection = self.uniquetitleSection.reversed()
                                for i in self.uniquetitleSection{
                                    self.arr.removeAll()
                                    let val = self.DateDict[i] as! [AnyObject]
                                    for n in 0..<val.count{
                                        let Mood = val[n]["mood"] as? String
                                        self.arr.append(Mood ?? "")
                                    }
                                    self.moodarr.append(self.arr)
                                }
                                self.reversedmoodarr = self.moodarr.reversed()
                                self.getFirstSevenObjects()
                                
                            }else{
                                self.NoMoodLbl.text = "you have no logged mood in this week"
                                self.tableContentView.bringSubviewToFront(self.NoLoggedMoodLbl)
                            }
                        }
                    }else{
                        self.NoMoodLbl.text = "you have no logged mood in this week"
                        self.tableContentView.bringSubviewToFront(self.NoLoggedMoodLbl)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.TableVIEW.delegate = self
                    self.TableVIEW.dataSource = self
                    self.TableVIEW.reloadData()
                    self.StackBarCollectionView.delegate = self
                    self.StackBarCollectionView.dataSource = self
                    self.StackBarCollectionView.reloadData()
                    self.StackBarDateMonthCollectionView.delegate = self
                    self.StackBarDateMonthCollectionView.dataSource = self
                    self.StackBarDateMonthCollectionView.reloadData()
                })
                SVProgressHUD.dismiss()
            }
        }
    }
    //MARK: GET MOOD TRACK FOR YEAR
    func GetMoodTrackUserforYear(year:Int) {
        SVProgressHUD.show()
        UserMoodLog.GetUserMoodLog(view: self) { (snap) in
            self.janMoodArr.removeAll()
            self.febMoodArr.removeAll()
            self.marMoodArr.removeAll()
            self.aprMoodArr.removeAll()
            self.mayMoodArr.removeAll()
            self.junMoodArr.removeAll()
            self.julMoodArr.removeAll()
            self.augMoodArr.removeAll()
            self.sepMoodArr.removeAll()
            self.octMoodArr.removeAll()
            self.novMoodArr.removeAll()
            self.decMoodArr.removeAll()
            self.Dict.removeAll()
            self.titleSection.removeAll()
            self.uniquetitleSection.removeAll()
            self.reversedmoodarr.removeAll()
            self.moodarr.removeAll()
            self.DateDict.removeAll()
            if snap.value is NSNull{
                self.TableVIEW.delegate = self
                self.TableVIEW.dataSource = self
                self.TableVIEW.reloadData()
                let alertController = UIAlertController(title: "TransLife", message: "you have no logged mood in \(year)", preferredStyle: .alert)
                alertController.setValue(NSAttributedString(string:"TransLife", attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
                let okAction = UIAlertAction(title: "Log mood now", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    PushTo(FromVC: self, ToStoryboardID: "QuestioningMoodLogVC")
//                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                    let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
//                    UIApplication.shared.keyWindow?.rootViewController = loginView
//                    let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
//                    tabBarController.selectedIndex = 2
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) {
                    UIAlertAction in
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                self.NoMoodLbl.text = "you have no logged mood in \(year)"
                self.tableContentView.bringSubviewToFront(self.NoLoggedMoodLbl)
                SVProgressHUD.dismiss()
            }else{
                let snapValue = snap.value as! [String:AnyObject]
                for i in snapValue{
                    let val = i.value
                    self.Dict.append(val  as! NSDictionary)
                }
                let sortedArr =  self.Dict.sorted(by: { $0["currentTimeStamp"] as! Double > $1["currentTimeStamp"] as! Double })
                
                for n in sortedArr{
                    if  let  timeResult = (n["currentTimeStamp"] as? Double) {
                        let date = Date(timeIntervalSince1970: timeResult)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = DateFormatter.Style.none
                        dateFormatter.dateFormat = "MMMM dd, yyyy"//Set time style
                        let localDate = dateFormatter.string(from: date)
                        dateFormatter.dateFormat = "MMMM dd, yyyy"
                        let localDat = dateFormatter.date(from: localDate)
                        dateFormatter.dateFormat = "MMMM"
                        let mont = dateFormatter.string(from: localDat!)
                        dateFormatter.dateFormat = "yyyy"
                        let yyyy = dateFormatter.string(from: localDat!)
                        if yyyy == String(year){
                            self.titleSection.append(localDate)
                            self.uniquetitleSection = Array(NSOrderedSet(array: self.titleSection)) as! [String]
                            if self.DateDict.keys.contains(localDate){
                                self.SameDateArr.append(n as AnyObject)
                                self.DateDict.updateValue(self.SameDateArr as AnyObject, forKey: localDate)
                            }else{
                                self.SameDateArr.removeAll()
                                self.SameDateArr.append(n as AnyObject)
                                self.DateDict.updateValue(self.SameDateArr as AnyObject, forKey: localDate)
                            }
                            let mood = n["mood"] as! String
                            switch mont{
                                case "January":self.janMoodArr.append(mood)
                                case "February":self.febMoodArr.append(mood)
                                case "March":self.marMoodArr.append(mood)
                                case "April":self.aprMoodArr.append(mood)
                                case "May":self.mayMoodArr.append(mood)
                                case "June":self.junMoodArr.append(mood)
                                case "July":self.julMoodArr.append(mood)
                                case "August":self.augMoodArr.append(mood)
                                case "September":self.sepMoodArr.append(mood)
                                case "October":self.octMoodArr.append(mood)
                                case "November":self.novMoodArr.append(mood)
                                case "December":self.decMoodArr.append(mood)
                            default: break
                            }
                        }
                    }
                }
                if self.DateDict.count != 0{
                    self.tableContentView.sendSubviewToBack(self.NoLoggedMoodLbl)
                    for i in 0...self.DateDict.count-1{
                        self.moodarr.append([String]())
                        self.reversedmoodarr.append([String]())
                    }
                }else{
                   
                    self.NoMoodLbl.text = "you have no logged mood in \(year)"
                    self.tableContentView.bringSubviewToFront(self.NoLoggedMoodLbl)
                }
                self.reversedUniquetitleSection = self.uniquetitleSection.reversed()
                
                self.StackBarCollectionView.delegate = self
                self.StackBarCollectionView.dataSource = self
                self.StackBarDateMonthCollectionView.delegate = self
                self.StackBarDateMonthCollectionView.dataSource = self
                self.StackBarDateMonthCollectionView.reloadData()
                self.StackBarCollectionView.reloadData()
                self.TableVIEW.delegate = self
                self.TableVIEW.dataSource = self
                self.TableVIEW.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    //MARK: GET MOOD TRACK FOR MONTH
    func GetMoodTrackUserforMonth(month:String) {
        SVProgressHUD.show()
        AmazingMoodArr.removeAll()
        veryGoodMoodArr.removeAll()
        GoodMoodArr.removeAll()
        OkayMoodArr.removeAll()
        NotGoodMoodArr.removeAll()
        BadMoodArr.removeAll()
        AwfulMoodArr.removeAll()
        UserMoodLog.GetUserMoodLog(view: self) { (snap) in
            
            self.Dict.removeAll()
            self.titleSection.removeAll()
            self.uniquetitleSection.removeAll()
            self.DateDict.removeAll()
            if snap.value is NSNull{
                self.TableVIEW.delegate = self
                self.TableVIEW.dataSource = self
                self.TableVIEW.reloadData()
                let alertController = UIAlertController(title: "TransLife", message: "you have no logged mood in \(month)", preferredStyle: .alert)
                alertController.setValue(NSAttributedString(string:"TransLife", attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
                let okAction = UIAlertAction(title: "Log mood now", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    PushTo(FromVC: self, ToStoryboardID: "QuestioningMoodLogVC")
//                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                    let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
//                    UIApplication.shared.keyWindow?.rootViewController = loginView
//                    let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
//                    tabBarController.selectedIndex = 2
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) {
                    UIAlertAction in
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                self.tableContentView.bringSubviewToFront(self.NoLoggedMoodLbl)
                self.NoMoodLbl.text = "you have no logged mood in \(month)"
                SVProgressHUD.dismiss()
            }else{
                let snapValue = snap.value as! [String:AnyObject]
                // print(snapValue)
                for i in snapValue{
                    let val = i.value
                    self.Dict.append(val  as! NSDictionary)
                }
                let sortedArr =  self.Dict.sorted(by: { $0["currentTimeStamp"] as! Double > $1["currentTimeStamp"] as! Double })
                //  print(sortedArr)
                
                for n in sortedArr{
                    if  let  timeResult = (n["currentTimeStamp"] as? Double) {
                        let date = Date(timeIntervalSince1970: timeResult)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = DateFormatter.Style.none
                        dateFormatter.dateFormat = "MMMM dd, yyyy"//Set time style
                        // dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
                        let localDate = dateFormatter.string(from: date)
                        //  let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM dd, yyyy"
                        let localDat = dateFormatter.date(from: localDate)
                        dateFormatter.dateFormat = "yyyy"
                        let year = dateFormatter.string(from: localDat!)
                        if year == String(self.InsightsForYear){
                            
                            dateFormatter.dateFormat = "MMMM"
                            let mont = dateFormatter.string(from: localDat!)
                            if mont == month{
                                self.titleSection.append(localDate)
                                self.uniquetitleSection = Array(NSOrderedSet(array: self.titleSection)) as! [String]
                                if self.DateDict.keys.contains(localDate){
                                    self.SameDateArr.append(n as AnyObject)
                                    self.DateDict.updateValue(self.SameDateArr as AnyObject, forKey: localDate)
                                }else{
                                    self.SameDateArr.removeAll()
                                    self.SameDateArr.append(n as AnyObject)
                                    self.DateDict.updateValue(self.SameDateArr as AnyObject, forKey: localDate)
                                }
                                let mood = n["mood"] as! String
                                switch mood{
                                case "Amazing":AmazingMoodArr.append(mood)
                                case "Very Good":veryGoodMoodArr.append(mood)
                                case "Good":GoodMoodArr.append(mood)
                                case "Okay":OkayMoodArr.append(mood)
                                case "Not Good": NotGoodMoodArr.append(mood)
                                case "Bad":BadMoodArr.append(mood)
                                case "Awful":AwfulMoodArr.append(mood)
                                default: break
                                }
                               
                            }
                        }
                    }
                }
                if self.DateDict.count != 0{
                    self.tableContentView.sendSubviewToBack(self.NoLoggedMoodLbl)
                }else{
                    self.NoMoodLbl.text = "you have no logged mood in \(month)"
                    self.tableContentView.bringSubviewToFront(self.NoLoggedMoodLbl)
                }
                self.reversedUniquetitleSection = self.uniquetitleSection.reversed()
                self.TableVIEW.delegate = self
                self.TableVIEW.dataSource = self
                self.TableVIEW.reloadData()
                self.setUpPieChart()
                SVProgressHUD.dismiss()
            }
        }
    }
    //MARK: GET FIRST SEVEN DATES
    func getFirstSevenObjects(){
        if uniquetitleSection.count < 7 && uniquetitleSection.count > 0{
            weekfirstLabel = (Array(uniquetitleSection).last)!
            weeksecondLabel = (Array(uniquetitleSection).first)!
        }else if uniquetitleSection.count >= 7{
            weekfirstLabel = (Array(uniquetitleSection)[6])
            weeksecondLabel = (Array(uniquetitleSection).first)!
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let localDate = dateFormatter.date(from: weekfirstLabel)
        dateFormatter.dateFormat = "dd MMMM"
        let day = dateFormatter.string(from: localDate!)
        firstLabelForWeek.text = day
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let LocalDate = dateFormatter.date(from: weeksecondLabel)
        dateFormatter.dateFormat = "dd MMMM"
        let Day = dateFormatter.string(from: LocalDate!)
        secondLabelForWeek.text = Day
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem.imageInsets.bottom = -5
        self.tabBarItem.imageInsets.top = 5
        self.tabBarItem.image = UIImage(named: "nav_insights_unselected")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "nav_insights_selected")?.withRenderingMode(.alwaysOriginal)
    }
    //MARK:getPhoneModelForItemSpacing
    func getPhoneModelForItemSpacing() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                ItemSpace = 18
            case 1334:
                print("iPhone 6/6S/7/8")
                ItemSpace = 23
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                ItemSpace = 25
            case 2436:
                print("iPhone X, XS")
                ItemSpace = 25
            case 2688:
                print("iPhone XS Max")
                ItemSpace = 25
            case 1792:
                print("iPhone XR")
                ItemSpace = 25
            default:
                ItemSpace = 25
            }
        }
    }
    //MARK:ACTIONS
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func LogAddBtnAct(_ sender: Any) {
         PushTo(FromVC: self, ToStoryboardID: "QuestioningMoodLogVC")
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
//        UIApplication.shared.keyWindow?.rootViewController = loginView
//        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
//        tabBarController.selectedIndex = 2
        
    }
    @IBAction func BackwardLeftIconPressed(_ sender: Any) {
        if monthActive == true{
            monthsToAdd -= 1
            let newDate = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: monthasDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let currentMonth = dateFormatter.string(from: newDate!)
            firstLabelForWeek.text = currentMonth
            GetMoodTrackUserforMonth(month: currentMonth)
        }
        if yearActive == true{
            InsightsForYear = InsightsForYear - 1
            firstLabelForWeek.text = String(InsightsForYear)
            GetMoodTrackUserforYear(year: InsightsForYear)
            
        }
        if weekActive == true{
            weekfromindex = weekfromindex + 7
            GetMoodTrackUserForWeek(from: weekfromindex, to: weekfromindex+6)
        }
    }
    @IBAction func forwardRightIconPressed(_ sender: Any) {
        if monthActive == true{
            monthsToAdd += 1
            let newDate = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: monthasDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let currentMonth = dateFormatter.string(from: newDate!)
            firstLabelForWeek.text = currentMonth
            GetMoodTrackUserforMonth(month: currentMonth)

        }
        if yearActive == true {
            InsightsForYear = InsightsForYear + 1
        firstLabelForWeek.text = String(InsightsForYear)
        GetMoodTrackUserforYear(year: InsightsForYear)
        }
        if weekActive == true{
            weekfromindex = weekfromindex - 7
            GetMoodTrackUserForWeek(from: weekfromindex, to: weekfromindex+6)
        }
    }
    
    @IBAction func WeekBtnAct(_ sender: Any) {
        clickdateforDetail.text = "Click on date to view details"
        weekfromindex = 0
        tableContentView.bringSubviewToFront(StackBarChartView)
        GetMoodTrackUserForWeek(from:weekfromindex,to: weekfromindex+6)
        monthActive = false
        weekActive = true
        yearActive = false
        spaceBar.isHidden = false
        firstLabelForWeek.isHidden = false
        secondLabelForWeek.isHidden = false
        MonthBtn.alpha = 0.5
        YearBtn.alpha = 0.5
        WeekBtn.alpha = 1
        numberOfItems = 4
        WeekBtn.isUserInteractionEnabled = false
        YearBtn.isUserInteractionEnabled = true
        MonthBtn.isUserInteractionEnabled = true
        
    }
    
    @IBAction func MonthBtnAct(_ sender: Any) {
        
        monthActive = true
        weekActive = false
        yearActive = false
        firstLabelForWeek.isHidden = false
        secondLabelForWeek.isHidden = true
        spaceBar.isHidden = true
        tableContentView.bringSubviewToFront(pieChartContainerView)
        MonthBtn.alpha = 1
        WeekBtn.alpha = 0.5
        YearBtn.alpha = 0.5
        let now = Date()
        monthasDate = now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let currentMonth = dateFormatter.string(from: now)
        monthsToAdd = 0
        GetMoodTrackUserforMonth(month: currentMonth)
        firstLabelForWeek.text = currentMonth
        MonthBtn.isUserInteractionEnabled = false
        YearBtn.isUserInteractionEnabled = true
        WeekBtn.isUserInteractionEnabled = true
   
    }
    @IBAction func YearBtnAct(_ sender: Any) {
        clickdateforDetail.text = "Click on month to view details"
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: now)
        firstLabelForWeek.text = currentYear
        InsightsForYear = Int(currentYear) ?? 2019
        firstLabelForWeek.isHidden = false
        secondLabelForWeek.isHidden = true
        spaceBar.isHidden = true
        GetMoodTrackUserforYear(year:Int(currentYear) ?? 2019)
        tableContentView.bringSubviewToFront(StackBarChartView)
        monthActive = false
        weekActive = false
        yearActive = true
        YearBtn.alpha = 1
        MonthBtn.alpha = 0.5
        WeekBtn.alpha = 0.5
        numberOfItems = 12
        YearBtn.isUserInteractionEnabled = false
        MonthBtn.isUserInteractionEnabled = true
        WeekBtn.isUserInteractionEnabled = true
        monthsToAdd = 0
    }
}
extension InsigtsVC:UITableViewDelegate,UITableViewDataSource{
    
    //MARK:TABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        if yearActive == true{
            return DateDict.count
        }else{
            return uniquetitleSection.count
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let val = DateDict[uniquetitleSection[section]] as AnyObject
        return val.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsightTVCell", for: indexPath) as! InsightTVCell
        
        cell.BackView.dropShadow()
        let val = DateDict[uniquetitleSection[indexPath.section]] as! [AnyObject]
        let Mood = val[indexPath.row]["mood"] as? String
 
        cell.MoodLbl.text = Mood
        let dateAsString = val[indexPath.row]["currentTimeStamp"] as? Double
        let date = Date(timeIntervalSince1970: dateAsString!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        let localDate = dateFormatter.string(from: date)
        cell.timeLbl.text = "\(String(describing: localDate))"
        cell.FeelingLbl1.isHidden = true
        cell.FeelingLbl2.isHidden = true
        cell.FeelingLbl3.isHidden = true
        cell.FeelingLbl4.isHidden = true
        cell.FeelingLbl5.isHidden = true
        cell.FeelingLbl6.isHidden = true
        if  val[indexPath.row]["Feelings"] as? NSArray != nil{
            let feelings = val[indexPath.row]["Feelings"] as? NSArray
            if feelings?.count == 1{
                cell.FeelingLbl1.isHidden = false
                cell.FeelingLbl1.text = feelings?[0] as? String
            }else if feelings?.count == 2{
                cell.FeelingLbl1.isHidden = false
                cell.FeelingLbl1.text = feelings?[0] as? String
                cell.FeelingLbl2.isHidden = false
                cell.FeelingLbl2.text = feelings?[1] as? String
            }else if feelings?.count == 3{
                cell.FeelingLbl1.isHidden = false
                cell.FeelingLbl1.text = feelings?[0] as? String
                cell.FeelingLbl2.isHidden = false
                cell.FeelingLbl2.text = feelings?[1] as? String
                cell.FeelingLbl3.isHidden = false
                cell.FeelingLbl3.text = feelings?[2] as? String
            }else if feelings?.count == 4{
                cell.FeelingLbl1.isHidden = false
                cell.FeelingLbl1.text = feelings?[0] as? String
                cell.FeelingLbl2.isHidden = false
                cell.FeelingLbl2.text = feelings?[1] as? String
                cell.FeelingLbl3.isHidden = false
                cell.FeelingLbl3.text = feelings?[2] as? String
                cell.FeelingLbl4.isHidden = false
                cell.FeelingLbl4.text = feelings?[3] as? String
            }else if feelings?.count == 5{
                cell.FeelingLbl1.isHidden = false
                cell.FeelingLbl1.text = feelings?[0] as? String
                cell.FeelingLbl2.isHidden = false
                cell.FeelingLbl2.text = feelings?[1] as? String
                cell.FeelingLbl3.isHidden = false
                cell.FeelingLbl3.text = feelings?[2] as? String
                cell.FeelingLbl4.isHidden = false
                cell.FeelingLbl4.text = feelings?[3] as? String
                cell.FeelingLbl5.isHidden = false
                cell.FeelingLbl5.text = feelings?[4] as? String
            }else if (feelings?.count)! >= 6{
                cell.FeelingLbl1.isHidden = false
                cell.FeelingLbl1.text = feelings?[0] as? String
                cell.FeelingLbl2.isHidden = false
                cell.FeelingLbl2.text = feelings?[1] as? String
                cell.FeelingLbl3.isHidden = false
                cell.FeelingLbl3.text = feelings?[2] as? String
                cell.FeelingLbl4.isHidden = false
                cell.FeelingLbl4.text = feelings?[3] as? String
                cell.FeelingLbl5.isHidden = false
                cell.FeelingLbl5.text = feelings?[4] as? String
                cell.FeelingLbl6.isHidden = false
                cell.FeelingLbl6.text = feelings?[5] as? String
            }
        }
        switch Mood {
//        case "Amazing":cell.BackView.backgroundColor = UIColor.MyMoodColor.Amazing
//        case "Very Good":cell.BackView.backgroundColor = UIColor.MyMoodColor.VeryGood
//        case "Good":cell.BackView.backgroundColor = UIColor.MyMoodColor.Good
//        case "Okay":cell.BackView.backgroundColor = UIColor.MyMoodColor.Okay
//        case "Not Good":cell.BackView.backgroundColor = UIColor.MyMoodColor.NotGood
//        case "Bad":cell.BackView.backgroundColor = UIColor.MyMoodColor.Bad
//        case "Awful":cell.BackView.backgroundColor = UIColor.MyMoodColor.Awful
       
        case "Amazing":cell.BackView.setGradientBackground(colorTop: hexStringToUIColor(hex: "#FFEE00").cgColor, colorBottom: hexStringToUIColor(hex: "#FFAA17").cgColor)
            cell.moodImg.image = UIImage(named:String.MyMoodImage.Amazing)
        case "Very Good":cell.BackView.setGradientBackground(colorTop: hexStringToUIColor(hex: "#FF8000").cgColor, colorBottom: hexStringToUIColor(hex: "#F84806").cgColor)
            cell.moodImg.image = UIImage(named:String.MyMoodImage.VeryGood)
        case "Good":cell.BackView.setGradientBackground(colorTop: hexStringToUIColor(hex: "#FE5252").cgColor, colorBottom: hexStringToUIColor(hex: "#BF0000").cgColor)
            cell.moodImg.image = UIImage(named:String.MyMoodImage.Good)
        case "Okay":cell.BackView.setGradientBackground(colorTop: hexStringToUIColor(hex: "#C501FF").cgColor, colorBottom: hexStringToUIColor(hex: "#630180").cgColor)
            cell.moodImg.image = UIImage(named:String.MyMoodImage.Okay)
        case "Not Good":cell.BackView.setGradientBackground(colorTop: hexStringToUIColor(hex: "#00FFEE").cgColor, colorBottom: hexStringToUIColor(hex: "#00D3FF").cgColor)
            cell.moodImg.image = UIImage(named:String.MyMoodImage.NotGood)
        case "Bad":cell.BackView.setGradientBackground(colorTop: hexStringToUIColor(hex: "#008DF9").cgColor, colorBottom: hexStringToUIColor(hex: "#0008FF").cgColor)
            cell.moodImg.image = UIImage(named:String.MyMoodImage.Bad)
        case "Awful":cell.BackView.setGradientBackground(colorTop: hexStringToUIColor(hex: "#4400CF").cgColor, colorBottom: hexStringToUIColor(hex: "#422382").cgColor)
            cell.moodImg.image = UIImage(named:String.MyMoodImage.Awful)
             default :cell.BackView.setGradientBackground(colorTop: hexStringToUIColor(hex: "#C501FF").cgColor, colorBottom: hexStringToUIColor(hex: "#630180").cgColor)
        }
        cell.BackView.CornerRadius(5)
        return cell
    }
    //MARK:TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "InsightsDetailVC") as! InsightsDetailVC
        vc.DataDict = DateDict[uniquetitleSection[indexPath.section]] as! [NSDictionary]
        vc.date = uniquetitleSection[indexPath.section]
        vc.indexdata = indexPath.row
        self.present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = hexStringToUIColor(hex: "#F5F5F5")
        headerView.alpha = 0.85
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:
            tableView.bounds.size.width, height: 33))
        headerLabel.text = uniquetitleSection[section]
        headerLabel.font = UIFont(name:"SegoeUI-Bold", size: 25)
        headerLabel.textColor = hexStringToUIColor(hex:"#003644")
        headerLabel.sizeToFit()
        headerLabel.contentMode = .scaleToFill
        headerView.addSubview(headerLabel)
        
        return headerView
    }
}
extension InsigtsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //MARK: COLLECTIONVIEW DATASOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if yearActive == true{
            return numberOfItems
        }else{
            return uniquetitleSection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if yearActive == true{
            if collectionView == StackBarCollectionView{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StackChartBarCVCell", for: indexPath) as! StackChartBarCVCell
                cell.dropShadowTransLife()
                cell.yellowColorAmazingHeight.constant = 0
                cell.orangeColorVeryGoodHeight.constant = 0
                cell.greenColorGoodHeight.constant = 0
                cell.skyblueColorOkayHeight.constant = 0
                cell.BlueColorNotGoodHeight.constant = 0
                cell.purpleColorBadHeight.constant = 0
                cell.redColorAwfulHeight.constant = 0
                switch indexPath.item{
                case 0: containAllMoodForYear = janMoodArr
                case 1: containAllMoodForYear = febMoodArr
                case 2: containAllMoodForYear = marMoodArr
                case 3: containAllMoodForYear = aprMoodArr
                case 4: containAllMoodForYear = mayMoodArr
                case 5: containAllMoodForYear = junMoodArr
                case 6: containAllMoodForYear = julMoodArr
                case 7: containAllMoodForYear = augMoodArr
                case 8: containAllMoodForYear = sepMoodArr
                case 9: containAllMoodForYear = octMoodArr
                case 10: containAllMoodForYear = novMoodArr
                case 11: containAllMoodForYear = decMoodArr
                default: break
                }
                let total = containAllMoodForYear.count
                let amazingCount = containAllMoodForYear.filter{$0 == "Amazing"}.count
                let verygoodCount = containAllMoodForYear.filter{$0 == "Very Good"}.count
                let goodCount = containAllMoodForYear.filter{$0 == "Good"}.count
                let okayCount = containAllMoodForYear.filter{$0 == "Okay"}.count
                let notGoodCount = containAllMoodForYear.filter{$0 == "Not Good"}.count
                let BadCount = containAllMoodForYear.filter{$0 == "Bad"}.count
                let AwfulCount = containAllMoodForYear.filter{$0 == "Awful"}.count
                
                UIView.animate(withDuration: 0.7) {
                    cell.yellowColorAmazingHeight.constant = CGFloat(total != 0 ? Double(amazingCount)/Double(total) * 150  : 0)
                    cell.orangeColorVeryGoodHeight.constant = CGFloat(Float(total != 0 ? Double(verygoodCount)/Double(total) * 150  : 0))
                    cell.greenColorGoodHeight.constant = CGFloat(Float(total != 0 ? Double(goodCount)/Double(total) * 150  : 0))
                    cell.skyblueColorOkayHeight.constant = CGFloat(Float(total != 0 ? Double(okayCount)/Double(total) * 150  : 0))
                    cell.BlueColorNotGoodHeight.constant = CGFloat(Float(total != 0 ? Double(notGoodCount)/Double(total) * 150  : 0))
                    cell.purpleColorBadHeight.constant = CGFloat(Float(total != 0 ? Double(BadCount)/Double(total) * 150  : 0))
                    cell.redColorAwfulHeight.constant = CGFloat(Float(total != 0 ? Double(AwfulCount)/Double(total) * 150  : 0))
                    //self.view.layoutIfNeeded()
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StackChartBarDateMonthCVCell", for: indexPath) as! StackChartBarDateMonthCVCell
                cell.dateOrMonthLbl.text = month[indexPath.row]
                cell.dateOrMonthLbl.font = UIFont(name:"SegoeUI", size: 10)
                
                return cell
            }
        }else{
            if collectionView == StackBarCollectionView{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StackChartBarCVCell", for: indexPath) as! StackChartBarCVCell
                cell.dropShadowTransLife()
                cell.yellowColorAmazingHeight.constant = 0
                cell.orangeColorVeryGoodHeight.constant = 0
                cell.greenColorGoodHeight.constant = 0
                cell.skyblueColorOkayHeight.constant = 0
                cell.BlueColorNotGoodHeight.constant = 0
                cell.purpleColorBadHeight.constant = 0
                cell.redColorAwfulHeight.constant = 0
                let myArray = reversedmoodarr[indexPath.item]
                let total = myArray.count
                let amazingCount = myArray.filter{$0 == "Amazing"}.count
                let verygoodCount = myArray.filter{$0 == "Very Good"}.count
                let goodCount = myArray.filter{$0 == "Good"}.count
                let okayCount = myArray.filter{$0 == "Okay"}.count
                let notGoodCount = myArray.filter{$0 == "Not Good"}.count
                let BadCount = myArray.filter{$0 == "Bad"}.count
                let AwfulCount = myArray.filter{$0 == "Awful"}.count
                
                UIView.animate(withDuration: 0.7) {
                    cell.yellowColorAmazingHeight.constant = CGFloat(total != 0 ? Double(amazingCount)/Double(total) * 150  : 0)
                    cell.orangeColorVeryGoodHeight.constant = CGFloat(Float(total != 0 ? Double(verygoodCount)/Double(total) * 150  : 0))
                    cell.greenColorGoodHeight.constant = CGFloat(Float(total != 0 ? Double(goodCount)/Double(total) * 150  : 0))
                    cell.skyblueColorOkayHeight.constant = CGFloat(Float(total != 0 ? Double(okayCount)/Double(total) * 150  : 0))
                    cell.BlueColorNotGoodHeight.constant = CGFloat(Float(total != 0 ? Double(notGoodCount)/Double(total) * 150  : 0))
                    cell.purpleColorBadHeight.constant = CGFloat(Float(total != 0 ? Double(BadCount)/Double(total) * 150  : 0))
                    cell.redColorAwfulHeight.constant = CGFloat(Float(total != 0 ? Double(AwfulCount)/Double(total) * 150  : 0))
                    self.view.layoutIfNeeded()
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StackChartBarDateMonthCVCell", for: indexPath) as! StackChartBarDateMonthCVCell
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                let localDate = dateFormatter.date(from: reversedUniquetitleSection[indexPath.row])
                dateFormatter.dateFormat = "dd"
                let day = dateFormatter.string(from: localDate!)
                cell.dateOrMonthLbl.font = UIFont(name:"SegoeUI-Regular", size: 8)
                cell.dateOrMonthLbl.text = day
                return cell
            }
        }
        
    }
    //MARK: COLLECTIONVIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if yearActive == true{
            monthActive = true
            weekActive = false
            yearActive = false
            firstLabelForWeek.isHidden = false
            secondLabelForWeek.isHidden = true
            spaceBar.isHidden = true
            tableContentView.bringSubviewToFront(pieChartContainerView)
            MonthBtn.alpha = 1
            WeekBtn.alpha = 0.5
            YearBtn.alpha = 0.5
            let monthName = DateFormatter().monthSymbols[indexPath.item]
            GetMoodTrackUserforMonth(month:monthName)
            firstLabelForWeek.text = monthName
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            let monthdate = formatter.date(from: monthName)
            monthasDate = monthdate!
            MonthBtn.isUserInteractionEnabled = false
            YearBtn.isUserInteractionEnabled = true
            WeekBtn.isUserInteractionEnabled = true
        }
        if weekActive == true{
            let totalitem = uniquetitleSection.count - 1
            let indexpath = NSIndexPath(row: 0, section: totalitem - indexPath.item)
            TableVIEW.scrollToRow(at: indexpath as IndexPath, at: .top, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if yearActive == true{
            if collectionView == StackBarCollectionView{
                let collectionViewWidth = StackBarCollectionView.frame.width
                let itemWidth = collectionViewWidth/12 - 10
                return CGSize(width: itemWidth, height: 150)
            }else{
                let collectionViewWidth = StackBarDateMonthCollectionView.frame.width
                let itemWidth = collectionViewWidth/12
                return CGSize(width: itemWidth, height: 20)
            }
        }else{
            if collectionView == StackBarCollectionView{
                let collectionViewWidth = StackBarCollectionView.frame.width
                let itemWidth = collectionViewWidth/12
                return CGSize(width: itemWidth, height: 150)
            }else{
                let collectionViewWidth = StackBarDateMonthCollectionView.frame.width
                let itemWidth = collectionViewWidth/12
                return CGSize(width: itemWidth, height: 20)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if yearActive == true{
            if collectionView == StackBarCollectionView{
                return 11
            }else{
                return 0
            }
        }else{
            if collectionView == StackBarCollectionView{
                return ItemSpace
            }else{
                return ItemSpace
            }
        }
    }
}

extension InsigtsVC:CSPieChartDelegate,CSPieChartDataSource{
    
    //MARK: PIECHART DATASOURCE
    func numberOfComponentData() -> Int {
        return dataList.count
    }
    
    func pieChart(_ pieChart: CSPieChart, dataForComponentAt index: Int) -> CSPieChartData {
        return dataList[index]
    }
    
    func numberOfComponentColors() -> Int {
        return colorList.count
    }
    
    func pieChart(_ pieChart: CSPieChart, colorForComponentAt index: Int) -> UIColor {
        return hexStringToUIColor(hex: colorList[index])//colorList[index]
    }
    
    func numberOfLineColors() -> Int {
        return colorList.count
    }
    
    func pieChart(_ pieChart: CSPieChart, lineColorForComponentAt index: Int) -> UIColor {
        return hexStringToUIColor(hex: colorList[index])
    }
    
    func numberOfComponentSubViews() -> Int {
        return dataList.count
    }
    
    //    func pieChart(_ pieChart: CSPieChart, viewForComponentAt index: Int) -> UIView {
    //        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    //        view.image = UIImage(named: "test.png")
    //        view.layer.cornerRadius = 15
    //        view.clipsToBounds = true
    //        return view
    //    }
    //MARK: PIECHART DELEGATE
    func pieChart(_ pieChart: CSPieChart, didSelectComponentAt index: Int) {
        let data = dataList[index]
        if data.key == "amazing"{
            
        }else  if data.key == "verygood"{
            
        }else  if data.key == "good"{
            
        }else  if data.key == "okay"{
            
        }else  if data.key == "notgood"{
            
        }else  if data.key == "bad"{
            
        }else  if data.key == "awful"{
            
        }
    }
}
