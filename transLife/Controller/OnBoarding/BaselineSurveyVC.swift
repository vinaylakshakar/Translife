//
//  SurveyVC.swift
//  transLife
//
//  Created by Developer Silstone on 06/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class BaselineSurveyVC: UIViewController {
    
      var sections = [[""],["Q. Have you ever wished you were dead or wished you could go to sleep and not wake up ?","Q. Have you actually had any thoughts of killing yourself ?"],["Q. Have you been thinking about how you might kill yourself ?","Q. Have you had these thoughts and had some intention of acting on them ?","Q. Have you started to work out or worked out the details of how to kill yourself? Do you intend to carry out this plan ?"],["Q. Have you ever done anything, started to do anything, or prepared to do anything to end your life ?"],["Q. How long ago did you do any of these ?"]]
    var arrque = ["Q. Have you ever wished you were dead or wished you could go to sleep and not wake up ?","Q. Have you actually had any thoughts of killing yourself ?","Q. Have you ever done anything, started to do anything, or prepared to do anything to end your life ?"]
    var expandData = [NSMutableDictionary]()
    var section2count = 3
    var section4count = 1
    var queView = UIView()
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.expandData.append(["isOpen":"1","data":[""]])
        self.expandData.append(["isOpen":"1","data":["Q. Have you been thinking about how you might kill yourself ?","Q. Have you had these thoughts and had some intention of acting on them ?","Q. Have you started to work out or worked out the details of how to kill yourself? Do you intend to carry out this plan ?"]])
        self.expandData.append(["isOpen":"1","data":["Q. How long ago did you do any of these ?"]])
      
    }
    
    @objc func answerIsYesBtnTapped(_ sender: UIButton){
        print("answerIsYesBtnTapped")
        print(sender.tag)
        if sender.tag == 11{
            section2count = 3
            self.myTableView.reloadSections(IndexSet(integer:2), with: .automatic)
        }
       
    }

    @objc func answerIsNoBtnTapped(_ sender: UIButton){
        print("answerIsNoBtnTapped")
        print(sender.tag)
        if sender.tag == 11{
            section2count = 0
            self.myTableView.beginUpdates()
        self.myTableView.reloadSections(IndexSet(integer:2), with: .automatic)
            self.myTableView.endUpdates()
        }
       
    }
    

}

//extension BaselineSurveyVC : UITableViewDelegate,UITableViewDataSource{
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 5
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }else if section == 1{
//            return 2
//        }else if section == 2{
//            return section2count
//        }else if section == 4{
//            return section4count
//        }else{
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "BaslineSurveyPartOneTVCell", for: indexPath) as! BaslineSurveyPartOneTVCell
//            return cell
//        }else{
//       let cell = tableView.dequeueReusableCell(withIdentifier: "BaselineSurveyTVCell", for: indexPath) as! BaselineSurveyTVCell
//        cell.quesText.text = sections[indexPath.section][indexPath.row]
//            cell.answerIsNoBtn.tag = Int("\(indexPath.section)\(indexPath.row)") ?? 44
//            cell.answerIsYesBtn.tag = Int("\(indexPath.section)\(indexPath.row)") ?? 43
//            cell.answerIsYesBtn.addTarget(self, action: #selector(self.answerIsYesBtnTapped(_:)), for: .touchUpInside)
//            cell.answerIsNoBtn.addTarget(self, action: #selector(self.answerIsNoBtnTapped(_:)), for: .touchUpInside)
//
//        return cell
//        }
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 435
//        }else{
//             return 125
//        }
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("indexpath.section :\(indexPath.section)")
//        print("indexpath.row :\(indexPath.row)")
//    }
//
//}

extension BaselineSurveyVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.expandData[section].value(forKey: "isOpen") as! String == "1"{
            return 0
        }else{
            let dataarray = self.expandData[section].value(forKey: "data") as! NSArray
            return dataarray.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.expandData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaselineSurveyTVCell", for: indexPath) as! BaselineSurveyTVCell
        let dataarray = self.expandData[indexPath.section].value(forKey: "data") as! NSArray
        cell.quesText.text = dataarray[indexPath.row] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 10, y: 10, width: tableView.bounds.size.width - 40, height: 110))
        view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 10, y: 10, width: tableView.bounds.size.width - 60, height: 100)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.CornerRadius(5)
        view.addSubview(blurEffectView)
        let headerView = UIView(frame: CGRect(x: 10, y: 10, width: tableView.bounds.size.width - 20, height: 110))
        headerView.backgroundColor = UIColor.clear
       
        let headerLabel = UILabel(frame: CGRect(x: 27, y: 5, width: headerView.frame.size.width - 20, height: 20))
        headerLabel.text = arrque[section]
        headerLabel.font = UIFont(name:"SegoeUI-Bold", size: 15)
        headerLabel.numberOfLines = 0
        headerLabel.textColor = hexStringToUIColor(hex:"#003644")
        headerLabel.sizeToFit()
        headerLabel.contentMode = .center
        headerView.addSubview(headerLabel)
        headerView.tag = section + 100
        view.addSubview(headerView)
        
        let YesRadioImg = UIImageView()
        YesRadioImg.image = UIImage(named: "radio_button_selected")
       // YesRadioImg.tag = section + 100
        view.addSubview(YesRadioImg)
        YesRadioImg.translatesAutoresizingMaskIntoConstraints = false
        YesRadioImg.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor).isActive = true
        YesRadioImg.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true
        YesRadioImg.widthAnchor.constraint(equalToConstant: 26).isActive = true
        YesRadioImg.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        let yesLbl = UILabel()
        yesLbl.text = "Yes"
        yesLbl.font = UIFont(name:"SegoeUI-regular", size: 15)
        yesLbl.numberOfLines = 0
        yesLbl.textColor = hexStringToUIColor(hex:"#003644")
        view.addSubview(yesLbl)
        yesLbl.translatesAutoresizingMaskIntoConstraints = false
        yesLbl.leadingAnchor.constraint(equalTo: YesRadioImg.trailingAnchor, constant: 10).isActive = true
        yesLbl.centerYAnchor.constraint(equalTo: YesRadioImg.centerYAnchor).isActive = true
        yesLbl.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        
        let NoRadioImg = UIImageView()
        NoRadioImg.image = UIImage(named: "radio button_unselected")
        // YesRadioImg.tag = section + 100
        view.addSubview(NoRadioImg)
        NoRadioImg.translatesAutoresizingMaskIntoConstraints = false
        NoRadioImg.leadingAnchor.constraint(equalTo: yesLbl.trailingAnchor,constant:37).isActive = true
        NoRadioImg.centerYAnchor.constraint(equalTo: YesRadioImg.centerYAnchor).isActive = true
        NoRadioImg.widthAnchor.constraint(equalToConstant: 26).isActive = true
        NoRadioImg.heightAnchor.constraint(equalToConstant: 26).isActive = true
       
        let NoLbl = UILabel()
        NoLbl.text = "No"
        NoLbl.font = UIFont(name:"SegoeUI-regular", size: 15)
        NoLbl.numberOfLines = 0
        NoLbl.textColor = hexStringToUIColor(hex:"#003644")
        view.addSubview(NoLbl)
        NoLbl.translatesAutoresizingMaskIntoConstraints = false
        NoLbl.leadingAnchor.constraint(equalTo: NoRadioImg.trailingAnchor, constant: 10).isActive = true
        NoLbl.centerYAnchor.constraint(equalTo: YesRadioImg.centerYAnchor).isActive = true
        NoLbl.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        
        let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
        headerView.addGestureRecognizer(tapgesture)
        
        return view
    }
    @objc func sectionTapped(_ sender: UITapGestureRecognizer){
        if(self.expandData[(sender.view?.tag)! - 100].value(forKey: "isOpen") as! String == "1"){
            self.expandData[(sender.view?.tag)! - 100].setValue("0", forKey: "isOpen")
        }else{
            self.expandData[(sender.view?.tag)! - 100].setValue("1", forKey: "isOpen")
        }
        self.myTableView.reloadSections(IndexSet(integer: (sender.view?.tag)! - 100), with: .automatic)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                print("indexpath.section :\(indexPath.section)")
               print("indexpath.row :\(indexPath.row)")
    }
}
