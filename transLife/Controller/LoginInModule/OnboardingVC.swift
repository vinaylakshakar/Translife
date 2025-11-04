//
//  OnboardingVC.swift
//  transLife
//
//  Created by Developer Silstone on 04/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {

    
    @IBOutlet weak var DatePickerBottom: NSLayoutConstraint!
    @IBOutlet weak var FromBtn: UIButton!
    @IBOutlet weak var ToBtn: UIButton!
    @IBOutlet weak var que1view: UIView!
    @IBOutlet weak var TopLine: UILabel!
    @IBOutlet weak var ScrollableView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    // MARK: Lables
    @IBOutlet weak var FromLbl: UILabel!
    @IBOutlet weak var ToLbl: UILabel!
    @IBOutlet weak var ZipCodeTextField: UITextField!
    @IBOutlet weak var AgeTextField: UITextField!
    @IBOutlet weak var YesRadioImg: UIImageView!
    @IBOutlet weak var someWhatRadioImg: UIImageView!
    @IBOutlet weak var NoradioImg: UIImageView!
    @IBOutlet weak var randomlyDayRadioImg: UIImageView!
    @IBOutlet weak var randomlyEveningRadioImg: UIImageView!
    @IBOutlet weak var specificHourradioImg: UIImageView!
    @IBOutlet weak var FromView: UIView!
    @IBOutlet weak var ToView: UIView!
    
    @IBOutlet weak var MyDatePicker: UIDatePicker!
     var fromTo = false
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       self.DatePickerBottom.constant = -170
       HideKeyboard()
       txtfieldPlaceholder()
     //  HandleNotificationKeyboard()
        MyDatePicker.backgroundColor = hexStringToUIColor(hex: "#88EBFD")
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //MARK:- placeholder Attributes
    func txtfieldPlaceholder() {
        ZipCodeTextField.attributedPlaceholder = NSAttributedString(string: "Zip Code (example: ON K2L 4H7)", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        AgeTextField.attributedPlaceholder = NSAttributedString(string: "Age(example: 29)", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
    }
    //MARK:ACTIONS
    @IBAction func submitBtnACTION(_ sender: Any) {

    }
    
    @IBAction func fromBtnAct(_ sender: Any) {
        fromTo = false
        UIView.animate(withDuration: 0.4, animations: {
            self.view.endEditing(true)
            self.DatePickerBottom.constant = 0
            self.FromView.borderColorV = hexStringToUIColor(hex: "#003644")
            self.ToView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.ScrollView.contentOffset = CGPoint(x: 0, y: 300)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    @IBAction func ToBtnAct(_ sender: Any) {
        fromTo = true
        UIView.animate(withDuration: 0.4, animations: {
            self.view.endEditing(true)
            self.DatePickerBottom.constant = 0
            self.ToView.borderColorV = hexStringToUIColor(hex: "#003644")
            self.FromView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.ScrollView.contentOffset = CGPoint(x: 0, y: 300)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func GetTimeAction(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        if fromTo == false{
        FromLbl.text = formatter.string(from: sender.date)
        FromLbl.textColor = hexStringToUIColor(hex: "#003644")
        FromLbl.font = UIFont(name:"SegoeUI-Regular", size: 18)
        }else{
            ToLbl.text = formatter.string(from: sender.date)
            ToLbl.textColor = hexStringToUIColor(hex: "#003644")
            ToLbl.font = UIFont(name:"SegoeUI-Regular", size: 18)
        }
    }
    
    @IBAction func YesBtnACTION(_ sender: Any) {
         YesRadioImg.image = UIImage(named: "radio_button_selected_blue")
            someWhatRadioImg.image = UIImage(named: "radio button_unselected")
            NoradioImg.image = UIImage(named: "radio button_unselected")
        
    }
    @IBAction func someWhatBtnACTION(_ sender: Any) {
         someWhatRadioImg.image = UIImage(named: "radio_button_selected_blue")
            YesRadioImg.image = UIImage(named: "radio button_unselected")
            NoradioImg.image = UIImage(named: "radio button_unselected")
        
    }
    @IBAction func noBtnACTION(_ sender: Any) {
         NoradioImg.image = UIImage(named: "radio_button_selected_blue")
            YesRadioImg.image = UIImage(named: "radio button_unselected")
            someWhatRadioImg.image = UIImage(named: "radio button_unselected")
        
    }
    
    @IBAction func RandomlyTimeBtnACTION(_ sender: Any) {
        randomlyDayRadioImg.image = UIImage(named: "radio_button_selected_blue")
        randomlyEveningRadioImg.image = UIImage(named: "radio button_unselected")
        specificHourradioImg.image = UIImage(named: "radio button_unselected")
        
    }
    @IBAction func RandomlyTimeEveningBtnACTION(_ sender: Any) {
        randomlyEveningRadioImg.image = UIImage(named: "radio_button_selected_blue")
        randomlyDayRadioImg.image = UIImage(named: "radio button_unselected")
        specificHourradioImg.image = UIImage(named: "radio button_unselected")
        
    }
    @IBAction func SpecificBtnACTION(_ sender: Any) {
        specificHourradioImg.image = UIImage(named: "radio_button_selected_blue")
        randomlyEveningRadioImg.image = UIImage(named: "radio button_unselected")
        randomlyDayRadioImg.image = UIImage(named: "radio button_unselected")
        
    }
    
    @IBAction func DoneTabItem(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
      self.DatePickerBottom.constant = -170
            self.ToView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.FromView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.view.layoutIfNeeded()
        }, completion: nil)
       
    }
    
    //MARK:-Handle Keyboard
    func HandleNotificationKeyboard()  {
        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingVC.keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
            ScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 130, right: 0)
          
            ScrollView.scrollIndicatorInsets = ScrollView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
       // ScrollView.contentOffset = .zero
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
            // ScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - 100, right: 0)
            ScrollView.contentOffset = CGPoint(x: 0, y: keyboardViewEndFrame.height - 150)
            
        }
        
    }


    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func HideKeyboard() {
        let tap :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func DismissKeyboard() {
        UIView.animate(withDuration: 0.4, animations: {
            self.DatePickerBottom.constant = -170
            self.ToView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.FromView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.view.layoutIfNeeded()
        }, completion: nil)
        view.endEditing(true)
    }
}


