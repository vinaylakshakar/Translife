//
//  QuestionDayAnswerVC.swift
//  transLife
//
//  Created by Developer Silstone on 19/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuestionDayAnswerVC: UIViewController {
    
    var options = [String]()
    let answers = QuestionOfTheDay()
    var ansArr = [Int]()
    var ans1Arr = [Int]()
    var ans2Arr = [Int]()
    var ans3Arr = [Int]()
    var ans4Arr = [Int]()
    var ans = ""
    @IBOutlet weak var userAnswerForToday: UILabel!
    @IBOutlet weak var totalAnswerForOptionA: UILabel!
    @IBOutlet weak var totalAnswerForOptionB: UILabel!
    @IBOutlet weak var totalAnswerForOptionC: UILabel!
    @IBOutlet weak var totalAnswerForOptionD: UILabel!
    @IBOutlet weak var view1Height: NSLayoutConstraint!
    @IBOutlet weak var view2Height: NSLayoutConstraint!
    @IBOutlet weak var view3Height: NSLayoutConstraint!
    @IBOutlet weak var view4Height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        if ans == ""{
//            PresentAlert(message: "you can't see community answers until you give your answer", title: "transLife")
//        }
        if isAnsweredQOTD == false{
            setUpUI()
        }else{
            getAllAnswer()
        }
        
    }
    func getAllAnswer()  {
        SVProgressHUD.show()
        answers.GetAllAnswersOfCommunity(view: self) { (snap) in
            self.ansArr.removeAll()
            self.ans2Arr.removeAll()
            self.ans3Arr.removeAll()
            self.ans4Arr.removeAll()
            self.ans1Arr.removeAll()
            if snap.value is NSNull{
                
            }else{
                let snapValue = snap.value as! [String:AnyObject]
                if let currentuser = UserDefaults.standard.value(forKey: "username") as? String{
                    for i in snapValue{
                        
                        let val = i.value
                        if currentuser == i.key{
                            self.ans = UserDefaults.standard.value(forKey: "userAnswer") as! String
                        
                        }
                        let allans = val.value(forKey: quesID)
                        if allans != nil{
                            let Str = Int((allans as! NSString).floatValue)
                            self.ansArr.append(Str)
                        }else{
                            
                        }
                        
                    }
                    for i in self.ansArr{
                        if i == 0{
                            self.ans1Arr.append(i)
                        }else if i == 1{
                            self.ans2Arr.append(i)
                        }else if i == 2{
                            self.ans3Arr.append(i)
                        }else if i == 3{
                            self.ans4Arr.append(i)
                        }
                    }
                }
            }
            self.setUpUI()
            SVProgressHUD.dismiss()
        }
    }
    func setUpUI() {
        userAnswerForToday.text = ans
        totalAnswerForOptionA.text = String(ans1Arr.count)
        totalAnswerForOptionB.text = String(ans2Arr.count)
        totalAnswerForOptionC.text = String(ans3Arr.count)
        totalAnswerForOptionD.text = String(ans4Arr.count)
        if ansArr.count != 0{
            let UnitHeight = 190/ansArr.count
            UIView.animate(withDuration: 0.4) {
                self.view1Height.constant = CGFloat(UnitHeight * self.ans1Arr.count)
                self.view2Height.constant = CGFloat(UnitHeight * self.ans2Arr.count)
                self.view3Height.constant = CGFloat(UnitHeight * self.ans3Arr.count)
                self.view4Height.constant = CGFloat(UnitHeight * self.ans4Arr.count)
                self.view.layoutIfNeeded()
            }
        }
    }
    // MARK: - ACTIONS
    @IBAction func BackBtnAct(_ sender: Any) {
        self.ansArr.removeAll()
        self.ans2Arr.removeAll()
        self.ans3Arr.removeAll()
        self.ans4Arr.removeAll()
        self.ans1Arr.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DoneBtnAct(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        self.ansArr.removeAll()
        self.ans2Arr.removeAll()
        self.ans3Arr.removeAll()
        self.ans4Arr.removeAll()
        self.ans1Arr.removeAll()
        UserDefaults.standard.setValue(true, forKey: "qotd_answered")
        UserDefaults.standard.synchronize()
    }
    
    
}
