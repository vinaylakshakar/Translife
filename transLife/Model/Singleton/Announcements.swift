//
//  Announcements.swift
//  transLife
//
//  Created by Developer Silstone on 01/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class Announcements: NSObject {

    
    func getAnnouncements(view:UIViewController,completionHandler: @escaping (_ snap: DataSnapshot) -> Void)  {
        ref.child("Announcements").observeSingleEvent(of: .value) { (snap) in
            completionHandler(snap)
        }
        
        
    }
}
