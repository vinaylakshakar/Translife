//
//  OnBoarding.swift
//  transLife
//
//  Created by Developer Silstone on 02/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class OnBoarding: NSObject {

    func createNewBaselineSurvey(Dict:[String:Any],view:UIViewController) {
        SVProgressHUD.show()
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
            let currentTimestamp = String(Int(Date().timeIntervalSince1970.rounded()))
        ref.child("onboarding").child(username).child(currentTimestamp).setValue(Dict) { (error, dataRef) in
            if error != nil{
                view.PresentAlert(message: error?.localizedDescription ?? "transLife203" , title: "TransLife")
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.dismiss()
                ref.child("userSurveyDetail").child(username).child("Baseline survey").updateChildValues(["status":true])
               // view.PresentAlert(message:"Baseline survey saved successfully" , title: "transLife")
                // Create the alert controller
                let alertController = UIAlertController(title: "TransLife", message: "Baseline survey saved successfully.", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = loginView

                   
                    NSLog("OK Pressed")
                }
                let cancelAction = UIAlertAction(title: "Edit", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                view.present(alertController, animated: true, completion: nil)
            }
           
        }
    }
}
  
    
}
