//
//  SettingsVC.swift
//  transLife
//
//  Created by Developer Silstone on 21/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CoreLocation

var isLocationOn = true
class SettingsVC: UIViewController,CLLocationManagerDelegate {
    
    let settingType = ["Profile Settings","Allow Location","Notification Settings","Change Password","Log out"]
    
    @IBOutlet weak var ActivityIndic: UIActivityIndicatorView!
   
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
     //self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    // MARK: - ACTIONS

    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - SWITCH BTN FOR ALLOWING LOCATION ACTION
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
            isLocationOn = value
    }
    //Mark user online
    func markUserOnline() {
        //make user online
        let usersRef = Database.database().reference(withPath: "usersChat")
        
        usersRef.observe(.value, with: { snapshot in
            
            for user in snapshot.children {
                let currentUser = User(snapshot: user as! DataSnapshot)
                
                if(currentUser.key == Auth.auth().currentUser?.uid){
                    currentUser.ref?.updateChildValues([
                        "online": true
                        ])
                    let currentUserRef = usersRef.child(currentUser.key)
                    currentUserRef.onDisconnectSetValue(currentUser.toOffline())
                    
                }
            }
            
        })
    }
}
extension SettingsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTVCell", for: indexPath) as! SettingsTVCell
        cell.settingTypeLbl.text = settingType[indexPath.row]
        cell.SwitchBtn.isHidden = true
        
        if indexPath.row == 1{
            cell.SwitchBtn.isHidden = false
            cell.SwitchBtn.isOn = isLocationOn
            cell.SwitchBtn.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
}
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            PushTo(FromVC: self, ToStoryboardID: "ProfileSettingsVC")
        }else   if indexPath.row == 1{
      
        
        }else   if indexPath.row == 2{
            PushTo(FromVC: self, ToStoryboardID: "NotificationsSettingVC")
        }else if indexPath.row == 3{
            PushTo(FromVC: self, ToStoryboardID: "ChangePasswordVC")
        }else if indexPath.row == 4{
                
                if Auth.auth().currentUser != nil{
                    let alertController = UIAlertController(title: "TransLife", message: "Sure you want to Log Out from transLife.", preferredStyle: .alert)
                    alertController.setValue(NSAttributedString(string:"TransLife", attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
                    let okAction = UIAlertAction(title: "Log Out", style: UIAlertAction.Style.destructive) {
                        UIAlertAction in
                        
                        // SVProgressHUD.show()
                        let currentuser = String(auth.currentUser!.uid)
                        
                    ref.child("usersChat").child(currentuser).updateChildValues(["online":false])
                        let firebaseAuth = Auth.auth()
                        //   DispatchQueue.global(qos: .default).async(execute: {
                        
                        do {
                            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                            UserDefaults.standard.synchronize()
                            try firebaseAuth.signOut()
                         
                            SVProgressHUD.dismiss()
                        } catch let signOutError as NSError {
                            self.PresentAlert(message: signOutError.localizedDescription, title: "TransLife")
                            print ("Error signing out: %@", signOutError.localizedDescription)
                        }
                        
                        //                    DispatchQueue.main.async(execute: {
                        //                        SVProgressHUD.show()
                        //                    })
                        //  })
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let loginView = storyboard.instantiateViewController(withIdentifier: "RootNav")
                        UIApplication.shared.keyWindow?.rootViewController = loginView
                        
                        NSLog("OK Pressed")
                        
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    self.PresentAlert(message: "You are already Logged out.", title: "TransLife")
                }
                
        }
    }
    
}
