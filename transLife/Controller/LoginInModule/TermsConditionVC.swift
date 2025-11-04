//
//  TermsConditionVC.swift
//  transLife
//
//  Created by Silstone Group on 13/05/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class TermsConditionVC: UIViewController,WKNavigationDelegate {

    var htmlString = ""
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    @IBOutlet weak var TxtViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TCImage: UIButton!
    @IBOutlet weak var RadioBtnImg: UIImageView!
    @IBOutlet weak var myWebView: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   // gettermconditionAdmin()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getTC(notification:)), name: NSNotification.Name(rawValue: "termsandcondition"), object: nil)
        
        
        //addObserver(self, selector: #selector(self.getTC(notification:)), name:NSNotification.Name(rawValue: "termsandcondition"), object: nil)
    }
    
    @objc private func getTC(notification: NSNotification) {
        print("NSNotification reci")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.myWebView.loadHTMLString(self.htmlString, baseURL: nil)
        if termsAndCondition == false{
            RadioBtnImg.image = #imageLiteral(resourceName: "radio button_unselected")
        }else{
            RadioBtnImg.image = #imageLiteral(resourceName: "radio_button_selected")
        }
    }

    @IBAction func termsAgreebtn(_ sender: Any) {
        if RadioBtnImg.image == #imageLiteral(resourceName: "radio_button_selected"){
            RadioBtnImg.image = #imageLiteral(resourceName: "radio button_unselected")
            termsAndCondition = false
        }else{
            RadioBtnImg.image = #imageLiteral(resourceName: "radio_button_selected")
            termsAndCondition = true
        }
    }
    
    @IBAction func BackBtnAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popViewController(animated: false)
    }
    
}
