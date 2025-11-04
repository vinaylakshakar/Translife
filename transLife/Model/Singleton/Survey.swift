//
//  Survey.swift
//  transLife
//
//  Created by Silstone Group on 18/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import SVProgressHUD

class Survey: NSObject {
    
    func saveSurveyWith(Dict:[String:Any],view:UIViewController,surveyName:String)  {
        SVProgressHUD.show()
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
             let currentTimestamp = String(Int(Date().timeIntervalSince1970.rounded()))
    ref.child("surveys").child(username).child(surveyName).child(currentTimestamp).setValue(Dict) { (error, dataRef) in
                if error != nil{
                    view.PresentAlert(message: error?.localizedDescription ?? "transLife203" , title: "TransLife")
                    SVProgressHUD.dismiss()
                }else{
                    SVProgressHUD.dismiss()
                    ref.child("userSurveyDetail").child(username).child(surveyName).updateChildValues(["status":true])
                    // view.PresentAlert(message:"Baseline survey saved successfully" , title: "transLife")
                    // Create the alert controller
                    let alertController = UIAlertController(title: "TransLife", message: "\(surveyName) survey saved successfully", preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        view.navigationController?.popViewController(animated: true)
//                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                        let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
//                        UIApplication.shared.keyWindow?.rootViewController = loginView
                        
                        NSLog("OK Pressed")
                    }
                    let cancelAction = UIAlertAction(title: "Edit", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                  //  alertController.addAction(cancelAction)
                    
                    // Present the controller
                    view.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
