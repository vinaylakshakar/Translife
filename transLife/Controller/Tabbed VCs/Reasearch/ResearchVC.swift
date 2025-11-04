//
//  ResearchVC.swift
//  transLife
//
//  Created by Developer Silstone on 10/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD



class ResearchVC: UIViewController {

    @IBOutlet weak var TopProgressView: UIView!
    @IBOutlet weak var PendingRedView: UIView!
    @IBOutlet weak var CompleteGreenView: UIView!
    @IBOutlet weak var ProgressBAR: UIProgressView!
    @IBOutlet weak var myTableView: UITableView!
    
    var sections = [[AnyObject](),[AnyObject]()]
    var mandatoryArr = [NSDictionary]()
    var nonmandatoryArr = [NSDictionary]()
    var SurveyRows = [String]()
    var totalSurvey = Int()
    var sortedMandArr = [NSDictionary]()
    var titleSection = ["",""]
    let alertIMG = ["alert_red","nil"]
    var survey1Submitted = CFIndex()
    var survey2Submitted = CFIndex()
    var survey3Submitted = CFIndex()
    var survey4Submitted = CFIndex()
    var survey5Submitted = CFIndex()
    var survey6Submitted = CFIndex()
    
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController?.navigationBar.isHidden = true
         self.setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        getUserSurveyStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TopProgressView.CornerRadius(5)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem.imageInsets.bottom = -5
        self.tabBarItem.imageInsets.top = 5
         self.tabBarItem.image = UIImage(named: "nav_research_unselected")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "nav_research_selected")?.withRenderingMode(.alwaysOriginal)
    }
    
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        needToRefresh = true
    }
    
    func getUserSurveyStatus() {
        SVProgressHUD.show()
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("userSurveyDetail").child(username).observeSingleEvent(of: .value) { (snap) in
                self.mandatoryArr.removeAll()
                self.nonmandatoryArr.removeAll()
                self.sections[0].removeAll()
                self.sections[1].removeAll()
                self.SurveyRows.removeAll()
                self.titleSection.removeAll()
                if snap.value is NSNull{
                    SVProgressHUD.dismiss()
                    self.myTableView.delegate = self
                    self.myTableView.dataSource = self
                    self.myTableView.reloadData()
                }else{
                let snapValue = snap.value as! [String:AnyObject]
                self.totalSurvey = snapValue.count
                for i in 0...1{
                        self.titleSection.append("")
                    }
                for i in snapValue{
                    if i.value["status"] as! Bool == false{
                         self.SurveyRows.append(i.key)
                    }
                    if i.value["status"] as! Bool == false && i.value["type"] as! String == "non mandatory"{
                         self.nonmandatoryArr.append(i.value as! NSDictionary)
                    }else if i.value["status"] as! Bool == false && i.value["type"] as! String == "mandatory"{
                         self.mandatoryArr.append(i.value as! NSDictionary)
                    }
                }
                    let sortedNonMandArr =  self.nonmandatoryArr.sorted(by: { $0["currentTimeStamp"] as! Double > $1["currentTimeStamp"] as! Double })
                    self.sections[1] = sortedNonMandArr
                    let sortedMandArr =  self.mandatoryArr.sorted(by: { $0["currentTimeStamp"] as! Double > $1["currentTimeStamp"] as! Double })
                    self.sections[0] = sortedMandArr
                    if self.sections[0].count != 0{
                        self.titleSection[0].append("Mandatory")
                    }
                    if self.sections[1].count != 0{
                        self.titleSection[1].append("Non Mandatory")
                    }
                let surveyCount =  self.SurveyRows.count
                let progress = (1 - (Float(surveyCount)/Float(snapValue.count)) )
               
                UIView.animate(withDuration: 0.4) {
                    self.ProgressBAR.progress = progress
                    self.view.layoutIfNeeded()
                }
                self.myTableView.delegate = self
                self.myTableView.dataSource = self
                self.myTableView.reloadData()
                SVProgressHUD.dismiss()
                    UserDefaults.standard.set(self.SurveyRows, forKey: "SurveyRows")
                    UserDefaults.standard.set(self.mandatoryArr, forKey: "MandatoryArr")
                    UserDefaults.standard.set(self.totalSurvey, forKey: "TotalSurvey")
                    UserDefaults.standard.set(true, forKey: "userDefaultHaveSurveyData")
                }
            }
        }
    }

    func setupUI()  {
        PendingRedView.layer.cornerRadius = PendingRedView.frame.height/2
        PendingRedView.clipsToBounds = true
        CompleteGreenView.layer.cornerRadius = CompleteGreenView.frame.height/2
        CompleteGreenView.clipsToBounds = true
        ProgressBAR.layer.cornerRadius = 5
        ProgressBAR.clipsToBounds = true
    }
    //MARK:ACTIONS

    
}
extension ResearchVC:UITableViewDataSource,UITableViewDelegate{

//    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
//        if let stepResult = taskViewController.result.stepResult(forStepIdentifier: "NameStep") {
//            let stepResults = stepResult.results
//            let stepNameResult = stepResults?.first
//            let Result = stepNameResult as? ORKTextQuestionResult
//            print(Result?.textAnswer as Any)
//        }
//        taskViewController.dismiss(animated: true, completion: nil)
//    }
 
    
    //MARK: TABLEVIEW DATASOURCE

    func numberOfSections(in tableView: UITableView) -> Int {
       return titleSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
     //MARK:TABLEVIEW DELEGATE

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let surveyname = sections[indexPath.section][indexPath.row]["surveyName"] as! String
        
            if surveyname == "Current Trans Experience"{
                PushTo(FromVC: self, ToStoryboardID: "NonMandatorySurvey1VC")
            }else if surveyname == "Demographics"{
                PushTo(FromVC: self, ToStoryboardID: "NonMandatorySurvey2VC")
            }else if surveyname == "Trans related discrimination"{
                PushTo(FromVC: self, ToStoryboardID: "NonMandatorySurvey3VC")
            }else if surveyname == "Trans visibility and support"{
                PushTo(FromVC: self, ToStoryboardID: "NonMandatorySurvey4VC")
            }else if surveyname == "Medical/surgical transition"{
                PushTo(FromVC: self, ToStoryboardID: "NonMandatorySurvey5VC")
            }else if surveyname == "Baseline survey" {
               // PushTo(FromVC: self, ToStoryboardID: "OnboardingSurveyVC")
                let vc = storyboard?.instantiateViewController(withIdentifier: "OnboardingSurveyVC") as! OnboardingSurveyVC
                vc.pushedFromSurvey = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
      

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResearchTVCell", for: indexPath) as! ResearchTVCell
        let sect = sections[indexPath.section]
        cell.LblSurveyNo.text = sect[indexPath.row]["surveyName"] as? String
        if indexPath.section == 0{
            cell.LblSurveyType.text = "Mandatory"
        }else{
            cell.LblSurveyType.text = "Non Mandatory"
        }
        //cell.LblSurveyType.text = ""
        return cell
    }
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        //view.tintColor = UIColor.white
//        guard let header = view as? UITableViewHeaderFooterView else {return}
//        header.textLabel?.textColor = UIColor(displayP3Red: 217, green: 101, blue: 20, alpha: 1)
//        //header.textLabel?.font = UIFont(name: "seguibl", size: 35)
//
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if titleSection[section] == ""{
            return 0
        }else{
            return 50
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        
        let headerView = UIView()
        headerView.backgroundColor = hexStringToUIColor(hex: "#FB803B")
        headerView.alpha = 0.95
        
        let headerLabel = UILabel(frame: CGRect(x: 27, y: 0, width:
            tableView.bounds.size.width, height: 40))
        headerLabel.text = titleSection[section]
        headerLabel.font = UIFont(name:"SegoeUI-Bold", size: 35)
       // let color = UIColor
        headerLabel.textColor = hexStringToUIColor(hex:"#FFFFFF")
        headerLabel.sizeToFit()
        headerLabel.contentMode = .center
        headerView.addSubview(headerLabel)
        
        let image = UIImageView()
        headerView.addSubview(image)
        image.image = UIImage(named: alertIMG[section])
        let x = myTableView.frame.width * 13 / 15
        image.frame = CGRect(x: x, y: 15, width: 25, height: 25)
    
        return headerView
    }
   
}
