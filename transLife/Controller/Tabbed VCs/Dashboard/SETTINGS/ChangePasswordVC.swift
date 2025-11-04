//
//  ChangePasswordVC.swift
//  transLife
//
//  Created by Developer Silstone on 02/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var CurrentPassword: UITextField!
    @IBOutlet weak var newPasswordTxtField: UITextField!
     @IBOutlet weak var ReTypePasswordTxtField: UITextField!
    @IBOutlet weak var eyeBtnOldPass: UIButton!
    @IBOutlet weak var eyeBtnNewPass: UIButton!
    @IBOutlet weak var eyeBtnConfirmPass: UIButton!
     @IBOutlet weak var paswrdInfoView: UIView!
    var users = Users()
    override func viewDidLoad() {
        super.viewDidLoad()
        paswrdInfoView.alpha = 0
        eyeBtnOldPass.isHidden = true
        eyeBtnNewPass.isHidden = true
        eyeBtnConfirmPass.isHidden = true
        handleTxtFldPlaceholder()
        HideKeyboard()
    }
    
    func handleTxtFldPlaceholder() {
        CurrentPassword.attributedPlaceholder = NSAttributedString(string: "Current Password", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        newPasswordTxtField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        ReTypePasswordTxtField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])

    }
    
    func HideKeyboard() {
        let tap :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - ACTIONS
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
    @IBAction func eyeBtnOldPassTapped(_ sender: Any) {
        
        CurrentPassword.isSecureTextEntry.toggle()
    }
    @IBAction func eyeBtnNewPassTapped(_ sender: Any) {
        newPasswordTxtField.isSecureTextEntry.toggle()
    }
    @IBAction func eyeBtnConfirmPassTapped(_ sender: Any) {
        ReTypePasswordTxtField.isSecureTextEntry.toggle()
    }

    @IBAction func BackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func UpdatePasswordActions(_ sender: Any) {
        
        let email = UserDefaults.standard.value(forKey: "useremail") as? String
        let username = UserDefaults.standard.value(forKey: "username") as? String
        guard let oldPassword = CurrentPassword.text else{return}
        guard let newPassword = newPasswordTxtField.text else{return}
        guard let retypePassword = ReTypePasswordTxtField.text else{return}
        if newPassword.count != 0 || retypePassword.count != 0{
            if newPassword == retypePassword{
                let isValid = isValidPassword(password:retypePassword)
                if !isValid{
                    UIView.animate(withDuration: 0.7, delay: 0, options: .transitionCrossDissolve, animations: {
                        self.paswrdInfoView.alpha = 1
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }else{
                    UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                        self.paswrdInfoView.alpha = 0
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                SVProgressHUD.show()
                users.changePassword(email: email ?? "sdcs", currentPassword: oldPassword , newPassword: retypePassword, view: self) { (error) in
                    if error != nil{
                        SVProgressHUD.dismiss()
                        self.PresentAlert(message: error?.localizedDescription ?? "transLife103", title: "TransLife")
                    }else{
                        ref.child("users").child(username ?? "cscs").updateChildValues(["Password":retypePassword], withCompletionBlock: { (error, ref) in
                            if let error = error{
                                SVProgressHUD.dismiss()
                                self.PresentAlert(message: error.localizedDescription, title: "TransLife")
                            }else{
                                UserDefaults.standard.setValue(retypePassword, forKey: "userpassword")
                                SVProgressHUD.dismiss()
                                
                                let alertController = UIAlertController(title: "TransLife", message: "Password updated successfully! \n please sign in again with new password.", preferredStyle: .alert)
                                alertController.setValue(NSAttributedString(string:"TransLife", attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
                                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    self.navigationController?.popViewController(animated: true)

                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
                       
                    }
                }
            }
            }else{
                self.PresentAlert(message:"please enter same password.", title: "TransLife")
            }
        }else{
            self.PresentAlert(message:"please enter password.", title: "TransLife")
        }
    }
}
extension ChangePasswordVC:UITextFieldDelegate{
    //MARK:TEXTFIELD DELEGATE

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if CurrentPassword.isEditing == true{
            eyeBtnOldPass.isHidden = false
        }else if newPasswordTxtField.isEditing == true{
            eyeBtnNewPass.isHidden = false
        }else if ReTypePasswordTxtField.isEditing == true{
            eyeBtnConfirmPass.isHidden = false
        }
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        eyeBtnOldPass.isHidden = true
        eyeBtnNewPass.isHidden = true
        eyeBtnConfirmPass.isHidden = true
    }
    
    
}

