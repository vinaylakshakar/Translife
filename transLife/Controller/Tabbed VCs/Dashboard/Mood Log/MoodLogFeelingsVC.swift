//
//  MoodLogFeelingsVC.swift
//  transLife
//
//  Created by Developer Silstone on 12/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout
import TTGTagCollectionView

var selectedFeelArr = [String]()
var selectedreasonArr = [String]()
class MoodLogFeelingsVC: UIViewController,UIAdaptivePresentationControllerDelegate {

    
    var UserMoodLog = MoodLog()
    var FeelingSelected = false
    @IBOutlet weak var AddFeelingBtn: UIButton!
    @IBOutlet weak var AddReasonBtn: UIButton!
    @IBOutlet weak var BackFeelView: UIView!
    var sleepLevel:String = "0"
    var energyLevel:String = "0"
    @IBOutlet weak var feelingsCollectionView: UICollectionView!
    @IBOutlet weak var reasonCollectionView: UICollectionView!
    @IBOutlet weak var SleepTrackSlider: UISlider!
    @IBOutlet weak var EnergyLevelTrackSlider: UISlider!
    @IBOutlet weak var feelingsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reasonCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    var SleeptrackSliderLabel: UILabel?
    var EnergyLevelTrackLabel: UILabel?
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshingMoodView(notification:)), name:NSNotification.Name(rawValue: "refreshingMoodView"), object: nil)
        let feelingsCollectionViewalignedFlowLayout = feelingsCollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        feelingsCollectionViewalignedFlowLayout?.horizontalAlignment = .right
        feelingsCollectionViewalignedFlowLayout?.verticalAlignment = .top
        let reasonCollectionViewalignedFlowLayout = reasonCollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        reasonCollectionViewalignedFlowLayout?.horizontalAlignment = .right
        reasonCollectionViewalignedFlowLayout?.verticalAlignment = .top
        AddReasonBtn.dropShadowTransLife()
        BackFeelView.dropShadowTransLife()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         navigationController?.navigationBar.barStyle = .black
    }
    override func viewWillAppear(_ animated: Bool) {
       self.feelingsCollectionView.reloadData()
            self.reasonCollectionView.reloadData()
         setupCollectionviewHeight()
    }
    @objc func refreshingMoodView(notification: NSNotification) {
        self.feelingsCollectionView.reloadData()
           self.reasonCollectionView.reloadData()
        setupCollectionviewHeight()
    }
    //MARK: SETUP COLLECTIONVIEW HEIGHT
    func setupCollectionviewHeight()  {
        let reasonCollectionViewheight = self.reasonCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.reasonCollectionViewHeight.constant = reasonCollectionViewheight
        let feelingsCollectionViewheight = self.feelingsCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.feelingsCollectionViewHeight.constant = feelingsCollectionViewheight
        if FeelingSelected == true{
            self.feelingsCollectionViewHeight.constant = feelingsCollectionViewheight
            self.mainViewHeight.constant = feelingsCollectionViewheight + 550 + reasonCollectionViewheight
            self.view.layoutIfNeeded()
        }else{
            self.reasonCollectionViewHeight.constant = reasonCollectionViewheight
            self.mainViewHeight.constant = reasonCollectionViewheight + 550 + feelingsCollectionViewheight
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:ACTIONS
    //MARK:SLEEP TRACKER Slider
    @IBAction func SleepTrackSliderDidMove(_ sender: UISlider) {
        let senderValue = sender.value
        if senderValue <= 0.5{
           sleepLevel = "0"
        }else if senderValue > 0.5 && senderValue <= 1.5{
          sleepLevel = "1"
        }else if senderValue > 1.5 && senderValue <= 2.5{
             sleepLevel = "2"
        }else if senderValue > 2.5 && senderValue <= 3.5{
           sleepLevel = "3"
        }else if senderValue > 3.5 && senderValue <= 4.5{
            sleepLevel = "4"
        }else if senderValue > 4.5 && senderValue <= 5.5{
           sleepLevel = "5"
        }else if senderValue > 5.5{
            sleepLevel = "6"
        }
        
    }
    //MARK:ENERGY TRACKER Slider
    @IBAction func EnergyTrackSliderDidMove(_ sender: UISlider) {
        let senderValue = sender.value
        if senderValue <= 0.5{
            energyLevel = "0"
        }else if senderValue > 0.5 && senderValue <= 1.5{
            energyLevel = "1"
        }else if senderValue > 1.5 && senderValue <= 2.5{
            energyLevel = "2"
        }else if senderValue > 2.5 && senderValue <= 3.5{
            energyLevel = "3"
        }else if senderValue > 3.5 && senderValue <= 4.5{
            energyLevel = "4"
        }else if senderValue > 4.5 && senderValue <= 5.5{
            energyLevel = "5"
        }else if senderValue > 5.5{
            energyLevel = "6"
        }
        
    }
    //MARK:ACTION FOR MAKING  Sleep SLIDER STICKY
    @IBAction func SleepSliderTouchUpInside(_ sender: UISlider) {
        let senderValue = sender.value
        if senderValue <= 0.5{
            self.SleepTrackSlider.setValue(0, animated: true)
        }else if senderValue > 0.5 && senderValue <= 1.5{
            self.SleepTrackSlider.setValue(1, animated: true)
        }else if senderValue > 1.5 && senderValue <= 2.5{
            self.SleepTrackSlider.setValue(2, animated: true)
        }else if senderValue > 2.5 && senderValue <= 3.5{
            self.SleepTrackSlider.setValue(3, animated: true)
        }else if senderValue > 3.5 && senderValue <= 4.5{
            self.SleepTrackSlider.setValue(4, animated: true)
        }else if senderValue > 4.5 && senderValue <= 5.5{
            self.SleepTrackSlider.setValue(5, animated: true)
        }else if senderValue > 5.5{
            self.SleepTrackSlider.setValue(6, animated: true)
        }

    }
    //MARK:ACTION FOR MAKING EnergyLevel SLIDER STICKY
    @IBAction func EnergyLevelSliderTouchUpInside(_ sender: UISlider) {
        let senderValue = sender.value
        if senderValue <= 0.5{
            self.EnergyLevelTrackSlider.setValue(0, animated: true)
        }else if senderValue > 0.5 && senderValue <= 1.5{
            self.EnergyLevelTrackSlider.setValue(1, animated: true)
        }else if senderValue > 1.5 && senderValue <= 2.5{
            self.EnergyLevelTrackSlider.setValue(2, animated: true)
        }else if senderValue > 2.5 && senderValue <= 3.5{
            self.EnergyLevelTrackSlider.setValue(3, animated: true)
        }else if senderValue > 3.5 && senderValue <= 4.5{
            self.EnergyLevelTrackSlider.setValue(4, animated: true)
        }else if senderValue > 4.5 && senderValue <= 5.5{
            self.EnergyLevelTrackSlider.setValue(5, animated: true)
        }else if senderValue > 5.5{
            self.EnergyLevelTrackSlider.setValue(6, animated: true)
        }

    }
    
    @IBAction func addReasonBtnAct(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoodFeelingsListVC") as! MoodFeelingsListVC
        vc.isFeelingSelected = false
         FeelingSelected = false
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func addFeelingsBtnAct(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoodFeelingsListVC") as! MoodFeelingsListVC
        vc.isFeelingSelected = true
        FeelingSelected = true
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func BackBtnAct(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)  }
    @IBAction func DoneBtnAct(_ sender: Any) {
        
        MoodLogData.updateValue(sleepLevel, forKey: "sleepLevel")
        MoodLogData.updateValue(energyLevel, forKey: "energyLevel")
        MoodLogData.updateValue(selectedFeelArr, forKey: "Feelings")
        MoodLogData.updateValue(selectedreasonArr, forKey: "Reasons")
                PushTo(FromVC: self, ToStoryboardID: "MoodLogNotesVC")
            
        }
        
    }

extension MoodLogFeelingsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
     //MARK:COLLECTIONVIEW DATASOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == feelingsCollectionView{
            return selectedFeelArr.count
        }else{
            return selectedreasonArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoodAddFeelingsCell", for: indexPath) as! MoodAddFeelingsCell
        if collectionView == feelingsCollectionView{
            cell.FeelingsLabel.text = selectedFeelArr[indexPath.item]
            
        }else{
            cell.FeelingsLabel.text = selectedreasonArr[indexPath.item]
        
        }
        return cell
    }
    //MARK:COLLECTIONVIEW DELEGATE
    
     //MARK:COLLECTIONVIEW LAYOUT DELEGATE
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == feelingsCollectionView{
            
            let size = (selectedFeelArr[indexPath.item] as NSString).size(withAttributes: nil)
            let width = size.width + 50
            let height = size.height + 25
            print("feeling \(height)")
            return  CGSize(width: width, height: height)
        }else{
            let size = (selectedreasonArr[indexPath.item] as NSString).size(withAttributes: nil)
            let width = size.width + 80
            let height = size.height + 25
            print("reason \(height)")
            return  CGSize(width: width, height: height)
        }
        
        
    }
    
    
}
