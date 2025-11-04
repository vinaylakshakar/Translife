//
//  NonMandotarySurvey2VC.swift
//  transLife
//
//  Created by Silstone Group on 18/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit


class NonMandatorySurvey2VC: UIViewController {

    let savingSurvey = Survey()
    var identityArr = ["Alaska Native","American Indian","Asian/Asian American","Biracial/Multiracial","Black/African American","Latino/a/Hispanic","Middle Eastern/North African","Native Hawaiian/Pacific Islander","White/European American"]
    var degreeArr = ["Less than 8th grade","8th grade","Some high school, no diploma or GED","GED","High school graduate","Some college, no degree (including currently in college)","Associate degree in college – Occupational/vocational program","Associate degree in college – Academic program Bachelor’s degree","Some graduate work, no graduate degree","Master’s degree (M.A, M.S., MBA)","Doctoral degree (e.g., Ph.D., Ed.D.)","Professional degree (e.g., MD, JD)"]
    var livingArrangementArr = ["Living in house/apartment/condo I OWN alone or with others (with a mortgage or that you own free and clear)","Living in house/apartment/condo I RENT alone or with others","Living with a partner, spouse, or other person who pays for the housing","Living temporarily with friends or family because I can’t afford my own housing","Living with parents or family I grew up with","Living in a foster group home or other foster care","Living in campus/university housing","Living in a nursing home or other adult care facility","Living in military barracks","Living in a hotel or motel","Living on the street, in a car, in a park, or a place that is NOT a house, apartment, shelter","Living in a homeless shelter","Living in a domestic violence shelter"]
    var employementArr = ["Work full-time for an employer (Do you have more than one job?)","Work part-time for an employer (Do you have more than one job?)","Self-employed in your own business, profession or trade, or operate a farm (not including sex work, selling drugs, or other work that is currently considered illegal)","Work for pay from sex work, selling drugs, or other work that is currently considered illegal","Unemployed but looking for work","Unemployed and have stopped looking for work","Not employed due to disability","Student"]
    var workingWithMentalHealthArr = ["Yes, I am (get referral)", "No, I am not (suggest)","Prefer not to say"]
    var Screenframeheight  = CGFloat()
    var QuesFor = ""
    var surveyDict = [String:Any]()
    var ques4AnswerArr = [String]()
    
    @IBOutlet weak var mainBlurTop: NSLayoutConstraint!
     @IBOutlet weak var navTopSafeArea: NSLayoutConstraint!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var mainBlurViewBottom: NSLayoutConstraint!
    @IBOutlet weak var MainBlurView: UIVisualEffectView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var que1SelectAnswerBtn: UIButton!
    @IBOutlet weak var que2SelectAnswerBtn: UIButton!
    @IBOutlet weak var que3SelectAnswerBtn: UIButton!
    @IBOutlet weak var que4SelectAnswerBtn: UIButton!
    @IBOutlet weak var que5SelectAnswerBtn: UIButton!
    var index = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Screenframeheight  = self.view.frame.height
        mainBlurTop.constant = Screenframeheight
        mainBlurViewBottom.constant = -Screenframeheight
    }
    
    
    @IBAction func BackBtnAct(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tableViewDoneItem(_ sender: Any) {
        que4SelectAnswerBtn.setTitle("you have choosen \(ques4AnswerArr.count) option", for: .normal)
        surveyDict.updateValue(ques4AnswerArr, forKey: "ques4")
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurViewBottom.constant = -self.Screenframeheight
            self.mainBlurTop.constant = self.Screenframeheight
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    @IBAction func CancelBtnItemAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurViewBottom.constant = -self.Screenframeheight
            self.mainBlurTop.constant = self.Screenframeheight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func Ques1SelectAnswerAction(_ sender: Any) {
        QuesFor = "identityArr"
        self.myTableView.allowsMultipleSelection = false
        self.myTableView.allowsMultipleSelectionDuringEditing = false
        myTableView.reloadData()
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurTop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func Ques2SelectAnswerAction(_ sender: Any) {
        QuesFor = "degreeArr"
        self.myTableView.allowsMultipleSelection = false
        self.myTableView.allowsMultipleSelectionDuringEditing = false
        myTableView.reloadData()
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurTop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func Ques3SelectAnswerAction(_ sender: Any) {
        QuesFor = "livingArrangementArr"
        self.myTableView.allowsMultipleSelection = false
        self.myTableView.allowsMultipleSelectionDuringEditing = false
        myTableView.reloadData()
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurTop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func Ques4SelectAnswerAction(_ sender: Any) {
        QuesFor = "employementArr"
        self.myTableView.allowsMultipleSelection = true
        self.myTableView.allowsMultipleSelectionDuringEditing = true
        myTableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        myTableView.reloadRows(at:[indexPath], with: .automatic)
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurTop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func Ques5SelectAnswerAction(_ sender: Any) {
        QuesFor = "workingWithMentalHealthArr"
        self.myTableView.allowsMultipleSelection = false
        self.myTableView.allowsMultipleSelectionDuringEditing = false
        myTableView.reloadData()
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurTop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func SubmitBtnAction(_ sender: Any) {
        if surveyDict.count < 5{
             PresentAlert(message: "please submit all answers", title: "TransLife")
        }else{
            savingSurvey.saveSurveyWith(Dict: surveyDict, view: self, surveyName: "Demographics")
        }
      
    }
    


}
extension NonMandatorySurvey2VC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if QuesFor == "identityArr"{
            return identityArr.count
        }else if QuesFor == "degreeArr"{
            return degreeArr.count
        }else if QuesFor == "livingArrangementArr"{
            return livingArrangementArr.count
        }else if QuesFor == "employementArr"{
            return employementArr.count
        }else{
            return workingWithMentalHealthArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyTVCell", for: indexPath) as! SurveyTVCell
        if QuesFor == "identityArr"{
            cell.answerLbl.text = identityArr[indexPath.row]
            if let val = surveyDict["que1"]  {
                if val as? String == cell.answerLbl.text{
                    DispatchQueue.main.async(execute: {
                        cell.RadioImg.image = UIImage(named: "radio_button_selected")
                    })
                }
            }
        }else if QuesFor == "degreeArr"{
            cell.answerLbl.text = degreeArr[indexPath.row]
            if let val = surveyDict["que2"]  {
                if val as? String == cell.answerLbl.text{
                    DispatchQueue.main.async(execute: {
                        cell.RadioImg.image = UIImage(named: "radio_button_selected")
                    })
                }
            }
        }else if QuesFor == "livingArrangementArr"{
            cell.answerLbl.text = livingArrangementArr[indexPath.row]
            if let val = surveyDict["que3"]  {
                if val as? String == cell.answerLbl.text{
                    DispatchQueue.main.async(execute: {
                        cell.RadioImg.image = UIImage(named: "radio_button_selected")
                    })
                }
            }
        }else if QuesFor == "employementArr"{
             cell.answerLbl.text = employementArr[indexPath.row]
            if ques4AnswerArr.contains(cell.answerLbl.text ?? "rew"){
                DispatchQueue.main.async(execute: {
                    cell.RadioImg.image = UIImage(named: "radio_button_selected")
                    
                })
                
            }
        }else if QuesFor == "workingWithMentalHealthArr"{
            cell.answerLbl.text = workingWithMentalHealthArr[indexPath.row]
            if let val = surveyDict["que5"]  {
                if val as? String == cell.answerLbl.text{
                    DispatchQueue.main.async(execute: {
                        cell.RadioImg.image = UIImage(named: "radio_button_selected")
                    })
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.myTableView.cellForRow(at: indexPath) as! SurveyTVCell
        if QuesFor == "identityArr"{
            que1SelectAnswerBtn.setTitle(identityArr[indexPath.row], for: .normal)
            surveyDict.updateValue(identityArr[indexPath.row], forKey: "que1")
            self.myTableView.reloadData()
        }else if QuesFor == "degreeArr"{
            que2SelectAnswerBtn.setTitle(degreeArr[indexPath.row], for: .normal)
            surveyDict.updateValue(degreeArr[indexPath.row], forKey: "que2")
            self.myTableView.reloadData()
        }else if QuesFor == "livingArrangementArr"{
            que3SelectAnswerBtn.setTitle(livingArrangementArr[indexPath.row], for: .normal)
            surveyDict.updateValue(livingArrangementArr[indexPath.row], forKey: "que3")
            self.myTableView.reloadData()
        }else if QuesFor == "employementArr"{
            if ques4AnswerArr.contains(cell.answerLbl.text ?? "cd"){
      
            }else{
                self.ques4AnswerArr.append(employementArr[indexPath.row])
            }
            
        }else if QuesFor == "workingWithMentalHealthArr"{
            que5SelectAnswerBtn.setTitle(workingWithMentalHealthArr[indexPath.row], for: .normal)
            surveyDict.updateValue(workingWithMentalHealthArr[indexPath.row], forKey: "que5")
            self.myTableView.reloadData()
        }
        print(surveyDict)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         let cell = self.myTableView.cellForRow(at: indexPath) as! SurveyTVCell
            if cell.RadioImg.image == UIImage(named: "radio_button_unselected"){
                if ques4AnswerArr.contains(cell.answerLbl.text ?? "ce"){
                    let Eleindex =  ques4AnswerArr.firstIndex(of: cell.answerLbl.text ?? "dcs")
                    ques4AnswerArr.remove(at: Eleindex ?? 0)
                }
            }
      
        print(ques4AnswerArr)
    }
    
    
}
