//
//  QuestioningMoodLogVC.swift
//  transLife
//
//  Created by Developer Silstone on 12/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Lottie
import SVProgressHUD
var moodfeeling = "neutral"
var MoodLogData = [String:Any]()
class QuestioningMoodLogVC: UIViewController {
    
    @IBOutlet weak var blurViewForBlockingUI: UIVisualEffectView!
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var animView: UIView!
    var ValueGetting = CGFloat()
    let animationView = LOTAnimationView(name: "data")
    var UserMoodLog = MoodLog()
    @IBOutlet weak var LblCenterYcons: NSLayoutConstraint!
    @IBOutlet weak var MoodLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        LottieAnimSetup()
       
     self.navigationController?.navigationBar.isHidden = true
        
        }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        if ispendingMandSurvey == true{
            blurViewForBlockingUI.isHidden = false
        }else{
            blurViewForBlockingUI.isHidden = true
        }
        selectedFeelArr.removeAll()
        selectedreasonArr.removeAll()
         SVProgressHUD.dismiss()
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        if tabBarController?.selectedIndex == 2{
            backBtn.isHidden = true
        }else{
            backBtn.isHidden = false
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem.imageInsets.bottom = 0
        self.tabBarItem.imageInsets.top = 0
        self.tabBarItem.image = UIImage(named: "nav_moodlog")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "nav_moodlog")?.withRenderingMode(.alwaysOriginal)
    }
    // MARK: LOTTIE ANIMATION
    func LottieAnimSetup(){
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animView.addSubview(animationView)
        animationView.animationProgress = 0.5
        Slider.value = 500
        animView.bringSubviewToFront(MoodLbl)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                LblCenterYcons.constant = -25
            case 1334:
                print("iPhone 6/6S/7/8")
                LblCenterYcons.constant = -30
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                LblCenterYcons.constant = -35
            case 2436:
                print("iPhone X, XS")
                LblCenterYcons.constant = -10
            case 2688:
                print("iPhone XS Max")
                LblCenterYcons.constant = -20
            case 1792:
                print("iPhone XR")
                LblCenterYcons.constant = -20
            default:
                print("Unknown")
            }
        }
        
    }
    
    // MARK: ACTIONS
    @IBAction func SliderDidMove(_ sender: UISlider) {
        let senderValue = CGFloat(Int(sender.value))
        //ValueGetting = senderValue
        let val = senderValue / 1000
        animationView.animationProgress = val
        if senderValue <= 83.33{
            MoodLbl.text = "Awful"
            moodfeeling = "negative"
        }else if senderValue > 83.33 && senderValue <= 250{
            MoodLbl.text = "Bad"
            moodfeeling = "negative"
        }else if senderValue > 250 && senderValue <= 416.66{
            MoodLbl.text = "Not Good"
            moodfeeling = "negative"
        }else if senderValue > 416.66 && senderValue <= 583.32{
            MoodLbl.text = "Okay"
            moodfeeling = "neutral"
        }else if senderValue > 583.32 && senderValue <= 749.98{
            MoodLbl.text = "Good"
            moodfeeling = "positive"
        }else if senderValue > 749.98 && senderValue <= 916.64{
            MoodLbl.text = "Very Good"
            moodfeeling = "positive"
        }else if senderValue > 916.64{
            MoodLbl.text = "Amazing"
            moodfeeling = "positive"
        }
        //  print(senderValue)
        
    }
    
    @IBAction func SliderTouchUpInside(_ sender: UISlider) {
        let senderValue = CGFloat(Int(sender.value))
        //  print(senderValue)
        let val = senderValue / 1000
        
        if senderValue <= 83.33{
            self.Slider.setValue(0, animated: true)
            for index in stride(from: val, through: 0, by: -1) {
                animationView.animationProgress = index
            }
            
        }else if senderValue > 83.33 && senderValue <= 250{
            self.Slider.setValue(166.66, animated: true)
            for index in stride(from: val, through: 166.66, by: -1) {
                animationView.animationProgress = index
            }
        }else if senderValue > 250 && senderValue <= 416.66{
            self.Slider.setValue(333.32, animated: true)
            for index in stride(from: val, through: 333.32/1000, by: -1) {
                animationView.animationProgress = index
            }
        }else if senderValue > 416.66 && senderValue <= 583.32{
            self.Slider.setValue(500, animated: true)
            for index in stride(from: val, through: 500 / 1000, by: -1) {
                animationView.animationProgress = CGFloat(index)
                print(index)
            }
        }else if senderValue > 583.32 && senderValue <= 749.98{
            self.Slider.setValue(666.64, animated: true)
            for index in stride(from: val, through: 666.64/1000, by: -1) {
                animationView.animationProgress = index
                // print(index)
            }
        }else if senderValue > 749.98 && senderValue <= 916.64{
            self.Slider.setValue(833.3, animated: true)
            for index in stride(from: val, through: 833.3/1000, by: -1) {
                animationView.animationProgress = index
            }
        }else if senderValue > 916.64{
            self.Slider.setValue(1000, animated: true)
            for index in stride(from: val, through: 1000, by: -1) {
                animationView.animationProgress = index
            }
        }
    }
    
    
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func NextBtnAct(_ sender: Any) {
        
        MoodLogData.updateValue(MoodLbl.text ?? "", forKey: "mood")
        PushTo(FromVC: self, ToStoryboardID: "MoodLogFeelingsVC")
    }
}
