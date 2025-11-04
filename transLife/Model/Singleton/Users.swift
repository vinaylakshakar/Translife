//
//  Users.swift
//  transLife
//
//  Created by Developer Silstone on 31/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

var FcmToken = ""
let ref = Database.database().reference()
let auth = Auth.auth()
let announce = Announcements()
let userUID = auth.currentUser?.uid
var userData = NSDictionary()
typealias Completion = (Error?) -> Void
class Users: NSObject {
    
    func getUser(user:String) -> NSDictionary {
        if auth.currentUser != nil{
            ref.child("users").child(user).observeSingleEvent(of: .value) { (snap) in
                userData = snap.value as! NSDictionary
            }
        }
        return userData
    }
    
    func SignInUser(username:String,password:String,view:UIViewController,completionHandler: @escaping (_ authResult: Any) -> Void) {
        SVProgressHUD.show()
        ref.child("users").child(username).observeSingleEvent(of: .value) { (snap) in
            if  let userDict = snap.value as? [String:Any] {
                if let userEmail = userDict["Email"] {
                    if let FCM_TOKEN = UserDefaults.standard.value(forKey: "fcm_token"){
                        FcmToken = FCM_TOKEN as! String
                ref.child("users").child(username).updateChildValues(["fcm_token":FcmToken])
                    }
                    
                    auth.signIn(withEmail: userEmail as! String, password: password) { (authResult, error) in
                    if error != nil{
                        view.PresentAlert(message: error?.localizedDescription ?? "error", title: "TransLife")
                        SVProgressHUD.dismiss()
                    }else{
                        ref.child("users/\(username)").updateChildValues(["Password" : password])
                        ref.child("users/\(username)").observeSingleEvent(of: .value, with: { (snap) in
                            print(snap)
                            let userDetail = snap.value as! NSDictionary
                            let useremail = userDetail["Email"] as? String
                            UserDefaults.standard.setValue(useremail, forKey: "useremail")
                            UserDefaults.standard.setValue(username, forKey: "username")
                            UserDefaults.standard.setValue(password, forKey: "userpassword")
                            UserDefaults.standard.synchronize()
                        })

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
                        SVProgressHUD.dismiss()
                        
                      
                        // PushTo(FromVC: view, ToStoryboardID: "OnboardingSurveyVC")
                     
                    }
                    
                    completionHandler(authResult as Any)
                    }
                    
                }else{
                    SVProgressHUD.dismiss()
                    view.PresentAlert(message: "Email not found in database. please register again.", title: "TransLife")
                }
            }else{
                SVProgressHUD.dismiss()
                view.PresentAlert(message: "Username does't exist.", title: "TransLife")
            }
        }
    }
    
    func SignUpUser(username:String,email:String,password:String,Age:String,NotificationScheduling:String,view:UIViewController,completionHandler: @escaping (_ authResult: Any) -> Void) {
        SVProgressHUD.show()
        if let FCM_TOKEN = UserDefaults.standard.value(forKey: "fcm_token"){
            FcmToken = FCM_TOKEN as! String
        }
        //ref.child("users").child("users").setValue(["username":"","device_token":DeviceToken,"Password":"","Email":""])
        ref.child("users").observeSingleEvent(of: .value, with: { (snap) in
         
            if snap.value is NSNull{
                auth.createUser(withEmail: email, password: password) { (authResult, error) in
                    if error != nil{
                        view.PresentAlert(message: error?.localizedDescription ?? "error", title: "TransLife")
                        SVProgressHUD.dismiss()
                    }else{
                        guard let user = authResult?.user else { return }
                        if let FCM_TOKEN = UserDefaults.standard.value(forKey: "fcm_token"){
                            FcmToken = FCM_TOKEN as! String
                        }
                        self.setUserfirebaseProfile(nameField:username)
                        self.makeUserOnline(emailField:email, passwordField:password)
                        ref.child("users").child(username).setValue(["fcm_token": FcmToken,"Email":email,"Password":password,"Age":Age,"username":username,"flag":false,"NotificationScheduling":NotificationScheduling], withCompletionBlock: { (error, databaseref) in
                            if error != nil{
                                view.PresentAlert(message: error?.localizedDescription ?? "error", title: "TransLife")
                                SVProgressHUD.dismiss()
                            }else{
                                
                                UserDefaults.standard.setValue(email, forKey: "useremail")
                                UserDefaults.standard.setValue(username, forKey: "username")
                                UserDefaults.standard.setValue(password, forKey: "userpassword")
                                UserDefaults.standard.synchronize()
                                ref.child("notifications_handling").child(username).setValue(["status_all_notifications":true,"status_pending_surveys_notifications":true,"status_new_surveys_notifications":true,"status_mood_notifications":true,"status_qotd_notifications":true,"status_events_notifications":true])
                                
                                //                                UserDefaults.standard.removeObject(forKey: "userDefaultHaveSurveyData")
                                //                                UserDefaults.standard.removeObject(forKey: "userhasloggedmood")
                                //                                UserDefaults.standard.synchronize()
                                //MARK: For Testing Purpose: SAVING ANNOUNCEMENTS TO CURRENT USER DB's userAnnouncementDetail
                                ref.child("Announcements").observeSingleEvent(of: .value, with: { (snap) in
                                    if snap.value is NSNull{
                                        
                                    }else{
                                        let snapValue = snap.value as! [String:Any]
                                        for i in snapValue{
                                            let snapKey = i.key
                                            ref.child("userAnnouncementDetail").child(username).child(snapKey).setValue(["readStatus":false]) { (error, dataRef) in
                                                if let error = error{
                                                    view.PresentAlert(message: error.localizedDescription, title: "TransLife")
                                                }
                                            }
                                        }
                                    }
                                    
                                })
                                //MARK: For Testing Purpose: SAVING userSurveystatus TO CURRENT USER DB's userSurveyDetail
                                let currentTimestamp = Int(Date().timeIntervalSince1970)
                                let Dict = ["Current Trans Experience":["currentTimeStamp":10000 + currentTimestamp,"status":true,"surveyName":"Current Trans Experience","type":"non mandatory",],"Demographics":["currentTimeStamp":20000 + currentTimestamp,"status":true,"surveyName":"Demographics","type":"non mandatory",],"Trans related discrimination":["currentTimeStamp":30000 + currentTimestamp,"status":true,"surveyName":"Trans related discrimination","type":"non mandatory",],"Trans visibility and support":["currentTimeStamp":40000 + currentTimestamp,"status":true,"surveyName":"Trans visibility and support","type":"non mandatory",],"Medical surgical transition":["currentTimeStamp":50000 + currentTimestamp,"status":true,"surveyName":"Medical/surgical transition","type":"non mandatory",],"Baseline survey":["currentTimeStamp":currentTimestamp,"status":true,"surveyName":"Baseline survey","type":"mandatory",]]
                                ref.child("userSurveyDetail").child(username).setValue(Dict, withCompletionBlock: { (error, dataRef) in
                                    if let error = error{
                                        view.PresentAlert(message: error.localizedDescription, title: "transLife")
                                    }
                                })
                                
                                
                            }
                        })
                        PushTo(FromVC: view, ToStoryboardID: "OnboardingSurveyVC")
                        SVProgressHUD.dismiss()
                    }
                    completionHandler(authResult as Any)
                }
                
            }else{
            let snapvalue = snap.value as! [String:Any]
            let snapkey = snapvalue.keys
            if snapkey.contains(username){
                view.PresentAlert(message:"username is already in use!\n please choose a unique one.", title: "TransLife")
                SVProgressHUD.dismiss()
            }else{
                auth.createUser(withEmail: email, password: password) { (authResult, error) in
                    if error != nil{
                        view.PresentAlert(message: error?.localizedDescription ?? "error", title: "TransLife")
                        SVProgressHUD.dismiss()
                    }else{
                        guard let user = authResult?.user else { return }
                        if let FCM_TOKEN = UserDefaults.standard.value(forKey: "fcm_token"){
                            FcmToken = FCM_TOKEN as! String
                        }
                       
                        self.setUserfirebaseProfile(nameField:username)
                        self.makeUserOnline(emailField:email, passwordField:password)
                        ref.child("users").child(username).setValue(["fcm_token": FcmToken,"Email":email,"Password":password,"Age":Age,"username":username,"flag":false,"NotificationScheduling":NotificationScheduling], withCompletionBlock: { (error, databaseref) in
                            if error != nil{
                                view.PresentAlert(message: error?.localizedDescription ?? "error", title: "TransLife")
                                SVProgressHUD.dismiss()
                            }else{
                                
                                UserDefaults.standard.setValue(email, forKey: "useremail")
                                UserDefaults.standard.setValue(username, forKey: "username")
                                UserDefaults.standard.setValue(password, forKey: "userpassword")
                                UserDefaults.standard.synchronize()
                                ref.child("notifications_handling").child(username).setValue(["status_all_notifications":true,"status_pending_surveys_notifications":true,"status_new_surveys_notifications":true,"status_mood_notifications":true,"status_qotd_notifications":true,"status_events_notifications":true])
                                
//                                UserDefaults.standard.removeObject(forKey: "userDefaultHaveSurveyData")
//                                UserDefaults.standard.removeObject(forKey: "userhasloggedmood")
//                                UserDefaults.standard.synchronize()
                                //MARK: For Testing Purpose: SAVING ANNOUNCEMENTS TO CURRENT USER DB's userAnnouncementDetail
                                ref.child("Announcements").observeSingleEvent(of: .value, with: { (snap) in
                                    if snap.value is NSNull{
                                        
                                    }else{
                                        let snapValue = snap.value as! [String:Any]
                                        for i in snapValue{
                                            let snapKey = i.key
                                            ref.child("userAnnouncementDetail").child(username).child(snapKey).setValue(["readStatus":false]) { (error, dataRef) in
                                                if let error = error{
                                                    view.PresentAlert(message: error.localizedDescription, title: "TransLife")
                                                }
                                            }
                                        }
                                    }
                                   
                                })
                               //MARK: For Testing Purpose: SAVING userSurveystatus TO CURRENT USER DB's userSurveyDetail
                                let currentTimestamp = Int(Date().timeIntervalSince1970)
                                let Dict = ["Current Trans Experience":["currentTimeStamp":10000 + currentTimestamp,"status":true,"surveyName":"Current Trans Experience","type":"non mandatory",],"Demographics":["currentTimeStamp":20000 + currentTimestamp,"status":true,"surveyName":"Demographics","type":"non mandatory",],"Trans related discrimination":["currentTimeStamp":30000 + currentTimestamp,"status":true,"surveyName":"Trans related discrimination","type":"non mandatory",],"Trans visibility and support":["currentTimeStamp":40000 + currentTimestamp,"status":true,"surveyName":"Trans visibility and support","type":"non mandatory",],"Medical surgical transition":["currentTimeStamp":50000 + currentTimestamp,"status":true,"surveyName":"Medical/surgical transition","type":"non mandatory",],"Baseline survey":["currentTimeStamp":currentTimestamp,"status":true,"surveyName":"Baseline survey","type":"mandatory",]]
                                ref.child("userSurveyDetail").child(username).setValue(Dict, withCompletionBlock: { (error, dataRef) in
                                    if let error = error{
                                        view.PresentAlert(message: error.localizedDescription, title: "TransLife")
                                    }
                                })
                           
                                
                            }
                        })
                        PushTo(FromVC: view, ToStoryboardID: "OnboardingSurveyVC")
                        SVProgressHUD.dismiss()
                    }
                    completionHandler(authResult as Any)
                }
                
            }
            }
        })
    }
    
    func userForgotPassword(email:String,view:UIViewController) {
        SVProgressHUD.show()
        auth.sendPasswordReset(withEmail: email , completion: { (error) in
            if error != nil {
                view.PresentAlert(message: error?.localizedDescription ?? "error tranLife52", title: "TransLife")
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.dismiss()
            }
        })
    }
    func userChangeUsername(newusername:String,password:String,view:UIViewController) {
        SVProgressHUD.show()
        if let existusername = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("users").observeSingleEvent(of: .value, with: { (snap) in
                let snapvalue = snap.value as! [String:Any]
                let snapkey = snapvalue.keys
                if snapkey.contains(newusername){
                    view.PresentAlert(message:"username is already in use!\n please choose a unique one.", title: "TransLife")
                    SVProgressHUD.dismiss()
                }else{
        ref.child("users").child(existusername).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.value is NSNull{
            }else{
            let snap = snapshot.value as! [String:AnyObject]
            let userpassword = snap["Password"] as! String
                
            
            if userpassword == password{
                ref.observeSingleEvent(of: .value) { (DataSnapshot) in
                    
                    let snapValue = DataSnapshot.value as! [String:AnyObject]
                    for i in snapValue{
                        let invalue = i.value as! [String:AnyObject]
                        for n in invalue{
                            if existusername == n.key{
                                ref.child(i.key).child(newusername).setValue(n.value, withCompletionBlock: { (error, DatabaseReference) in
                                    if let error = error{
                                        view.PresentAlert(message: error.localizedDescription, title: "TransLife")
                                        SVProgressHUD.dismiss()
                                    }else{
                    ref.child("users").child(newusername).updateChildValues(["username":newusername])
                                             UserDefaults.standard.set(newusername, forKey: "username")
                                        ref.child(i.key).child(n.key).removeValue()
                                        view.PresentAlert(message: "Username updated successfully", title: "TransLife")
                                        SVProgressHUD.dismiss()
                                    }
                                })
                            }
                        }
                    }
                }
            }else{
                view.PresentAlert(message: "Please enter correct password to update username.", title: "TransLife")
                SVProgressHUD.dismiss()
            }
            }
        }
                }
            })
        }
    }
    
    func changePassword(email: String, currentPassword: String, newPassword: String,view:UIViewController, completion: @escaping Completion) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        auth.currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { (authResult, error) in
            if let error = error{
                completion(error)
            }else{
                auth.currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    completion(error)
                    
                })
            }
        })
    }
    
    // methods to save user as chat owner
    func setUserfirebaseProfile(nameField:String){
    
    //save the name
        let user = Auth.auth().currentUser
    if let user = user {
        let changeRequest = user.createProfileChangeRequest()
    
    changeRequest.displayName = nameField
    changeRequest.photoURL =
    NSURL(string: "http://www.freeiconspng.com/uploads/profile-icon-9.png") as URL?
    changeRequest.commitChanges { error in
    if error != nil {
    // An error happened.
    } else {
    
    }
    }
    
        let usersRef = Database.database().reference(withPath: "usersChat")
    
    let currentUser = User(key: (user.uid), name: nameField, online: false,avatar:"image_placeholder")
    let currentUserRef = usersRef.child((user.uid))
    currentUserRef.setValue(currentUser.toAnyObject())
    
    // sign in the user
   // self.signIn(emailField.text!, passwordField: passwordField.text!)
       
    }
    
    
    }
    
    func makeUserOnline(emailField:String, passwordField:String){
        auth.signIn(withEmail: emailField, password: passwordField) { (authresult, error) in
            
            if error != nil{
                
            }else{
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
    }
    
}
