//
//  ResourcesDocsVC.swift
//  transLife
//
//  Created by Developer Silstone on 19/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import SVProgressHUD


class ResourcesDocsVC: UIViewController {

    var resourceDetail:String?
    var resourceDescstring:String?
    var resourcetitlestring:String?
    @IBOutlet weak var ResourcesName: UILabel!
    @IBOutlet weak var ResourcesHeading: UITextView!
    @IBOutlet weak var ViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var ResourceDetail: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // DocsHeightCons.constant = self.view.frame.height - 110

        
    }
     // MARK: - pdf showing
//    func ShowPdf()  {
//       SVProgressHUD.show()
//        myWebView.navigationDelegate = self
//        resourceTitle.text = resourcetitlestring
//        let Url = URL(string: urlString ?? "eds")
//        if Url != nil{
//            let urlRequest = URLRequest.init(url:Url!)
//            self.myWebView.load(urlRequest)
//        }else{
//            SVProgressHUD.dismiss()
//            self.PresentAlert(message: "Pdf not found !", title: "TransLife")
//        }
//
//    }
    override func viewWillAppear(_ animated: Bool) {
        
        setupUI()
        
    }
    
    func setupUI()  {
        needRefreshResource = false
        self.ResourcesName.text = resourcetitlestring
        self.ResourcesHeading.text = resourceDescstring
        self.ResourceDetail.text = resourceDetail
        ViewHeightCons.constant = ResourceDetail.contentSize.height + ResourcesHeading.contentSize.height + 200
        textViewHeightCons.constant = ResourcesHeading.contentSize.height
    }
   
    // MARK: - ACTIONS
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
