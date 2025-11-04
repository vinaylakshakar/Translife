//
//  SurveyVC.swift
//  transLife
//
//  Created by Silstone Group on 17/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit

class NonMandatorySurvey1VC: UIViewController {
    
    let savingSurvey = Survey()
    @IBOutlet weak var MainBlurView: UIVisualEffectView!
    @IBOutlet weak var myTableView: UITableView!
    var surveyDict = [String:Any]()
    var ageString = ["Select age"]
    var age:String?
    let reasonArr = ["My spouse and/or kids might reject me","My parents might reject me","I might lose my job or not be able to get a job","I might face mistreatment at school","My friends might reject me","I might not get the medical care I need","I might be hurt financially","I might become homeless","My church or faith community might reject me","I might face violence","I am not ready to transition"]
    let currentGenderID = ["Cross-dresser","Woman","Man","Trans woman (MTF)","Trans man (FTM)","Non-binary/Genderqueer"]
    let currentlyLivingGender = ["Man","Woman","Neither man nor woman/Genderqueer/Non-binary","Part time one gender/part time another gender","People can tell I am trans even if I don’t tell them. (Always, Most of the time, Sometimes, Rarely, Never)" ]
    let currentsexualorientation = ["Asexual","Bisexual","Gay","Heterosexual/Straight","Lesbian","Same-gender loving","Pansexual","Queer","Other"]
    let currentrelationshipstatus = ["Partnered, living together","Partnered, not living together","Single","Not listed above (please specify)"]
    var confortLevelWithWordTransGender = ""
    var QuesFor = ""
    var ques22AnswerArr = [String]()
    
    @IBOutlet weak var SliderThumbLabel: UILabel!
    @IBOutlet weak var navTopSafeArea: NSLayoutConstraint!
    @IBOutlet weak var Ques1YesBtn: UIButton!
    @IBOutlet weak var Ques2YesBtn: UIButton!
    @IBOutlet weak var Ques1NoBtn: UIButton!
    @IBOutlet weak var Ques2NoBtn: UIButton!
    @IBOutlet weak var que11Btn: UIButton!
    @IBOutlet weak var que22Btn: UIButton!
    @IBOutlet weak var que4Btn: UIButton!
    @IBOutlet weak var que5Btn: UIButton!
    @IBOutlet weak var que6Btn: UIButton!
    @IBOutlet weak var que7Btn: UIButton!
    @IBOutlet weak var MyPicker: UIPickerView!
    @IBOutlet weak var agePickerBottom: NSLayoutConstraint!
    
    @IBOutlet weak var mainBlurtop: NSLayoutConstraint!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var mainBlurViewBottom: NSLayoutConstraint!
    @IBOutlet weak var ques11Height: NSLayoutConstraint!
    @IBOutlet weak var Ques22ViewHeight: NSLayoutConstraint!
    @IBOutlet weak var SliderForConfortLevel: UISlider!
    var Screenframeheight  = CGFloat()
     //MARK:LIFE CYCLES  OF VIEW
    override func viewDidLoad() {
        super.viewDidLoad()
        Screenframeheight  = self.view.frame.height
        agePickerBottom.constant = -250
        mainBlurtop.constant = Screenframeheight
        mainBlurViewBottom.constant = -Screenframeheight
        ques11Height.constant = 130
        Ques22ViewHeight.constant = 0
        for i in 18...100{
            let str = String(i)
            self.ageString.append("at age of \(str)")
            
        }
    }
    
    //MARK:ACTIONS
    
    
    @IBAction func BackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SubmitBtnAction(_ sender: Any) {
        if surveyDict.count < 7{
            PresentAlert(message: "please submit all answers", title: "TransLife")
        }else{
            surveyDict.updateValue(confortLevelWithWordTransGender, forKey: "que3")
            savingSurvey.saveSurveyWith(Dict: surveyDict, view: self, surveyName: "Current Trans Experience")
        }
      
    }
    
    //MARK:ConfortLevel TRACKER Slider
    @IBAction func ConfortLevelSliderDidMove(_ sender: UISlider) {
        let senderValue = sender.value
        if senderValue <= 0.5{
            confortLevelWithWordTransGender = "0"
            self.SliderThumbLabel.text = "0"
        }else if senderValue > 0.5 && senderValue <= 1.5{
            confortLevelWithWordTransGender = "1"
        }else if senderValue > 1.5 && senderValue <= 2.5{
            confortLevelWithWordTransGender = "2"
        }else if senderValue > 2.5 && senderValue <= 3.5{
            confortLevelWithWordTransGender = "3"
        }else if senderValue > 3.5 && senderValue <= 4.5{
            confortLevelWithWordTransGender = "4"
        }else if senderValue > 4.5 && senderValue <= 5.5{
            confortLevelWithWordTransGender = "5"
        }else if senderValue > 5.5{
            confortLevelWithWordTransGender = "6"
        }
       // sender.value = roundf(sender.value)
        
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
        self.SliderThumbLabel.center = CGPoint(x: thumbRect.midX, y: self.SliderThumbLabel.center.y)
      // SliderThumbLabel.text = String(Int(sender.value))
    }
    //MARK:ACTION FOR MAKING SLIDER STICKY
    @IBAction func ConfortLevelSliderTouchUpInside(_ sender: UISlider) {
        
        let senderValue = sender.value
        if senderValue <= 0.5{
            self.SliderForConfortLevel.setValue(0, animated: true)
        }else if senderValue > 0.5 && senderValue <= 1.5{
            self.SliderForConfortLevel.setValue(1, animated: true)
        }else if senderValue > 1.5 && senderValue <= 2.5{
            self.SliderForConfortLevel.setValue(2, animated: true)
        }else if senderValue > 2.5 && senderValue <= 3.5{
            self.SliderForConfortLevel.setValue(3, animated: true)
        }else if senderValue > 3.5 && senderValue <= 4.5{
            self.SliderForConfortLevel.setValue(4, animated: true)
        }else if senderValue > 4.5 && senderValue <= 5.5{
            self.SliderForConfortLevel.setValue(5, animated: true)
        }else if senderValue > 5.5{
            self.SliderForConfortLevel.setValue(6, animated: true)
        }
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
        self.SliderThumbLabel.center = CGPoint(x: thumbRect.midX, y: self.SliderThumbLabel.center.y)
       //  SliderThumbLabel.text = String(Int(sender.value))
    }
    
    @IBAction func tableViewDoneItem(_ sender: Any) {
        que22Btn.setTitle("you have choosen \(ques22AnswerArr.count) option", for: .normal)
        surveyDict.updateValue(ques22AnswerArr, forKey: "ques22")
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurViewBottom.constant = -self.Screenframeheight
            self.mainBlurtop.constant = self.Screenframeheight
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @IBAction func CancelBtnItemAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurViewBottom.constant = -self.Screenframeheight
            self.mainBlurtop.constant = self.Screenframeheight
            self.view.layoutIfNeeded()
        }, completion: nil) 
    }
    
    
    @IBAction func AgePickerDoneItem(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.agePickerBottom.constant = -250
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
     //MARK:ACTIONS FOR QUESTIONS
    @IBAction func Ques1YesAction(_ sender: Any) {
        Ques1YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques1NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.ques11Height.constant = 300
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("yes", forKey: "que1")
    }
    @IBAction func Ques1NoAction(_ sender: Any) {
        Ques1YesBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        Ques1NoBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.ques11Height.constant = 130
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("no", forKey: "que1")
    }
    @IBAction func SelectAnswerQues11Action(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.agePickerBottom.constant = 0
            self.view.endEditing(true)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func Ques2YesTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.Ques22ViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("yes", forKey: "que2")
    }
    @IBAction func Ques2NoTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.Ques22ViewHeight.constant = 150
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("no", forKey: "que2")
        
    }
    @IBAction func SelectAnswerQues22Action(_ sender: Any) {
        QuesFor = "reasonArr"
        self.myTableView.allowsMultipleSelection = true
        self.myTableView.allowsMultipleSelectionDuringEditing = true
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurtop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        myTableView.reloadData()
    }
    @IBAction func SelectAnswerQues4Action(_ sender: Any) {
        QuesFor = "currentGenderID"
        self.myTableView.allowsMultipleSelection = false
        self.myTableView.allowsMultipleSelectionDuringEditing = false
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurtop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        myTableView.reloadData()
    }
    @IBAction func SelectAnswerQues5Action(_ sender: Any) {
        QuesFor = "currentlyLivingGender"
        self.myTableView.allowsMultipleSelection = false
        self.myTableView.allowsMultipleSelectionDuringEditing = false
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurtop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        myTableView.reloadData()
    }
    @IBAction func SelectAnswerQues6Action(_ sender: Any) {
        QuesFor = "currentsexualorientation"
        self.myTableView.allowsMultipleSelection = false
        self.myTableView.allowsMultipleSelectionDuringEditing = false
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurtop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        myTableView.reloadData()
    }
    @IBAction func SelectAnswerQues7Action(_ sender: Any) {
        QuesFor = "currentrelationshipstatus"
        self.myTableView.allowsMultipleSelection = false
        self.myTableView.allowsMultipleSelectionDuringEditing = false
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurtop.constant = self.navTopSafeArea.constant
            self.mainBlurViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        myTableView.reloadData()
    }
    
}
extension NonMandatorySurvey1VC:UITableViewDataSource,UITableViewDelegate{
     //MARK:TABLEVIEW DATASORCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if QuesFor == "reasonArr"{
            return reasonArr.count
        }else if QuesFor == "currentGenderID"{
            return currentGenderID.count
        }else if QuesFor == "currentlyLivingGender"{
            return currentlyLivingGender.count
        }else if QuesFor == "currentsexualorientation"{
            return currentsexualorientation.count
        }else{
            return currentrelationshipstatus.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyTVCell", for: indexPath) as! SurveyTVCell
        cell.RadioImg.image = UIImage(named: "radio_button_unselected")
        if QuesFor == "reasonArr"{
            cell.answerLbl.text = reasonArr[indexPath.row]
            if ques22AnswerArr.contains(cell.answerLbl.text ?? "nii"){
                DispatchQueue.main.async(execute: {
                cell.RadioImg.image = UIImage(named: "radio_button_selected")
                })
            }
        }else if QuesFor == "currentGenderID"{
            cell.answerLbl.text = currentGenderID[indexPath.row]
    if let val = surveyDict["que4"]  {
                if val as? String == cell.answerLbl.text{
                                    DispatchQueue.main.async(execute: {
                                        cell.RadioImg.image = UIImage(named: "radio_button_selected")
                   })
                }
            }
        }else if QuesFor == "currentlyLivingGender"{
            cell.answerLbl.text = currentlyLivingGender[indexPath.row]
            if let val = surveyDict["que5"]  {
                if val as? String == cell.answerLbl.text{
                    DispatchQueue.main.async(execute: {
                        cell.RadioImg.image = UIImage(named: "radio_button_selected")
                    })
                }
            }
        }else if QuesFor == "currentsexualorientation"{
            cell.answerLbl.text = currentsexualorientation[indexPath.row]
            if let val = surveyDict["que6"]  {
                if val as? String == cell.answerLbl.text{
                    DispatchQueue.main.async(execute: {
                        cell.RadioImg.image = UIImage(named: "radio_button_selected")
                    })
                }
            }
        }else if QuesFor == "currentrelationshipstatus"{
            cell.answerLbl.text = currentrelationshipstatus[indexPath.row]
            if let val = surveyDict["que7"]  {
                if val as? String == cell.answerLbl.text{
                    DispatchQueue.main.async(execute: {
                        cell.RadioImg.image = UIImage(named: "radio_button_selected")
                    })
                }
            }
        }
        
        return cell
    }
    //MARK:TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.myTableView.cellForRow(at: indexPath) as! SurveyTVCell
       
        if QuesFor == "reasonArr"{
            if ques22AnswerArr.contains(cell.answerLbl.text ?? "cd"){
            }else{
                self.ques22AnswerArr.append(reasonArr[indexPath.row])
            }
        }else if QuesFor == "currentGenderID"{
            que4Btn.setTitle(currentGenderID[indexPath.row], for: .normal)
            surveyDict.updateValue(currentGenderID[indexPath.row], forKey: "que4")
            self.myTableView.reloadData()
        }else if QuesFor == "currentlyLivingGender"{
            que5Btn.setTitle(currentlyLivingGender[indexPath.row], for: .normal)
            surveyDict.updateValue(currentlyLivingGender[indexPath.row], forKey: "que5")
            self.myTableView.reloadData()
        }else if QuesFor == "currentsexualorientation"{
            que6Btn.setTitle(currentsexualorientation[indexPath.row], for: .normal)
            surveyDict.updateValue(currentsexualorientation[indexPath.row], forKey: "que6")
            self.myTableView.reloadData()
        }else if QuesFor == "currentrelationshipstatus"{
            que7Btn.setTitle(currentrelationshipstatus[indexPath.row], for: .normal)
            surveyDict.updateValue(currentrelationshipstatus[indexPath.row], forKey: "que7")
            self.myTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
        let cell = self.myTableView.cellForRow(at: indexPath) as! SurveyTVCell
        if cell.RadioImg.image == UIImage(named: "radio_button_unselected"){
            if ques22AnswerArr.contains(cell.answerLbl.text ?? "nii"){
                let Eleindex =  ques22AnswerArr.firstIndex(of: cell.answerLbl.text ?? "dcs")
                ques22AnswerArr.remove(at: Eleindex ?? 0)
            }
        }
    }
    
    
}
extension NonMandatorySurvey1VC : UIPickerViewDelegate,UIPickerViewDataSource{
    
    //MARK:PICKERVIEW DATASOURCE
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageString.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageString[row]
    }
    //MARK:PICKERVIEW DELEGATE
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        que11Btn.setTitle(ageString[row], for: .normal)
        surveyDict.updateValue(ageString[row], forKey: "que11")
        age = ageString[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let textColor = hexStringToUIColor(hex: "#003644")
        return NSAttributedString(string: ageString[row], attributes: [NSAttributedString.Key.foregroundColor:textColor, NSAttributedString.Key.font : UIFont.fontNames(forFamilyName: "MuseoSans_500")])
    }
    
}
