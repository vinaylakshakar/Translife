//
//  MoodLog.swift
//  transLife
//
//  Created by Silstone Group on 14/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase

class MoodLog: NSObject {
    
    func SaveMoodLogWith(Dict:[String:Any],view:UIViewController,completion: @escaping (_ error: Error?, _ dataRef:DatabaseReference) -> Void)  {
        if let CurrentUser = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("UserMoodLog").child(CurrentUser).childByAutoId().updateChildValues(Dict) { (error, dataRef) in
                completion(error, dataRef)
            }
            
        }

    }
    
    func GetUserMoodLog(view:UIViewController,completionHandler: @escaping (_ snap: DataSnapshot) -> Void) {
        if let CurrentUser = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("UserMoodLog").child(CurrentUser).observeSingleEvent(of: .value, with: { (snap) in
                    completionHandler(snap)
                })
            }
         
            
        }
    }


