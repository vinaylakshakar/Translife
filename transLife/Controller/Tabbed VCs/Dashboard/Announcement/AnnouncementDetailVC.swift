//
//  AnnouncementDetailVC.swift
//  transLife
//
//  Created by Developer Silstone on 19/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class AnnouncementDetailVC: UIViewController {

    
    @IBOutlet weak var headingTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var AnnouncementName: UILabel!
    @IBOutlet weak var AnnouncementHeading: UITextView!
    @IBOutlet weak var ViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var AnnouncementDetail: UITextView!
    var announceDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        getAnnounceDetail()
        needToRefresh = true
    }
    
    func getAnnounceDetail()  {
        AnnouncementName.text = announceDict["announcement_name"] as? String
        AnnouncementHeading.text = announceDict["paragraph_heading"] as? String
        AnnouncementDetail.text = announceDict["announcement"] as? String
        ViewHeightCons.constant = AnnouncementDetail.contentSize.height + AnnouncementHeading.contentSize.height + 200
        headingTextViewHeight.constant = AnnouncementHeading.contentSize.height
    }

    
    // MARK: - ACTIONS

    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
