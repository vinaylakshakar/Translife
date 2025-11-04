//
//  NonMandotarySurvey5VC.swift
//  transLife
//
//  Created by Silstone Group on 24/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit

class NonMandatorySurvey5VC: UIViewController,LikertCellDelegate {
  
    let savingSurvey = Survey()
    let quesArr = ["Ques 1.Below is a list of statements dealing with your general feelings about yourself. Please indicate how strongly you agree or disagree with each statement. ","On the whole, I am satisfied with myself.","At times I think I am no good at all.","I feel that I have a number of good qualities. ","I am able to do things as well as most other people. ","I feel I do not have much to be proud of.","I certainly feel useless at times. ","I feel that I'm a person of worth, at least on an equal plane with others. ","I wish I could have more respect for myself. ","All in all, I am inclined to feel that I am a failure ","I take a positive attitude toward myself. ","Ques 2.Are you currently taking hormones for your gender identity or gender transition? ","Ques 3.Where do you currently get your hormones?","Ques 4.Have you had or do you want any of the health care listed below for gender transition ?                      ","#1.Top/chest surgery reduction or reconstruction ","#2.Hysterectomy/“hysto” (removal of the uterus, ovaries, fallopian tubes, and/or cervix) ","#3.Clitoral release/metoidioplasty/ centurion procedure ","#4.Phalloplasty (creation of a penis) ","#5.Other procedure not listed: ","Ques 5.Have you had or do you want any of the health care listed below for gender transition? ","#1.Hair removal/electrolysis","#2.Breast augmentation / top surgery","#3.Silicone injections","#4.Orchidectomy / “orchy” / removal of testes","#5.Vaginoplasty/labiaplasty/SRS/GRS/GCS","#6.Trachea shave (Adam’s apple or thyroid cartilage reduction)","#7.Facial feminization surgery (such as nose, brow, chin, cheek)","#8.Voice therapy (non-surgical)","#9.Voice surgery","#10.Other procedure not listed:","Ques 6.How do you socialize with other trans people? (Mark all that apply.)"]
    var harmonesArr = ["I only go to licensed professionals (like a doctor) for hormones.","In addition to licensed professionals, I also get hormones from friends, online, or other non-licensed sources."," I ONLY get hormones from friends, online, or other non- licensed sources"]
    var healthCareListArr = ["have had it","want it someday","not sure if I want this","don’t want this"]
    var socializeArr = ["In political activism","Socializing in person","Socializing on-line (such as Facebook or Twitter)","In support groups","I don’t socialize with other trans people"]
    var optionTableArr = [String]()
    var socializeAnsArr = [String]()
    var cellHeightsDictionary: [AnyHashable : Any] = [:]
    @IBOutlet weak var Viewheight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainBlurTop: NSLayoutConstraint!
    @IBOutlet weak var navTopSafeArea: NSLayoutConstraint!
    @IBOutlet weak var mainBlurViewBottom: NSLayoutConstraint!
    @IBOutlet weak var QuesTableView: UITableView!
    @IBOutlet weak var optionTableView: UITableView!
    var yesBtnImg = Bool()
    var likertScaleFor = ""
    var radioImg = ""
    var quesFor = ""
    var senderTag = Int()
    var Screenframeheight  = CGFloat()
    var entryArr = [String]()
    var surveyDict = [String:Any]()
    var ImgDict = [Int:[String:String]]()
    
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
        if surveyDict.count < 27{
            PresentAlert(message: "please submit all answers", title: "TransLife")
        }else{
            savingSurvey.saveSurveyWith(Dict: surveyDict, view: self, surveyName: "Medical surgical transition")
        }
    }
    @IBAction func tableViewItemDoneAct(_ sender: Any) {
        surveyDict.updateValue(socializeAnsArr, forKey: "Ques6")
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
       // sender.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected"), for: .normal)
        yesBtnImg = true
        QuesTableView.reloadData()
        print(sender.tag)
    }
    
    @objc func radioBtnNoClicked(_ sender:UIButton) {
       // sender.setBackgroundImage(#imageLiteral(resourceName: "radio_button_selected"), for: .normal)
        yesBtnImg = false
        QuesTableView.reloadData()
        print(sender.tag)
    }
    

    func radioBtnStronglyAgree(_ sender: sliderTVCell) {
        guard let tappedIndexPath = QuesTableView.indexPath(for: sender) else { return }
        self.entryArr[tappedIndexPath.row] = "1"
        surveyDict.updateValue("StronglyAgree", forKey: "ques1statement\(tappedIndexPath.row)")
        
    }
    func radioBtnAgree(_ sender: sliderTVCell) {
        guard let tappedIndexPath = QuesTableView.indexPath(for: sender) else { return }
         self.entryArr[tappedIndexPath.row] = "2"
        surveyDict.updateValue("Agree", forKey: "ques1statement\(tappedIndexPath.row)")
    }
    func radioBtnStronglyDisagree(_ sender: sliderTVCell) {
        guard let tappedIndexPath = QuesTableView.indexPath(for: sender) else { return }
       surveyDict.updateValue("StronglyDisagree", forKey: "ques1statement\(tappedIndexPath.row)")
        self.entryArr[tappedIndexPath.row] = "5"
    }
    
    func radioBtnDisagree(_ sender: sliderTVCell) {
        guard let tappedIndexPath = QuesTableView.indexPath(for: sender) else { return }
        self.entryArr[tappedIndexPath.row] = "4"
        surveyDict.updateValue("Disagree", forKey: "ques1statement\(tappedIndexPath.row)")
    }
    
    func radioBtnNeutral(_ sender: sliderTVCell) {
        guard let tappedIndexPath = QuesTableView.indexPath(for: sender) else { return }
        self.entryArr[tappedIndexPath.row] = "3"
        surveyDict.updateValue("Neutral", forKey: "ques1statement\(tappedIndexPath.row)")
    }
    
}
extension NonMandatorySurvey5VC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == QuesTableView{
            return quesArr.count
        }else{
            return optionTableArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == QuesTableView{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTvCell", for: indexPath) as! MultipleSelectionTvCell
                cell.questionLbl.text = quesArr[indexPath.row]
                cell.viewFordropdown.isHidden = true
                cell.healthcarelistLabel.text = "scale your response below :"
                cell.layoutIfNeeded()
                
                return cell
                
            }else if indexPath.row >= 1 && indexPath.row <= 10{
                let cell = tableView.dequeueReusableCell(withIdentifier: "sliderTVCell", for: indexPath) as! sliderTVCell
                cell.quesLbl.text = quesArr[indexPath.row]
                cell.delegate = self
                cell.radioBtnStronglyAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
                cell.radioBtnAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
                cell.radioBtnNeutral.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
                cell.radioBtnDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
                cell.radioBtnStronglyDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
                
                if(self.entryArr[indexPath.row] == "1"){
                     cell.radioBtnStronglyAgree.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
                }
                if(self.entryArr[indexPath.row] == "2"){
                    cell.radioBtnAgree.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
                }
                if(self.entryArr[indexPath.row] == "3"){
                    cell.radioBtnNeutral.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
                }
                if(self.entryArr[indexPath.row] == "4"){
                    cell.radioBtnDisagree.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
                }
                if(self.entryArr[indexPath.row] == "5"){
                    cell.radioBtnStronglyDisagree.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
                }
                cell.layoutIfNeeded()
                return cell
                
            }else if indexPath.row == 11{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoOptionTvCell", for: indexPath) as! TwoOptionTvCell
                cell.QuestionLbl.text = quesArr[indexPath.row]
                
                if yesBtnImg == true{
                    cell.radioImgNoBtn.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
                    cell.radioImgYesBtn.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
                }else{
                    cell.radioImgYesBtn.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
                    cell.radioImgNoBtn.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
                }
                cell.radioImgYesBtn.tag = indexPath.row
                cell.radioImgNoBtn.tag = indexPath.row
                cell.radioImgYesBtn.addTarget(self, action:  #selector(self.radioBtnYesClicked(_:)), for: .touchUpInside)
                cell.radioImgNoBtn.addTarget(self, action:  #selector(self.radioBtnNoClicked(_:)), for: .touchUpInside)
                cell.layoutIfNeeded()
                return cell
            }else if indexPath.row == 13 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTvCell", for: indexPath) as! MultipleSelectionTvCell
                cell.questionLbl.text = quesArr[indexPath.row]
                cell.viewFordropdown.isHidden = true
                cell.healthcarelistLabel.text = "for female at birth :"
                cell.layoutIfNeeded()
                
                return cell
            }else if indexPath.row == 19 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTvCell", for: indexPath) as! MultipleSelectionTvCell
                cell.questionLbl.text = quesArr[indexPath.row]
                cell.viewFordropdown.isHidden = true
                cell.healthcarelistLabel.text = "for male at birth :"
                cell.layoutIfNeeded()
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTvCell", for: indexPath) as! MultipleSelectionTvCell
                cell.questionLbl.text = quesArr[indexPath.row]
                cell.viewFordropdown.isHidden = false
                //cell.selectAnswerBtn.setTitle("select answer", for: .normal)
                if indexPath.row == 12{
                    cell.selectAnswerBtn.setTitle(surveyDict["ques3"] as? String, for: .normal)
                }else if indexPath.row == 14{
                    cell.selectAnswerBtn.setTitle(surveyDict["que4part1"] as? String, for: .normal)
                }else if indexPath.row == 15{
                    cell.selectAnswerBtn.setTitle(surveyDict["que4part2"] as? String, for: .normal)
                }else if indexPath.row == 16{
                    cell.selectAnswerBtn.setTitle(surveyDict["que4part3"] as? String, for: .normal)
                }else if indexPath.row == 17{
                    cell.selectAnswerBtn.setTitle(surveyDict["que4part4"] as? String, for: .normal)
                }else if indexPath.row == 18{
                    cell.selectAnswerBtn.setTitle(surveyDict["que4part5"] as? String, for: .normal)
                }else if indexPath.row == 20{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part1"] as? String, for: .normal)
                }else if indexPath.row == 21{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part2"] as? String, for: .normal)
                }else if indexPath.row == 22{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part3"] as? String, for: .normal)
                }else if indexPath.row == 23{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part4"] as? String, for: .normal)
                }else if indexPath.row == 24{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part5"] as? String, for: .normal)
                }else if indexPath.row == 25{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part6"] as? String, for: .normal)
                }else if indexPath.row == 26{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part7"] as? String, for: .normal)
                }else if indexPath.row == 27{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part8"] as? String, for: .normal)
                }else if indexPath.row == 28{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part9"] as? String, for: .normal)
                }else if indexPath.row == 29{
                    cell.selectAnswerBtn.setTitle(surveyDict["que5part10"] as? String, for: .normal)
                }else if indexPath.row == 30{
                    cell.selectAnswerBtn.setTitle("you have choosen \(socializeAnsArr.count) options", for: .normal)
                }
                cell.layoutIfNeeded()
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyTVCell", for: indexPath) as! SurveyTVCell
            cell.answerLbl.text = optionTableArr[indexPath.row]
            if socializeAnsArr.contains(cell.answerLbl.text ?? "nii"){
                DispatchQueue.main.async(execute: {
                    cell.RadioImg.image = UIImage(named: "radio_button_selected")
                })
            }
            if quesFor == "harmonesArr"{
                if let val = surveyDict["ques3"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "14"{
                if let val = surveyDict["que4part1"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "15"{
                if let val = surveyDict["que4part2"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "16"{
                if let val = surveyDict["que4part3"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "17"{
                if let val = surveyDict["que4part4"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "18"{
                if let val = surveyDict["que4part5"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "20"{
                if let val = surveyDict["que5part1"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "21"{
                if let val = surveyDict["que5part2"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "22"{
                if let val = surveyDict["que5part3"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "23"{
                if let val = surveyDict["que5part4"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "24"{
                if let val = surveyDict["que5part5"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "25"{
                if let val = surveyDict["que5part6"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "26"{
                if let val = surveyDict["que5part7"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "27"{
                if let val = surveyDict["que5part8"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "28"{
                if let val = surveyDict["que5part9"]  {
                    if val as? String == cell.answerLbl.text{
                        DispatchQueue.main.async(execute: {
                            cell.RadioImg.image = UIImage(named: "radio_button_selected")
                        })
                    }
                }
            }else if quesFor == "29"{
                if let val = surveyDict["que5part10"]  {
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
        if tableView == QuesTableView {
       
            if indexPath.row == 12{
                optionTableArr = harmonesArr
                optionTableView.allowsMultipleSelection = false
                optionTableView.allowsMultipleSelectionDuringEditing = false
                quesFor = "harmonesArr"
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainBlurTop.constant = self.navTopSafeArea.constant
                    self.mainBlurViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else if indexPath.row >= 14 && indexPath.row <= 29 && indexPath.row != 19{
                optionTableArr = healthCareListArr
                quesFor = "\(indexPath.row)"
                optionTableView.allowsMultipleSelection = false
                optionTableView.allowsMultipleSelectionDuringEditing = false
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainBlurTop.constant = self.navTopSafeArea.constant
                    self.mainBlurViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else if indexPath.row == 30{
                optionTableArr = socializeArr
                quesFor = "socializeAnsArr"
                optionTableView.allowsMultipleSelection = true
                optionTableView.allowsMultipleSelectionDuringEditing = true
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainBlurTop.constant = self.navTopSafeArea.constant
                    self.mainBlurViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            optionTableView.reloadData()
        }else{
            let AnsOptionCell = self.optionTableView.cellForRow(at: indexPath) as! SurveyTVCell
            if quesFor == "harmonesArr"{
                surveyDict.updateValue(harmonesArr[indexPath.row], forKey: "ques3")
                 optionTableView.reloadData()
            }else if quesFor == "14"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que4part1")
                 optionTableView.reloadData()
            }else if quesFor == "15"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que4part2")
                 optionTableView.reloadData()
            }else if quesFor == "16"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que4part3")
                 optionTableView.reloadData()
            }else if quesFor == "17"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que4part4")
                 optionTableView.reloadData()
            }else if quesFor == "18"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que4part5")
                 optionTableView.reloadData()
            }else if quesFor == "20"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part1")
                 optionTableView.reloadData()
            }else if quesFor == "21"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part2")
                 optionTableView.reloadData()
            }else if quesFor == "22"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part3")
                 optionTableView.reloadData()
            }else if quesFor == "23"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part4")
                 optionTableView.reloadData()
            }else if quesFor == "24"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part5")
                 optionTableView.reloadData()
            }else if quesFor == "25"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part6")
                 optionTableView.reloadData()
            }else if quesFor == "26"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part7")
                 optionTableView.reloadData()
            }else if quesFor == "27"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part8")
                 optionTableView.reloadData()
            }else if quesFor == "28"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part9")
                 optionTableView.reloadData()
            }else if quesFor == "29"{
                surveyDict.updateValue(healthCareListArr[indexPath.row], forKey: "que5part10")
                 optionTableView.reloadData()
            }else if quesFor == "socializeAnsArr"{
                if socializeAnsArr.contains(AnsOptionCell.answerLbl.text ?? "cd"){
                }else{
                    self.socializeAnsArr.append(socializeArr[indexPath.row])
                }
            }
           
        }
           print(surveyDict)
        }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == optionTableView{
            let cell = self.optionTableView.cellForRow(at: indexPath) as! SurveyTVCell
        if cell.RadioImg.image == UIImage(named: "radio_button_unselected"){
            if socializeAnsArr.contains(cell.answerLbl.text ?? "nii"){
                let Eleindex =  socializeAnsArr.firstIndex(of: cell.answerLbl.text ?? "dcs")
                socializeAnsArr.remove(at: Eleindex ?? 0)
            }
        }
    }
    }

}
    


