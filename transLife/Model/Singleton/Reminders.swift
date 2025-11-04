//
//  Reminders.swift
//  transLife
//
//  Created by Silstone on 13/11/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class Reminders: NSObject {

    func CreateReminders(Dict:[String:Any],view:UIViewController,completion: @escaping (_ error: Error?, _ dataRef:DatabaseReference) -> Void)  {
        SVProgressHUD.show()
        if let CurrentUser = UserDefaults.standard.value(forKey: "username") as? String{
       ref.child("UserReminders").child(CurrentUser).childByAutoId().updateChildValues(Dict) { (error, dataRef) in
         
                completion(error, dataRef)
            }
        }
    }
    
    func GetReminders(view:UIViewController,completionHandler: @escaping (_ snap: DataSnapshot) -> Void) {
        if let CurrentUser = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("UserReminders").child(CurrentUser).observeSingleEvent(of: .value, with: { (snap) in
                    completionHandler(snap)
                })
            }
        }
}
