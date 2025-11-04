//
//  NonMandotarySurvey3VC.swift
//  transLife
//
//  Created by Silstone Group on 18/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit

class NMSurvey3ViewController: UIViewController {
    
    let savingSurvey = Survey()
    @IBOutlet weak var MainBlurView: UIVisualEffectView!
    @IBOutlet weak var myTableView: UITableView!
    var surveyDict = [String:Any]()
  
    let reasonArr = ["My spouse and/or kids might reject me","My parents might reject me","I might lose my job or not be able to get a job","I might face mistreatment at school","My friends might reject me","I might not get the medical care I need","I might be hurt financially","I might become homeless","My church or faith community might reject me","I might face violence","I am not ready to transition"]
    let currentGenderID = ["Cross-dresser","Woman","Man","Trans woman (MTF)","Trans man (FTM)","Non-binary/Genderqueer"]
    let currentlyLivingGender = ["Man","Woman","Neither man nor woman/Genderqueer/Non-binary","Part time one gender/part time another gender","People can tell I am trans even if I don’t tell them. (Always, Most of the time, Sometimes, Rarely, Never)" ]
    let currentsexualorientation = ["Asexual","Bisexual","Gay","Heterosexual/Straight","Lesbian","Same-gender loving","Pansexual","Queer","Other"]
    let currentrelationshipstatus = ["Partnered, living together","Partnered, not living together","Single","Not listed above (please specify)"]
    var QuesFor = ""
    var ques22AnswerArr = [String]()
    @IBOutlet weak var navTopSafeArea: NSLayoutConstraint!
    @IBOutlet weak var Ques1YesBtn: UIButton!
    @IBOutlet weak var Ques2YesBtn: UIButton!
    @IBOutlet weak var Ques1NoBtn: UIButton!
    @IBOutlet weak var Ques2NoBtn: UIButton!
    //question no 1.1
    @IBOutlet weak var Ques11selectBtn: UIButton!
    @IBOutlet weak var Ques3YesBtn: UIButton!
    @IBOutlet weak var Ques3NoBtn: UIButton!
    @IBOutlet weak var Ques4YesBtn: UIButton!
    @IBOutlet weak var Ques4NoBtn: UIButton!
    @IBOutlet weak var Ques5selectBtn: UIButton!
    @IBOutlet weak var Ques6selectBtn: UIButton!
    @IBOutlet weak var Ques7YesBtn: UIButton!
    @IBOutlet weak var Ques7NoBtn: UIButton!
    @IBOutlet weak var Ques8YesBtn: UIButton!
    @IBOutlet weak var Ques8NoBtn: UIButton!
    @IBOutlet weak var Ques9YesBtn: UIButton!
    @IBOutlet weak var Ques9NoBtn: UIButton!
    @IBOutlet weak var Ques91YesBtn: UIButton!
    @IBOutlet weak var Ques91NoBtn: UIButton!
    @IBOutlet weak var Ques10selectBtn: UIButton!
    //question no 11
    @IBOutlet weak var QuesNo101selectBtn: UIButton!
 
    
    @IBOutlet weak var mainBlurtop: NSLayoutConstraint!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var mainBlurViewBottom: NSLayoutConstraint!
    @IBOutlet weak var ques11Height: NSLayoutConstraint!
    @IBOutlet weak var Ques91ViewHeight: NSLayoutConstraint!
  
    var Screenframeheight  = CGFloat()
    //MARK:LIFE CYCLES  OF VIEW
    override func viewDidLoad() {
        super.viewDidLoad()
        Screenframeheight  = self.view.frame.height
        mainBlurtop.constant = Screenframeheight
        mainBlurViewBottom.constant = -Screenframeheight
        ques11Height.constant = 130
    }
    
    //MARK:ACTIONS
    
    
    @IBAction func SkipBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SubmitBtnAction(_ sender: Any) {
        surveyDict.updateValue("confortLevelWithWordTransGender", forKey: "que3")
        savingSurvey.saveSurveyWith(Dict: surveyDict, view: self, surveyName: "Current Trans Experience")
    }
    
    
    @IBAction func tableViewDoneItem(_ sender: Any) {
        Ques11selectBtn.setTitle("you have choosen \(ques22AnswerArr.count) option", for: .normal)
        surveyDict.updateValue(ques22AnswerArr, forKey: "ques22")
        UIView.animate(withDuration: 0.4, animations: {
            self.mainBlurViewBottom.constant = -self.Screenframeheight
            self.mainBlurtop.constant = self.Screenframeheight
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
  
    
    //MARK:ACTIONS FOR QUESTIONS
    @IBAction func Ques1YesAction(_ sender: Any) {
        Ques1YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques1NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.ques11Height.constant = 250
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
            self.view.endEditing(true)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func Ques2YesTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("yes", forKey: "que2")
    }
    @IBAction func Ques2NoTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("no", forKey: "que2")
        
    }
    @IBAction func Ques3YesTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("yes", forKey: "que2")
    }
    @IBAction func Ques3NoTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("no", forKey: "que2")
        
    }
    @IBAction func Ques4YesTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("yes", forKey: "que2")
    }
    @IBAction func Ques4NoTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("no", forKey: "que2")
        
    }
    @IBAction func SelectAnswerQues5Action(_ sender: Any) {
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
    @IBAction func SelectAnswerQues6Action(_ sender: Any) {
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
    @IBAction func Ques7YesTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("yes", forKey: "que2")
    }
    @IBAction func Ques7NoTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("no", forKey: "que2")
        
    }
    @IBAction func Ques8YesTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("yes", forKey: "que2")
    }
    @IBAction func Ques8NoTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("no", forKey: "que2")
        
    }
    @IBAction func Ques9YesTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("yes", forKey: "que2")
    }
    @IBAction func Ques9NoTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("no", forKey: "que2")
        
    }
    @IBAction func Ques91YesTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("yes", forKey: "que2")
    }
    @IBAction func Ques91NoTappedAction(_ sender: Any) {
        Ques2YesBtn.setBackgroundImage(#imageLiteral(resourceName: "slider_knob"), for: .normal)
        Ques2NoBtn.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected_blue"), for: .normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        surveyDict.updateValue("no", forKey: "que2")
        
    }
    @IBAction func SelectAnswerQues10Action(_ sender: Any) {
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
    @IBAction func SelectAnswerQues101Action(_ sender: Any) {
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
 
    
}
