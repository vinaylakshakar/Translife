//
//  Resources.swift
//  transLife
//
//  Created by Silstone Group on 28/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase

class Resources: NSObject {

    func GetResorcesFiles(view:UIViewController,completionHandler: @escaping (_ snap: DataSnapshot) -> Void)  {
        ref.child("Resources").observeSingleEvent(of: .value, with: { (snap) in
            
            completionHandler(snap)
        })
    }
}
