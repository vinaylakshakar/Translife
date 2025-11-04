//
//  QuestionOfTheDay.swift
//  transLife
//
//  Created by Silstone Group on 10/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class QuestionOfTheDay: NSObject {
    
   
    func GetQuestion(view:UIViewController,completionHandler: @escaping (_ snap: DataSnapshot) -> Void)  {
        ref.child("QuestionOfTheDay").observeSingleEvent(of: .value) { (snap) in
            completionHandler(snap)
        }
    }
    
    func userAnswerForDailyQues(dict:[String:AnyObject],view:UIViewController,completionHandler: @escaping (_ dataRef: DatabaseReference) -> Void) {
        if let CurrentUser = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("UsersAnswerForDailyQuestion").child(CurrentUser).updateChildValues(dict) { (error, dataRef) in
                if error != nil{
                    view.PresentAlert(message: error?.localizedDescription ?? "transLife 03" , title: "TransLife")
                    SVProgressHUD.dismiss()
                }else{
                    
                    
                }
                completionHandler(dataRef)
            }
        }
    }
    func GetAllAnswersOfCommunity(view:UIViewController,completionHandler: @escaping (_ snap: DataSnapshot)-> Void) {
        ref.child("UsersAnswerForDailyQuestion").observeSingleEvent(of:.value) { (snap) in
            
            completionHandler(snap)
        }
    }
}
