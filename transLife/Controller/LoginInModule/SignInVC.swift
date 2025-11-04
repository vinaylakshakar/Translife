//
//  SignInVC.swift
//  transLife
//
//  Created by Developer Silstone on 30/11/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

var termsAndCondition = false
class SignInVC: UIViewController {
    
    var htmlStringTC:String?
    //MARK:- SignInViewReferences
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var SignInViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var SignInViewLeading: NSLayoutConstraint!
    @IBOutlet weak var SignUpViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var SignUpViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var paswrdInfoView: UIView!
    
    //MARK:- SignUpViewReferences
    let user = Users()
    @IBOutlet weak var SignInPasswordEye: UIButton!
    @IBOutlet weak var SignUpPasswordEye: UIButton!
    @IBOutlet weak var SignUpconfirmPasswordEye: UIButton!
    @IBOutlet weak var agePickerBottom: NSLayoutConstraint!
    @IBOutlet weak var TCImage: UIButton!
    @IBOutlet weak var SignUptxtFieldUsername: UITextField!
    @IBOutlet weak var SignUptxtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var AgeBtn: UIButton!
    @IBOutlet weak var NotificationScedulingBtn: UIButton!
    @IBOutlet weak var MyPicker: UIPickerView!
    @IBOutlet weak var RadioBtnImg: UIImageView!
    
    @IBOutlet weak var LblUserName: UILabel!
    var ageString = ["Select"]
    var age = ""
    var NotificationSchedules = ["Morning","Evening"]
    var SelectedNotificationSchedules = ""
    var pickerSelectedForAge = true
    var SignIn:Bool?
    
    @IBOutlet weak var SignInView: UIView!
    @IBOutlet weak var SignUpView: UIView!
    
    @IBOutlet weak var SignINBtn: UIButton!
    @IBOutlet weak var SignUpBtn: UIButton!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    var keyboardHeight = CGFloat()
    
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
         paswrdInfoView.alpha = 0
        SignUpPasswordEye.isHidden = true
        SignInPasswordEye.isHidden = true
        SignUpconfirmPasswordEye.isHidden = true
        self.agePickerBottom.constant = -205
        handleSignUpVsSignIn()
        HandleSwipeGesture()
        
        HideKeyboard()
        for i in 18...100{
            let str = String(i)
            self.ageString.append(str)
            
        }
//        txtFieldUsername.text = "amit"
//        txtFieldPassword.text = "123456"
        
        
        // handleNotificationKeyboard()
        txtfieldPlaceholder()
        autoLogin()
      
    }
    
    
 
    
    func autoLogin(){
        
        if Auth.auth().currentUser != nil{
            PushTo(FromVC: self, ToStoryboardID: "OnboardingSurveyVC")
        }
    }
    func handleSignUpVsSignIn() {
        if SignIn == true {
            SignUpViewLeading.constant = self.view.frame.width
            SignUpViewTrailing.constant = self.view.frame.width
            SignInViewLeading.constant = 0
            SignInViewLeading.constant = 0
            SignINBtn.alpha = 1
            SignUpBtn.alpha = 0.5
        }else if SignIn == false{
            SignInViewLeading.constant = -self.view.frame.width
            SignInViewTrailing.constant = -self.view.frame.width
            SignUpViewLeading.constant = 0
            SignUpViewTrailing.constant = 0
            SignINBtn.alpha = 0.5
            SignUpBtn.alpha = 1
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gettermconditionAdmin()
       
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if termsAndCondition == false{
            RadioBtnImg.image = #imageLiteral(resourceName: "radio button_unselected")
        }else{
            RadioBtnImg.image = #imageLiteral(resourceName: "radio_button_selected")
        }
    }
    func gettermconditionAdmin(){
        ref.child("termsandservices").observeSingleEvent(of: .value) { (snap) in
            if snap.value is NSNull{
                self.PresentAlert(message: "terms And Condition is not saved", title: "TransLife")
            }else{
                let value = snap.value as! [String:AnyObject]
                for i in value{
                    let terms = i.value as! [String:AnyObject]
                    self.htmlStringTC = terms["terms_and_services"] as? String
                }
                
               // self.myWebView.loadHTMLString(self.htmlString ?? "", baseURL: nil)
            }
        }
    }
    
    func txtfieldPlaceholder() {
        txtFieldUsername.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        txtFieldPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        txtFieldConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        txtFieldEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        SignUptxtFieldUsername.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        SignUptxtFieldPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
    }
    
    //MARK:-Handle Swipe
    func HandleSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                self.agePickerBottom.constant = -205
                UIView.animate(withDuration: 0.4, animations: {
                    self.SignUpBtn.alpha = 0.5
                    self.SignINBtn.alpha = 1
                    if self.SignUpViewLeading.constant == 0 {
                        self.SignUpViewTrailing.constant = self.view.frame.width
                        self.SignUpViewLeading.constant = self.view.frame.width
                        self.SignInViewLeading.constant = 0
                        self.SignInViewTrailing.constant = 0
                    }
                    
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            case UISwipeGestureRecognizer.Direction.left:
                ScrollView.contentOffset = CGPoint(x: 0, y: 0)
                UIView.animate(withDuration: 0.4, animations: {
                    self.SignUpBtn.alpha = 1
                    self.SignINBtn.alpha = 0.5
                    if self.SignInViewLeading.constant == 0 {
                        self.SignInViewLeading.constant = -self.view.frame.width
                        self.SignInViewTrailing.constant = -self.view.frame.width
                        self.SignUpViewLeading.constant = 0
                        self.SignUpViewTrailing.constant = 0
                    }
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            default:
                break
            }
        }
    }
    
    //MARK:-Handle Keyboard
    func handleNotificationKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(SignInVC.keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignInVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
            ScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 100, right: 0)
            
            ScrollView.scrollIndicatorInsets = ScrollView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
            ScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - 100, right: 0)
            ScrollView.contentOffset = CGPoint(x: 0, y: 0)
            
        }
    }
    func HideKeyboard() {
        let tap :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func DismissKeyboard() {
        UIView.animate(withDuration: 0.4, animations: {
            self.agePickerBottom.constant = -205
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        view.endEditing(true)
        
    }
    
    
    
    //MARK:- ACTIONS
    
    
    @IBAction func passwrdInfoBtn(_ sender: Any) {
        if self.paswrdInfoView.alpha == 1{
            UIView.animate(withDuration: 0.7, delay: 0, options: .transitionCrossDissolve, animations: {
                self.paswrdInfoView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.7, delay: 0, options: .transitionCrossDissolve, animations: {
                self.paswrdInfoView.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func termsConditionBtnTapped(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
        vc.htmlString = htmlStringTC ?? ""
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func ActionAgeSelect(_ sender: Any) {
        pickerSelectedForAge = true
        MyPicker.reloadAllComponents()
        UIView.animate(withDuration: 0.4, animations: {
            self.agePickerBottom.constant = 0
            self.view.endEditing(true)
            self.ScrollView.contentOffset = CGPoint(x: 0, y: self.view.frame.height/2)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func AgePickerDoneItem(_ sender: Any) {
        if pickerSelectedForAge{
            AgeBtn.setTitle(age, for: .normal)
        }else{
             NotificationScedulingBtn.setTitle(SelectedNotificationSchedules, for: .normal)
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.agePickerBottom.constant = -205
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    @IBAction func NotificationScheduling(_ sender: Any) {
        pickerSelectedForAge = false
        MyPicker.reloadAllComponents()
        UIView.animate(withDuration: 0.4, animations: {
            self.agePickerBottom.constant = 0
            self.view.endEditing(true)
            self.ScrollView.contentOffset = CGPoint(x: 0, y: self.view.frame.height/2)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func eyeBtnTapped(_ sender: Any) {
        txtFieldPassword.isSecureTextEntry.toggle()
    }
    @IBAction func eyeBtnSignupPassTapped(_ sender: Any) {
        SignUptxtFieldPassword.isSecureTextEntry.toggle()
    }
    @IBAction func eyeBtnSignupConfirmPassTapped(_ sender: Any) {
        txtFieldConfirmPassword.isSecureTextEntry.toggle()
    }
    
    
    @IBAction func ForgotPasswordBtnTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "TransLife", message: "Please enter your email to get a password reset link", preferredStyle: .alert)
        alert.setValue(NSAttributedString(string:"TransLife", attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
        alert.addTextField { (textField) in
            textField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [
                .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
                .font: UIFont(name:"SegoeUI-Semibold", size: 15) as Any
                ])
            textField.keyboardType = .emailAddress
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            textField?.keyboardType = .emailAddress
            self.user.userForgotPassword(email: textField?.text ?? "n/a", view: self)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func UserSignIn(_ sender: Any) {
        guard let username = txtFieldUsername.text  else {
            return
        }
        guard let password = txtFieldPassword.text  else {
            return
        }
        let trimmedUsernameString = username.trimmingCharacters(in: .whitespaces)

        if (trimmedUsernameString.count == 0) || (password.count == 0){
            PresentAlert(message: "Please fill all fields.", title: "TransLife")
            
        }else{
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
            if trimmedUsernameString.rangeOfCharacter(from: characterset.inverted) != nil {
                 self.PresentAlert(message: "Username can't have any special character.", title: "TransLife")
            }else if CheckIfStringContainSpace(string: trimmedUsernameString) == false{
                self.PresentAlert(message: "Username should't have any spaces.", title: "TransLife")
            }else{
                if Reachability.isConnectedToNetwork(){
                user.SignInUser(username: trimmedUsernameString, password: password, view: self) { (result)  in
                    if auth.currentUser != nil{
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                        UIApplication.shared.keyWindow?.rootViewController = loginView
                    }else{
                        self.PresentAlert(message: "user does't exist", title: "TransLife")
                    }
                }
                }else{
                    self.PresentAlert(message: "Translife", title: "Please connect to cellular or Wi-Fi.")
                }
            }
        }
    }
    
    @IBAction func ConfirmPasswordsAreSame(_ sender: Any) {
        guard let password = SignUptxtFieldPassword.text  else {
            return
        }
        guard let confirmpassword = txtFieldConfirmPassword.text  else {
            return
        }
        if password != confirmpassword{
            PresentAlert(message: "Confirm your Password again.", title: "TransLife")
        }else{
            let isValid = isValidPassword(password:confirmpassword)
            if !isValid{
               AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.PresentAlert(message: "Please enter a valid password.", title: "Translife")
                UIView.animate(withDuration: 0.7, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.paswrdInfoView.alpha = 1
                    
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.paswrdInfoView.alpha = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    
    @IBAction func UserSignUp(_ sender: Any) {
        guard let username = SignUptxtFieldUsername.text  else {
            return
        }
        guard let password = SignUptxtFieldPassword.text  else {
            return
        }
        guard let emailTxt = txtFieldEmail.text?.lowercased()  else {
            return
        }
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if username.rangeOfCharacter(from: characterset.inverted) != nil {
            self.PresentAlert(message: "Username can't have any special character.(eg. '.' '#' '$' '[' or ']' '@' '#' '&')", title: "TransLife")
        }else if checkCharacterMinimumLength(textField: SignUptxtFieldUsername) == false{
            self.PresentAlert(message: "Username should be of atleast 3 character", title: "TransLife")
        }else if CheckIfStringContainSpace(string: username) == false{
            self.PresentAlert(message: "Username should't have any spaces.", title: "TransLife")
        }else if (SignUptxtFieldUsername.text?.count == 0) || (SignUptxtFieldPassword.text?.count == 0) || (txtFieldConfirmPassword.text?.count == 0) || (txtFieldEmail.text?.count == 0){
            PresentAlert(message: "Please fill all fields.", title: "TransLife")
        }else{
          
            if isValidEmail(testStr: emailTxt) == true{
                if age == "" || age == "Select" {
                    PresentAlert(message: "Please select your age.", title: "TransLife")
                }else{
                if termsAndCondition == true {
                    user.SignUpUser(username: username, email: emailTxt, password: password, Age: age, NotificationScheduling:SelectedNotificationSchedules, view: self) { (result) in
                        print(result)
                    }
                }else{
                    PresentAlert(message: "Please Agree to terms And Conditions.", title: "TransLife")
                }
                }
            }else{
                PresentAlert(message: "Please fill Valid Email Address.", title: "TransLife")
            }
        }
    }
    @IBAction func SignInTapped(_ sender: Any){
        
        self.agePickerBottom.constant = -205
        UIView.animate(withDuration: 0.5, animations: {
            self.SignUpBtn.alpha = 0.5
            self.SignINBtn.alpha = 1
            
            if self.SignUpViewLeading.constant == 0 {
                self.SignUpViewTrailing.constant = self.view.frame.width
                self.SignUpViewLeading.constant = self.view.frame.width
                self.SignInViewLeading.constant = 0
                self.SignInViewTrailing.constant = 0
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    @IBAction func SignUpTapped(_ sender: Any) {
        ScrollView.contentOffset = .zero
        
        UIView.animate(withDuration: 0.5, animations: {
            self.SignUpBtn.alpha = 1
            self.SignINBtn.alpha = 0.5
            if self.SignInViewLeading.constant == 0 {
                self.SignInViewLeading.constant = -self.view.frame.width
                self.SignInViewTrailing.constant = -self.view.frame.width
                self.SignUpViewLeading.constant = 0
                self.SignUpViewTrailing.constant = 0
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
    }
}
extension SignInVC : UIPickerViewDelegate,UIPickerViewDataSource{
    
    //MARK:PICKERVIEW DATASOURCE
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerSelectedForAge{
        return ageString.count
        }else{
          return NotificationSchedules.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerSelectedForAge{
        return ageString[row]
        }else{
           return NotificationSchedules[row]
        }
    }
    //MARK:PICKERVIEW DELEGATE
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerSelectedForAge{
        AgeBtn.setTitle(ageString[row], for: .normal)
        age = ageString[row]
        }else{
            NotificationScedulingBtn.setTitle(NotificationSchedules[row], for: .normal)
            SelectedNotificationSchedules = NotificationSchedules[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let textColor = hexStringToUIColor(hex: "#003644")
        if pickerSelectedForAge{
            age = ageString[row]
        return NSAttributedString(string: ageString[row], attributes: [NSAttributedString.Key.foregroundColor:textColor, NSAttributedString.Key.font : UIFont.fontNames(forFamilyName: "MuseoSans_500")])
        }else{
            SelectedNotificationSchedules = NotificationSchedules[row]
            return NSAttributedString(string: NotificationSchedules[row], attributes: [NSAttributedString.Key.foregroundColor:textColor, NSAttributedString.Key.font : UIFont.fontNames(forFamilyName: "MuseoSans_500")])
        }
    }
    
}

extension SignInVC:UITextFieldDelegate{
    //MARK:TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if SignUptxtFieldUsername.isEditing == true{
            SignUptxtFieldPassword.becomeFirstResponder()
        }else if SignUptxtFieldPassword.isEditing == true{
            txtFieldConfirmPassword.becomeFirstResponder()
        }else if txtFieldConfirmPassword.isEditing == true{
            txtFieldEmail.becomeFirstResponder()
        }else if txtFieldEmail.isEditing == true{
            txtFieldEmail.resignFirstResponder()
            AgeBtn.tintColor = UIColor.blue
        }else if txtFieldUsername.isEditing == true {
            txtFieldPassword.becomeFirstResponder()
        }else if txtFieldPassword.isEditing == true{
            txtFieldPassword.resignFirstResponder()
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if txtFieldPassword.isEditing == true{
            SignInPasswordEye.isHidden = false
        }else if SignUptxtFieldPassword.isEditing == true{
            SignUpPasswordEye.isHidden = false
        }else if txtFieldConfirmPassword.isEditing == true{
            SignUpconfirmPasswordEye.isHidden = false
        }
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
            SignInPasswordEye.isHidden = true
            SignUpPasswordEye.isHidden = true
            SignUpconfirmPasswordEye.isHidden = true
    }
    
    
}
