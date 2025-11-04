//
//  NMSurvey3VC.swift
//  transLife
//
//  Created by Silstone Group on 23/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit

class NonMandatorySurvey4VC: UIViewController {

    let savingSurvey = Survey()
    let quesArr = ["Ques 1. How many people in each group below currently know you are trans?","#1.Immediate family you grew up with (mother, father, sisters, brothers, etc.) ","#2.Extended family (aunts, uncles, cousins, etc.)","#3.Lesbian, gay, bisexual, or trans (LGBT) friends ","#4.Straight, non-trans (non-LGBT) friends ","#5.Current boss/ manager/supervisor ","#6.Current coworkers ","#7.Current classmates ","#8.Current health care providers ","Ques 2.You said some or all of your immediate family you grew up with (mother, father, sisters, brothers, etc.) know that you are trans. On average, how supportive are they of you being trans? ","Ques 3.On average, how supportive are your co-workers with you being trans?","Ques 4.On average, how supportive are your classmates with you being trans? "]
    var KnowYouAsTransArr = ["I currently have no people like this in my life/Not applicable","All know that I am trans","Most know that I am trans ","Some know that I am trans ","None know that I am trans"]
     var SupportiveOrNotArr = ["Very supportive","Supportive","Neither supportive nor unsupportive","Unsupportive","Very unsupportive"]
    var optionArr = [String]()
    var quesFor = ""
    var cellHeightsDictionary: [AnyHashable : Any] = [:]
    @IBOutlet weak var Viewheight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainBlurTop: NSLayoutConstraint!
    @IBOutlet weak var navTopSafeArea: NSLayoutConstraint!
    var surveyDict = [String:Any]()
    @IBOutlet weak var mainBlurViewBottom: NSLayoutConstraint!
    @IBOutlet weak var QuesTableView: UITableView!
    @IBOutlet weak var optionTableView: UITableView!
    var Screenframeheight  = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.optionTableView.allowsMultipleSelection = false
        self.optionTableView.allowsMultipleSelectionDuringEditing = false
        Screenframeheight  = self.view.frame.height
        mainBlurTop.constant = Screenframeheight
        mainBlurViewBottom.constant = -Screenframeheight
    }
    
    override func viewDidAppear(_ animated: Bool) {
        QuesTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        let height = self.QuesTableView.contentSize.height
        Viewheight.constant = height + 100
        self.tableViewHeight?.constant = height
    }
    @IBAction func BackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func SubmitBtnAction(_ sender: Any) {
        if surveyDict.count < 11{
            PresentAlert(message: "please submit all answers", title: "TransLife")
        }else{
            savingSurvey.saveSurveyWith(Dict: surveyDict, view: self, surveyName: "Trans visibility and support")        }
        
    }
    @IBAction func tableViewItemDoneAct(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurTop.constant = self.Screenframeheight
            self.mainBlurViewBottom.constant = -self.Screenframeheight
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.QuesTableView.reloadData()
    }
    
    @IBAction func CancelBtnItemAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurTop.constant = self.Screenframeheight
            self.mainBlurViewBottom.constant = -self.Screenframeheight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}
extension NonMandatorySurvey4VC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == QuesTableView{
            return quesArr.count
        }else{
            return optionArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == QuesTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTvCell", for: indexPath) as! MultipleSelectionTvCell
            cell.questionLbl.text = quesArr[indexPath.row]
            if indexPath.row == 0{
                cell.viewFordropdown.isHidden = true
                cell.healthcarelistLabel.text = "mark all that apply"
                
            }else  if indexPath.row == 8{
                cell.selectAnswerBtn.setTitle("select answer", for: .normal)
            }
            if  indexPath.row == 9{
                cell.selectAnswerBtn.setTitle(surveyDict["ques2"] as? String, for: .normal)
            }else if  indexPath.row == 10{
                cell.selectAnswerBtn.setTitle(surveyDict["ques3"] as? String, for: .normal)
            }else if  indexPath.row == 11{
                cell.selectAnswerBtn.setTitle(surveyDict["ques4"] as? String, for: .normal)
            }else if  indexPath.row == 1{
                cell.selectAnswerBtn.setTitle(surveyDict["ques1group1"] as? String, for: .normal)
            }else if  indexPath.row == 2{
                cell.selectAnswerBtn.setTitle(surveyDict["ques1group2"] as? String, for: .normal)
            }else if  indexPath.row == 3{
                cell.selectAnswerBtn.setTitle(surveyDict["ques1group3"] as? String, for: .normal)
            }else if  indexPath.row == 4{
                cell.selectAnswerBtn.setTitle(surveyDict["ques1group4"] as? String, for: .normal)
            }else if  indexPath.row == 5{
                cell.selectAnswerBtn.setTitle(surveyDict["ques1group5"] as? String, for: .normal)
            }else if  indexPath.row == 6{
                cell.selectAnswerBtn.setTitle(surveyDict["ques1group6"] as? String, for: .normal)
            }else if  indexPath.row == 7{
                cell.selectAnswerBtn.setTitle(surveyDict["ques1group7"] as? String, for: .normal)
            }else if  indexPath.row == 8{
                cell.selectAnswerBtn.setTitle(surveyDict["ques1group8"] as? String, for: .normal)
            }
            cell.layoutIfNeeded()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyTVCell", for: indexPath) as! SurveyTVCell
            cell.answerLbl.text = optionArr[indexPath.row]
            if quesFor == "1"{
                if let val = surveyDict["ques1group1"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "2"{
                if let val = surveyDict["ques1group2"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "3"{
                if let val = surveyDict["ques1group3"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "4"{
                
                if let val = surveyDict["ques1group4"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "5"{
                if let val = surveyDict["ques1group5"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "6"{
                if let val = surveyDict["ques1group6"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "7"{
                if let val = surveyDict["ques1group7"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "8"{
                if let val = surveyDict["ques1group8"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "9"{
                if let val = surveyDict["ques2"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "10"{
                if let val = surveyDict["ques3"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "11"{
                if let val = surveyDict["ques4"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }
            cell.layoutIfNeeded()
            return cell
        }
     
    }
    //MARK:TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary[indexPath] = cell.frame.size.height
        self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = cellHeightsDictionary[indexPath] as? NSNumber
        if height != nil {
            return CGFloat(Double(truncating: height ?? 0.0))
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == QuesTableView{
            if indexPath.row >= 9 && indexPath.row <= 11{
                optionArr = SupportiveOrNotArr
                quesFor = "\(indexPath.row)"
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainBlurTop.constant = self.navTopSafeArea.constant
                    self.mainBlurViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else if indexPath.row == 0{
            
        }else if indexPath.row >= 1 && indexPath.row <= 8{
            optionArr = KnowYouAsTransArr
           quesFor = "\(indexPath.row)"
            UIView.animate(withDuration: 0.4, animations: {
                self.mainBlurTop.constant = self.navTopSafeArea.constant
                self.mainBlurViewBottom.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
            }
         optionTableView.reloadData()
        }else{
            if quesFor == "9"{
                surveyDict.updateValue(SupportiveOrNotArr[indexPath.row], forKey: "ques2")
            }else if quesFor == "10"{
                surveyDict.updateValue(SupportiveOrNotArr[indexPath.row], forKey: "ques3")
            }else if quesFor == "11"{
                surveyDict.updateValue(SupportiveOrNotArr[indexPath.row], forKey: "ques4")
            }else if quesFor == "1"{
            surveyDict.updateValue(KnowYouAsTransArr[indexPath.row], forKey: "ques1group1")
            }else if quesFor == "2"{
               surveyDict.updateValue(KnowYouAsTransArr[indexPath.row], forKey: "ques1group2")
            }else if quesFor == "3"{
                surveyDict.updateValue(KnowYouAsTransArr[indexPath.row], forKey: "ques1group3")
            }else if quesFor == "4"{
                surveyDict.updateValue(KnowYouAsTransArr[indexPath.row], forKey: "ques1group4")
            }else if quesFor == "5"{
                surveyDict.updateValue(KnowYouAsTransArr[indexPath.row], forKey: "ques1group5")
            }else if quesFor == "6"{
                surveyDict.updateValue(KnowYouAsTransArr[indexPath.row], forKey: "ques1group6")
            }else if quesFor == "7"{
                surveyDict.updateValue(KnowYouAsTransArr[indexPath.row], forKey: "ques1group7")
            }else if quesFor == "8"{
                surveyDict.updateValue(KnowYouAsTransArr[indexPath.row], forKey: "ques1group8")
            }
            optionTableView.reloadData()
        }
        }
    
    
    
}
