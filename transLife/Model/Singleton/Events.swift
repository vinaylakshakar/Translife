//
//  Events.swift
//  transLife
//
//  Created by Silstone Group on 07/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class Events: NSObject {
    
    func createEvent(Dict:[String:Any],view:UIViewController,completionHandler: @escaping (_ dataRef: DatabaseReference) -> Void) {
        SVProgressHUD.show()
       
        ref.child("Events").childByAutoId().setValue(Dict) { (error, dataRef) in
            if error != nil{
                view.PresentAlert(message: error?.localizedDescription ?? "transLife203" , title: "TransLife")
                SVProgressHUD.dismiss()
            }else{
                
                
            }
            completionHandler(dataRef)
        }
    }
    
    func GetEvents(view:UIViewController,completionHandler: @escaping (_ snap: DataSnapshot) -> Void)  {
        ref.child("Events").observeSingleEvent(of: .value, with: { (snap) in
            
            completionHandler(snap)
        })
    }
    
    func saveImgToStorage(ImgId:String,image:UIImage,view:UIViewController,completion: @escaping (_ metadata: StorageMetadata?) -> Void) {
        SVProgressHUD.show()
        let storageRef = Storage.storage().reference().child("EventImages/\(ImgId).png")
        if let uploadData = image.pngData() {
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    print(error?.localizedDescription ?? "translife304")
                    completion(nil)
                }else{
                    let alertController = UIAlertController(title: "TransLife", message: "Event created successfully", preferredStyle: .alert)
                    alertController.setValue(NSAttributedString(string:"TransLife", attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        view.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshingEventView"), object: nil)
                        NSLog("OK Pressed")
                    }
                    let cancelAction = UIAlertAction(title: "Edit", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    // alertController.addAction(cancelAction)
                    
                    // Present the controller
                    view.present(alertController, animated: true, completion: nil)
                    // view.PresentAlert(message:"Event created successfully" , title: "TransLife")
                    SVProgressHUD.dismiss()
                }
                completion(metadata)
            }
        }
    }
}
