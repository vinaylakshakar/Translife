//
//  QuestionDayQuesVC.swift
//  transLife
//
//  Created by Developer Silstone on 19/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuestionDayQuesVC: UIViewController {

    @IBOutlet weak var QuestionText: UILabel!
    var options = [String]()
    var ansArr = [Int]()
    var ans1Arr = [Int]()
    var ans2Arr = [Int]()
    var ans3Arr = [Int]()
    var ans4Arr = [Int]()
    let question = QuestionOfTheDay()
    var todayQues = [String:Any]()
    var ans = ""
    var quesID = String()
    @IBOutlet weak var tableVIEW: UITableView!
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
       
//        self.tableVIEW.register(UINib(nibName: "ObjectiveTypeQueTVCell", bundle: nil), forCellReuseIdentifier: "ObjectiveTypeQueTVCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      setupQue()
        self.tableVIEW.allowsMultipleSelection = false
        self.tableVIEW.allowsMultipleSelectionDuringEditing = false
        
    }
    //MARK:SETUP QUES UI
    func setupQue() {
        if todayQues.count != 0{
            let selectionType = todayQues["AnswersSelection"] as! String
            let quesType = todayQues["questionType"] as! String
            let ques = todayQues["question"] as! String
            QuestionText.text = ques
            if selectionType == "single"{
                self.tableVIEW.allowsMultipleSelection = false
                self.tableVIEW.allowsMultipleSelectionDuringEditing = false
            }else if selectionType == "multiple"{
                self.tableVIEW.allowsMultipleSelection = true
                self.tableVIEW.allowsMultipleSelectionDuringEditing = true
            }
            self.tableVIEW.reloadData()
            SVProgressHUD.dismiss()
        }else{
            PresentAlert(message: "Question has't been uploaded today.", title: "TransLife")
             SVProgressHUD.dismiss()
        }
     
    }

    

    // MARK:- ACTIONS

    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func SubmitBtnAct(_ sender: Any) {
        if ans == ""{
            PresentAlert(message: "you can't see community answers until you give your answer", title: "TransLife")
        }else{
        let vc = storyboard?.instantiateViewController(withIdentifier: "QuestionDayAnswerVC") as! QuestionDayAnswerVC
        vc.ans1Arr = ans1Arr
        vc.ans2Arr = ans2Arr
        vc.ans3Arr = ans3Arr
        vc.ans4Arr = ans4Arr
        vc.ansArr = ansArr
        vc.ans = ans
       self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}
extension QuestionDayQuesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if options.count == 0{
            return 0
        }else if options.count > 4{
            return 4
        }else{
            return options.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QOTDTVCell", for: indexPath) as! QOTDTVCell
        if indexPath.row == 0{
            cell.OptionTextLbl.text = "A. \(options[indexPath.row])"
        }else if indexPath.row == 1{
            cell.OptionTextLbl.text = "B. \(options[indexPath.row])"
        }else if indexPath.row == 2{
            cell.OptionTextLbl.text = "C. \(options[indexPath.row])"
        }else if indexPath.row == 3{
            cell.OptionTextLbl.text = "D. \(options[indexPath.row])"
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
        let answerIndex = String(indexPath.row)
        if indexPath.row == 0 {
            ans = "A.\(options[indexPath.row])"
        }else if indexPath.row == 1{
            ans = "B.\(options[indexPath.row])"
        }else if indexPath.row == 2{
            ans = "C.\(options[indexPath.row])"
        }else if indexPath.row == 3{
            ans = "D.\(options[indexPath.row])"
        }
        UserDefaults.standard.set( ans, forKey: "userAnswer")
        UserDefaults.standard.synchronize()
        question.userAnswerForDailyQues(dict: [quesID : answerIndex as AnyObject ], view: self) { (dataRef) in
            self.getAllAnswer()
        }
        
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:
//            tableView.bounds.size.width, height: 40))
//        headerLabel.text = "vfekdskdqwlfigohswqvfudhiosaljmsnbivcegowphqjsweosngfidowhjodug"//todayQues["question"] as? String
//        headerLabel.font = UIFont(name:"SegoeUI-Semibold", size: 18)
//        headerLabel.numberOfLines = 0
//        headerLabel.textColor = hexStringToUIColor(hex:"#003644")
//        headerLabel.sizeToFit()
//        headerLabel.contentMode = .center
//        headerView.addSubview(headerLabel)
//
//        return headerView
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    func getAllAnswer()  {
        SVProgressHUD.show()
        question.GetAllAnswersOfCommunity(view: self) { (snap) in
            self.ansArr.removeAll()
            self.ans2Arr.removeAll()
            self.ans3Arr.removeAll()
            self.ans4Arr.removeAll()
            self.ans1Arr.removeAll()
            if snap.value is NSNull{
                
            }else{
            let snapValue = snap.value as! [String:AnyObject]
 
            for i in snapValue{
                    let val = i.value
                let ans = val.value(forKey: self.quesID)
                if ans != nil{
                    let Str = Int((ans as! NSString).floatValue)
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
            SVProgressHUD.dismiss()
        }
     }
    
}
