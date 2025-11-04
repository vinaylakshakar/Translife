//
//  NonMandatorySurvey3VC.swift
//  transLife
//
//  Created by Silstone Group on 24/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit

class NonMandatorySurvey3VC: UIViewController {
    
    let savingSurvey = Survey()
    let quesArr = ["Ques 1.Have you ever de-transitioned? In other words, have you ever gone back to living as your sex assigned at birth, at least for a while? ","Ques 2.Why did you de-transition? In other words, why did you go back to living as your sex assigned at birth? ","Ques 3.Was there a time in the past 12 months when you needed to see a doctor but did not because you thought you would be disrespected or mistreated as a trans person? ","Ques 4.In the past year, did anyone tell or ask you if you were using the wrong bathroom? ","Ques 5.In the past year, did anyone stop you from entering or deny you access to a bathroom? ","Ques 6.In the past year, did any of these things happen to you because of trans discrimination at work? ","Ques 7.Have you ever had any of these housing situations because you are trans? ","Ques 8.In the past year, did strangers verbally harass you in public because of your trans status, gender identity, or gender expression? ","Ques 9.In the past year, did strangers physically attack you in public because of your trans status, gender identity, or gender expression? ","Ques 10.Have you ever experienced unwanted sexual contact (such as oral, genital, or anal contact or penetration, forced fondling, rape)?","Ques 11.Now just thinking about the past year, have you experienced unwanted sexual contact (such as oral, genital, or anal contact or penetration, forced fondling, rape)? ","Ques 12.Who did this to you? (Mark all that apply.) ","Ques 13.Have any of your romantic or sexual partners ever...? "]
    let reasonforDetransitionArr = ["Pressure from spouse or partner ","Pressure from a parent","Pressure from other family members","Pressure from friends","Pressure from my employer","Pressure from a religious counselor","Pressure from a mental health professional","I had trouble getting a job","I realized that gender transition was not for me","I faced too much harassment/discrimination","It was just too hard for me","Not listed above (please specify)"]
    let happenningsBecauseDescrimArr = ["My employer/boss forced me to resign in the past year.","My employer/boss forced me to transfer to a different position/department at my job in the past year.","My employer/boss removed me from direct contact with clients, customers, or patients in the past year.","My employer/boss told me to present in the wrong gender in order to keep my job in the past year.","My employer/boss gave me a negative job review in the past year.","My employer/boss and I could not work out an acceptable bathroom situation in the past year.","My employer/boss did not let me use the bathroom I should be using based on my gender identity in the past year.","My employer/boss or coworkers shared information about me that they should not have in the past year."]
    let housingSituationsArr  = ["I was evicted from my home/apartment.","I was denied a home/apartment.","I experienced homelessness.","I had to move back in with family members or friends.","I had to move into a less expensive home/ apartment.","I slept in different places for short periods of time, such as on a friend’s couch."]
    let WhoDidArr = ["A partner/ex-partner","A relative","A friend/acquaintance","A law enforcement officer","A health care provider/doctor","A stranger","A boss or supervisor","A co-worker","A teacher or school staff member","A person not listed above"]
    let everDidThingsArr = ["Tried to keep you from seeing or talking to your family or friends","Kept you from having money for your own use","Kept you from leaving the house when you wanted to go","Hurt someone you love","Threatened to hurt a pet or threatened to take a pet away from you","Wouldn’t let you have your hormones","Wouldn’t let you have other medications","Threatened to call the police on you","Threatened to “out” you","Told you that you weren’t a “real” woman or man","Stalked you","Made threats to physically harm you" ]
    var optionTableArr = [String]()
    var cellHeightsDictionary: [AnyHashable : Any] = [:]
    
    @IBOutlet weak var Viewheight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainBlurTop: NSLayoutConstraint!
    @IBOutlet weak var navTopSafeArea: NSLayoutConstraint!
    @IBOutlet weak var mainBlurViewBottom: NSLayoutConstraint!
    @IBOutlet weak var QuesTableView: UITableView!
    @IBOutlet weak var optionTableView: UITableView!
   // var yesBtnImg = ""
    var quesFor = ""
    var quesKey = ""
   // var senderTag = Int()
    var Screenframeheight  = CGFloat()
    var surveyDict = [String:Any]()
    var whoDidAnsArr = [String]()
     var entryArr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Screenframeheight  = self.view.frame.height
        mainBlurTop.constant = Screenframeheight
        mainBlurViewBottom.constant = -Screenframeheight
        forSettingValueOfradioImg()
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
    
    func forSettingValueOfradioImg(){
        for i in 0...quesArr.count{
            
            if(i==0||i>10)
            {
                self.entryArr.append("NotUsed")
            }
            else{
                self.entryArr.append("0")
            }
        }
    }
    @IBAction func BackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func SubmitBtnAction(_ sender: Any) {
        if surveyDict.count < 13{
            PresentAlert(message: "please submit all answers", title: "TransLife")
        }else{
            savingSurvey.saveSurveyWith(Dict: surveyDict, view: self, surveyName: "Trans related discrimination")
        }
        
    }
    @IBAction func tableViewItemDoneAct(_ sender: Any) {
        surveyDict.updateValue(whoDidAnsArr, forKey: "que12")
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurTop.constant = self.Screenframeheight
            self.mainBlurViewBottom.constant = -self.Screenframeheight
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.QuesTableView.reloadData()
        print(surveyDict)
    }
    @IBAction func CancelBtnItemAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurTop.constant = self.Screenframeheight
            self.mainBlurViewBottom.constant = -self.Screenframeheight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
  
    @objc func radioBtnYesClicked(_ sender:UIButton) {
      //  yesBtnImg = "yes"
        QuesTableView.reloadData()
       // senderTag = sender.tag
        self.entryArr[sender.tag] = "1"
        surveyDict.updateValue("yes", forKey: "quesNo \(1+sender.tag)")
    }
    
    @objc func radioBtnNoClicked(_ sender:UIButton) {
      //  yesBtnImg = "no"
        QuesTableView.reloadData()
       // senderTag = sender.tag
        self.entryArr[sender.tag] = "2"
        surveyDict.updateValue("no", forKey: "quesNo\(1+sender.tag)")
    }

}
extension NonMandatorySurvey3VC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == QuesTableView{
            return quesArr.count
        }else{
            return optionTableArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == QuesTableView{
            if indexPath.row == 1||indexPath.row == 5||indexPath.row == 6||indexPath.row == 11||indexPath.row == 12{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTvCell", for: indexPath) as! MultipleSelectionTvCell
                cell.questionLbl.text = quesArr[indexPath.row]
                if  indexPath.row == 1 {
                    cell.selectAnswerBtn.setTitle(surveyDict["que2"] as? String, for: .normal)
                  
                }else if  indexPath.row == 5{
                      cell.selectAnswerBtn.setTitle(surveyDict["que6"] as? String, for: .normal)
                }else if  indexPath.row == 6{
                       cell.selectAnswerBtn.setTitle(surveyDict["que7"] as? String, for: .normal)
                }else if  indexPath.row == 11{
                      cell.selectAnswerBtn.setTitle("you have choosen \(whoDidAnsArr.count) options", for: .normal)
                }else if  indexPath.row == 12{
                     cell.selectAnswerBtn.setTitle(surveyDict["que13"] as? String, for: .normal)
                }
                cell.layoutIfNeeded()
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoOptionTvCell", for: indexPath) as! TwoOptionTvCell
                cell.QuestionLbl.text = quesArr[indexPath.row]
                cell.radioImgYesBtn.tag = indexPath.row
                cell.radioImgNoBtn.tag = indexPath.row
                cell.radioImgNoBtn.addTarget(self, action: #selector(radioBtnNoClicked(_ :)), for: .touchUpInside)
                cell.radioImgYesBtn.addTarget(self, action: #selector(radioBtnYesClicked(_ :)), for: .touchUpInside)
                    cell.radioImgYesBtn.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
                    cell.radioImgNoBtn.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
                if(self.entryArr[indexPath.row] == "1"){
                    cell.radioImgYesBtn.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
                }
                if(self.entryArr[indexPath.row] == "2"){
                    cell.radioImgNoBtn.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
                }
                cell.layoutIfNeeded()
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyTVCell", for: indexPath) as! SurveyTVCell
            cell.answerLbl.text = optionTableArr[indexPath.row]
            if whoDidAnsArr.contains(cell.answerLbl.text ?? "nii"){
                DispatchQueue.main.async(execute: {
                    cell.RadioImg.image = UIImage(named: "radio_button_selected")
                })
            }
            if quesFor == "reasonforDetransitionArr"{
                if let val = surveyDict["que2"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "happenningsBecauseDescrimArr"{
                if let val = surveyDict["que6"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "housingSituationsArr"{
                if let val = surveyDict["que7"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "everDidThingsArr"{
                
                if let val = surveyDict["que13"]  {
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary[indexPath] = cell.frame.size.height
         self.viewWillLayoutSubviews()
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
            if indexPath.row == 1{
                optionTableArr = reasonforDetransitionArr
                quesFor = "reasonforDetransitionArr"
                optionTableView.allowsMultipleSelection = false
                optionTableView.allowsMultipleSelectionDuringEditing = false
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainBlurTop.constant = self.navTopSafeArea.constant
                    self.mainBlurViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else if indexPath.row == 5{
                optionTableArr = happenningsBecauseDescrimArr
                quesFor = "happenningsBecauseDescrimArr"
                optionTableView.allowsMultipleSelection = false
                optionTableView.allowsMultipleSelectionDuringEditing = false
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainBlurTop.constant = self.navTopSafeArea.constant
                    self.mainBlurViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else if indexPath.row == 6{
                optionTableArr = housingSituationsArr
                quesFor = "housingSituationsArr"
                optionTableView.allowsMultipleSelection = false
                optionTableView.allowsMultipleSelectionDuringEditing = false
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainBlurTop.constant = self.navTopSafeArea.constant
                    self.mainBlurViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else if indexPath.row == 11{
                optionTableArr = WhoDidArr
                quesFor = "WhoDidArr"
                optionTableView.allowsMultipleSelection = true
                optionTableView.allowsMultipleSelectionDuringEditing = true
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainBlurTop.constant = self.navTopSafeArea.constant
                    self.mainBlurViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else if indexPath.row == 12{
                optionTableArr = everDidThingsArr
                quesFor = "everDidThingsArr"
                optionTableView.allowsMultipleSelection = false
                optionTableView.allowsMultipleSelectionDuringEditing = false
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainBlurTop.constant = self.navTopSafeArea.constant
                    self.mainBlurViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            optionTableView.reloadData()
        }else{
            let AnsOptionCell = self.optionTableView.cellForRow(at: indexPath) as! SurveyTVCell
            if quesFor == "reasonforDetransitionArr"{
                surveyDict.updateValue(reasonforDetransitionArr[indexPath.row], forKey: "que2")
                optionTableView.reloadData()
            }else if quesFor == "happenningsBecauseDescrimArr"{
                surveyDict.updateValue(happenningsBecauseDescrimArr[indexPath.row], forKey: "que6")
                optionTableView.reloadData()
            }else if quesFor == "housingSituationsArr"{
                surveyDict.updateValue(housingSituationsArr[indexPath.row], forKey: "que7")
                optionTableView.reloadData()
            }else if quesFor == "WhoDidArr"{
                if whoDidAnsArr.contains(AnsOptionCell.answerLbl.text ?? "cd"){
                    
                }else{
                    self.whoDidAnsArr.append(WhoDidArr[indexPath.row])
                }
            
            }else if quesFor == "everDidThingsArr"{
                surveyDict.updateValue(everDidThingsArr[indexPath.row], forKey: "que13")
                optionTableView.reloadData()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        if tableView == optionTableView{
            let cell = self.optionTableView.cellForRow(at: indexPath) as! SurveyTVCell
            if cell.RadioImg.image == UIImage(named: "radio_button_unselected"){
                if whoDidAnsArr.contains(cell.answerLbl.text ?? "nii"){
                    let Eleindex =  whoDidAnsArr.firstIndex(of: cell.answerLbl.text ?? "dcs")
                    whoDidAnsArr.remove(at: Eleindex ?? 0)
                }
            }
        }
    
    }
}
