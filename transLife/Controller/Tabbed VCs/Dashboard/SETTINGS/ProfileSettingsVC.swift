//
//  ProfileSettingsVC.swift
//  transLife
//
//  Created by Developer Silstone on 21/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileSettingsVC: UIViewController {

    @IBOutlet weak var avatarCvcHeight: NSLayoutConstraint!
    var avatars = ["Group 472","Group 473","Group 474","Group 475","Group 476","Group 477","Group 478","Group 479","Group 480","Group 481","Group 482"]
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
   
    @IBOutlet weak var scrollView: UIScrollView!
    let user = Users()
    var profileImg = String()
    // MARK: - LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }
    override func viewWillAppear(_ animated: Bool) {
        setupProfile()
        getUserdetail()
        txtfieldPlaceholder()
    }
    
    func setupProfile() {
        profileAvatar.cornerRadiusV = 50
        self.avatarCvcHeight.constant = 0
        let img = UserDefaults.standard.value(forKey: "profile_avatar") as? String
//       if img != nil{
//           profileAvatar.image = UIImage(named:img ?? "image_placeholder")
//       }else{
        
            if let user = UserDefaults.standard.value(forKey: "username") as? String{
                ref.child("users").child(user).observeSingleEvent(of: .value) { (snap) in
                    if snap.value != nil{
                        let value = snap.value as! [String:AnyObject]
                        let avatar = value["avatar_name"] as? String
                        self.profileImg = avatar ?? "image_placeholder"
                        self.profileAvatar.image = UIImage(named:avatar ?? "image_placeholder")
                        UserDefaults.standard.set(avatar, forKey: "profile_avatar")
                    }
                }
            }
      // }
    }
    
    @IBAction func ChooseAvatarsAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.avatarCvcHeight.constant = self.view.frame.height - 240
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    @IBAction func ToolBarDoneAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.avatarCvcHeight.constant = 0
            self.view.layoutIfNeeded()

        }, completion: nil)
        if let user = UserDefaults.standard.value(forKey: "username") as? String{
            let currentUser = auth.currentUser?.uid
            ref.child("users").child(user).updateChildValues(["avatar_name" : profileImg])
            ref.child("usersChat").child(currentUser!).updateChildValues(["avatar_name" : profileImg])
            UserDefaults.standard.set(profileImg, forKey: "profile_avatar")
        }
        
    }
    @IBAction func ToolBarCancelAction(_ sender: Any) {
      //  profileAvatar.image = UIImage(named: "image_placeholder")
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.avatarCvcHeight.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
//        if let user = UserDefaults.standard.value(forKey: "username") as? String{
//             let currentUser = auth.currentUser?.uid
//            ref.child("users").child(user).updateChildValues(["avatar_name" : "image_placeholder"])
//            ref.child("usersChat").child(currentUser!).updateChildValues(["avatar_name" : "image_placeholder"])
//            UserDefaults.standard.set("image_placeholder", forKey: "profile_avatar")
//        }
        
    }
    
    @IBAction func UpdateUsernameAction(_ sender: Any) {
        guard let usernameTxt = UsernameTextField.text else {return}
        guard let userpasswordTxt = PasswordTextField.text else {return}

        if checkCharacterMinimumLength(textField: UsernameTextField) {
          
            if CheckIfStringContainSpace(string: usernameTxt){
                let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
                if usernameTxt.rangeOfCharacter(from: characterset.inverted) != nil {
                    self.PresentAlert(message: "Username can't have any special character.", title: "TransLife")
                }else{
               user.userChangeUsername(newusername: usernameTxt, password: userpasswordTxt, view: self)
                }
  
            }else{
                self.PresentAlert(message: "Username should't have any spaces.", title: "TransLife")
                SVProgressHUD.dismiss()
            }
        }else{
            self.PresentAlert(message: "Username should be of atleast 3 character", title: "TransLife")
            SVProgressHUD.dismiss()
        }
    }
    
    
    func getUserdetail(){
       
        UsernameTextField.text = UserDefaults.standard.value(forKey: "username") as? String
        
    }
    //MARK:- placeholder Attributes
    func txtfieldPlaceholder() {
     
        UsernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
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

    @IBAction func BackBtnAct(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
 
}
extension ProfileSettingsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return  avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileSettingCVCell", for: indexPath) as! ProfileSettingCVCell
        cell.avatarImg.image = UIImage(named: avatars[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        profileAvatar.image = UIImage(named: avatars[indexPath.row])
        profileImg = avatars[indexPath.row]
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionview.frame.width / 3 - 15
        return CGSize(width: width, height: width)
    }
    
}
