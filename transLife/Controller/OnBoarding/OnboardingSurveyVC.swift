//
//  OnboardingSurveyVC.swift
//  transLife
//
//  Created by Developer Silstone on 03/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class OnboardingSurveyVC: UIViewController {
    
    var username = ""
    var pushedFromSurvey = false
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var q3heightConst: NSLayoutConstraint!
    @IBOutlet weak var q31heightConst: NSLayoutConstraint!
    @IBOutlet weak var q32heightConst: NSLayoutConstraint!
    @IBOutlet weak var q33heightConst: NSLayoutConstraint!
    @IBOutlet weak var q4heightConst: NSLayoutConstraint!
    @IBOutlet weak var MainViewheightConst: NSLayoutConstraint!
    @IBOutlet weak var que11NotAtAll: UIButton!
    @IBOutlet weak var que11severalDays: UIButton!
    @IBOutlet weak var que11moreThanOneDays: UIButton!
    @IBOutlet weak var que11everyDays: UIButton!
    @IBOutlet weak var que12NotAtAll: UIButton!
    @IBOutlet weak var que12severalDays: UIButton!
    @IBOutlet weak var que12moreThanOneDays: UIButton!
    @IBOutlet weak var que12everyDays: UIButton!
    @IBOutlet weak var que2yes: UIButton!
    @IBOutlet weak var que2no: UIButton!
    @IBOutlet weak var que3yes: UIButton!
    @IBOutlet weak var que3no: UIButton!
    @IBOutlet weak var que31yes: UIButton!
    @IBOutlet weak var que31no: UIButton!
    @IBOutlet weak var que32yes: UIButton!
    @IBOutlet weak var que32no: UIButton!
    @IBOutlet weak var que33yes: UIButton!
    @IBOutlet weak var que33no: UIButton!
    @IBOutlet weak var que4yes: UIButton!
    @IBOutlet weak var que4no: UIButton!
    @IBOutlet weak var que41overYearAgo: UIButton!
    @IBOutlet weak var que41BetweenThreeMonths: UIButton!
    
    @IBOutlet weak var que41WithinThreemonths: UIButton!
    var userSurvey = OnBoarding()
    var dict = [String:Any]()
    var mainViewHeight = 1536
    var que3ViewHeight = 340
    var que4Viewheight = 150
    // MARK: - LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        q3heightConst.constant = 0
        q31heightConst.constant = 0
        q32heightConst.constant = 0
        q33heightConst.constant = 0
        q4heightConst.constant = 0
        MainViewheightConst.constant = CGFloat(mainViewHeight - que3ViewHeight - que4Viewheight)
        


    }
    override func viewWillAppear(_ animated: Bool) {
        if pushedFromSurvey == true{
            skipBtn.isHidden = true
            BackBtn.isHidden = false
        }else{
            skipBtn.isHidden = false
            BackBtn.isHidden = true
        }
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
            self.username = username
        }
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    // MARK: - ACTIONS
    
    @IBAction func Que11notAtAll(_ sender: Any) {
        que11NotAtAll.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que11everyDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que11severalDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que11moreThanOneDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("not at all", forKey: "que11")
    }
    @IBAction func Que11severalDays(_ sender: Any) {
        que11NotAtAll.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que11everyDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que11severalDays.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que11moreThanOneDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("several days", forKey: "que11")
    }
    @IBAction func Que11moreThanOneDays(_ sender: Any) {
        que11NotAtAll.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que11everyDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que11severalDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que11moreThanOneDays.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        dict.updateValue("more than one-half of the days", forKey: "que11")
    }
    @IBAction func Que11everyDays(_ sender: Any) {
        que11NotAtAll.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que11everyDays.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que11severalDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que11moreThanOneDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("nearly every day", forKey: "que11")
    }
    @IBAction func Que12notAtAll(_ sender: Any) {
        que12NotAtAll.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que12everyDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que12severalDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que12moreThanOneDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("not at all", forKey: "que12")
    }
    @IBAction func Que12severalDays(_ sender: Any) {
        que12NotAtAll.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que12everyDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que12severalDays.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que12moreThanOneDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("several days", forKey: "que12")
    }
    @IBAction func Que12moreThanOneDays(_ sender: Any) {
        que12NotAtAll.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que12everyDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que12severalDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que12moreThanOneDays.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        dict.updateValue("more than one-half of the days", forKey: "que12")
    }
    @IBAction func Que12everyDays(_ sender: Any) {
        que12NotAtAll.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que12everyDays.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que12severalDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que12moreThanOneDays.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("nearly every day", forKey: "que12")
    }
    @IBAction func que2yesTap(_ sender: Any) {
        que2yes.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que2no.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("yes", forKey: "que2")
    }
    @IBAction func que2noTap(_ sender: Any) {
        que2no.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que2yes.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("no", forKey: "que2")
    }
    
    @IBAction func que3yesTap(_ sender: Any) {
        que3yes.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que3no.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.q3heightConst.constant = 340
            self.q31heightConst.constant = 100
            self.q32heightConst.constant = 90
            self.q33heightConst.constant = 130
          //  self.MainViewheightConst.constant += self.dict["que3"] as? String == "yes" ? 340 : 0
            if self.MainViewheightConst.constant <= 1386 {
                self.MainViewheightConst.constant = 1536
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
         dict.updateValue("yes", forKey: "que3")
        
    }
    @IBAction func que3noTap(_ sender: Any) {
       
        que3no.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que3yes.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
           // self.MainViewheightConst.constant -= self.dict["que3"] as? String == "yes" ? 340 : 0
            if self.MainViewheightConst.constant >= 1536 {
                self.MainViewheightConst.constant = 1386
            }
            self.q3heightConst.constant = 0
            self.q31heightConst.constant = 0
            self.q32heightConst.constant = 0
            self.q33heightConst.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        dict.updateValue("no", forKey: "que3")
        dict.removeValue(forKey: "que31")
        dict.removeValue(forKey: "que32")
        dict.removeValue(forKey: "que33")
        que31yes.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que31no.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que32yes.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que32no.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que33yes.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que33no.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
    }
    
    @IBAction func que31yesTap(_ sender: Any) {
        que31yes.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que31no.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("yes", forKey: "que31")
    }
    @IBAction func que31noTap(_ sender: Any) {
        que31no.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que31yes.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("no", forKey: "que31")
    }
    @IBAction func que32yesTap(_ sender: Any) {
        que32yes.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que32no.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("yes", forKey: "que32")
    }
    @IBAction func que32noTap(_ sender: Any) {
        que32no.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que32yes.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("no", forKey: "que32")
        
    }
    @IBAction func que33yesTap(_ sender: Any) {
        que33yes.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que33no.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("yes", forKey: "que33")
    }
    @IBAction func que33noTap(_ sender: Any) {
        que33no.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que33yes.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("no", forKey: "que33")
    }
    @IBAction func que4yesTap(_ sender: Any) {
        que4yes.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que4no.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            if self.MainViewheightConst.constant <= 1386 {
                self.MainViewheightConst.constant = 1536
            }
            self.q4heightConst.constant = 190
            self.view.layoutIfNeeded()
        }, completion: nil)
        dict.updateValue("yes", forKey: "que4")
    }
    @IBAction func que4noTap(_ sender: Any) {
        que4no.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que4yes.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            if self.MainViewheightConst.constant >= 1536 {
                self.MainViewheightConst.constant = 1386
            }
            self.q4heightConst.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        dict.updateValue("no", forKey: "que4")
        dict.removeValue(forKey: "que41")
        que41BetweenThreeMonths.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que41overYearAgo.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que41WithinThreemonths.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
    }
    @IBAction func que41overYearAgo(_ sender: Any) {
        que41BetweenThreeMonths.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que41overYearAgo.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que41WithinThreemonths.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("Over a year ago", forKey: "que41")
    }
    @IBAction func que41BetweenThreeMonths(_ sender: Any) {
        que41BetweenThreeMonths.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        que41overYearAgo.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que41WithinThreemonths.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        dict.updateValue("Between three months and a year ago", forKey: "que41")
    }
    
    @IBAction func que41WithInLastThree(_ sender: Any) {
        que41BetweenThreeMonths.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que41overYearAgo.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        que41WithinThreemonths.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        dict.updateValue("Within the last three months", forKey: "que41")
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SkipBtnTapped(_ sender: Any) {
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let Dict = ["currentTimeStamp":currentTimestamp,"status":false] as [String : Any]
        if let user = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("userSurveyDetail").child(user).child("Baseline survey").updateChildValues(Dict, withCompletionBlock: { (error, dataRef) in
                if let error = error{
                    self.PresentAlert(message: error.localizedDescription, title: "TransLife")
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = loginView
                }
            })
        }
      
    }
    
    // MARK: Handle Questionnaire
    @IBAction func SubmitAction(_ sender: Any) {
        
        let que11 = dict["que11"] as? String != nil ? dict["que11"] as! String : ""
        let que12 = dict["que12"] as? String != nil ? dict["que12"] as! String : ""
        let que2 = dict["que2"] as? String != nil ? dict["que2"] as! String : ""
        let que3 = dict["que3"] as? String != nil ? dict["que3"] as! String : ""
        let que31 = dict["que31"] as? String != nil ? dict["que31"] as! String : ""
        let que32 = dict["que32"] as? String != nil ? dict["que32"] as! String : ""
        let que33 = dict["que33"] as? String != nil ? dict["que33"] as! String : ""
        let que4 = dict["que4"] as? String != nil ? dict["que4"] as! String : ""
        let que41 = dict["que41"] as? String != nil ? dict["que41"] as! String : ""
        
        if que11 == "" || que12 == "" || que2 == "" || que3 == "" || que4 == ""{
            PresentAlert(message: "please submit all answers.", title: "TransLife")
        }else{
            if let user = UserDefaults.standard.value(forKey: "username") as? String{
                if que3 == "yes"{
                    if   que31 == "" || que32 == "" || que33 == "" {PresentAlert(message: "please submit all answers.", title: "TransLife")}
                    else { if que4 == "yes"{
                        if que41 == ""{
                            PresentAlert(message: "please submit all answers.", title: "TransLife")
                        }else{
                            if  que3 == "yes" || que4 == "yes"{
                                ref.child("users").child(user).updateChildValues(["flag":true])
                            }else if que3 == "no" && que4 == "no"{
                                ref.child("users").child(user).updateChildValues(["flag":false])
                            }
                            userSurvey.createNewBaselineSurvey(Dict: dict, view: self)
                        }
                    }else{
                        if  que3 == "yes" || que4 == "yes"{
                            ref.child("users").child(user).updateChildValues(["flag":true])
                        }else if que3 == "no" && que4 == "no"{
                            ref.child("users").child(user).updateChildValues(["flag":false])
                        }
                        userSurvey.createNewBaselineSurvey(Dict: dict, view: self)
                        }
                    }
                }else{
                    if que4 == "yes"{
                        if que41 == ""{
                            PresentAlert(message: "please submit all answers.", title: "TransLife")
                        }else{
                            if  que3 == "yes" || que4 == "yes"{
                                ref.child("users").child(user).updateChildValues(["flag":true])
                            }else if que3 == "no" && que4 == "no"{
                                ref.child("users").child(user).updateChildValues(["flag":false])
                            }
                            userSurvey.createNewBaselineSurvey(Dict: dict, view: self)
                        }
                    }else{
                        if  que3 == "yes" || que4 == "yes"{
                            ref.child("users").child(user).updateChildValues(["flag":true])
                        }else if que3 == "no" && que4 == "no"{
                            ref.child("users").child(user).updateChildValues(["flag":false])
                        }
                        userSurvey.createNewBaselineSurvey(Dict: dict, view: self)
                        
                    }
                }
            }
         
        }
    }
}







