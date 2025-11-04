//
//  AnnouncementsVC.swift
//  transLife
//
//  Created by Developer Silstone on 17/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
class AnnouncementsVC: UIViewController {
    
    var allAnnouncements = [NSDictionary]()
    var announceDict:NSDictionary?
    var keys = [String]()
    let announce = Announcements()
    var readStatus = false
    @IBOutlet weak var tableVIEW: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userID = auth.currentUser?.uid else{return}
        print(userID)
        getAnnouncements()
    }
    //MARK:ACTIONS
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func getAnnouncements() {
        SVProgressHUD.show()
        announce.getAnnouncements(view: self) { (snap) in
            if snap.value is NSNull{
                SVProgressHUD.dismiss()
                self.tableVIEW.reloadData()
                self.PresentAlert(message: "No published announcement.", title: "TransLife")
            }else{
                let snapValue = snap.value  as! NSDictionary
                var nsDict = [NSDictionary]()
                for i in snapValue{
                    nsDict.append(i.value as! NSDictionary)
                    self.keys.append(i.key as! String)
                }
                self.allAnnouncements =  nsDict
                self.allAnnouncements =  nsDict.sorted(by: { $0["timestamp"] as! Double > $1["timestamp"] as! Double})
                self.tableVIEW.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
}
extension AnnouncementsVC:UITableViewDelegate,UITableViewDataSource{
    //MARK:TABLEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAnnouncements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTVCell", for: indexPath) as! AnnouncementTVCell
        cell.AnnouncementName.text = allAnnouncements[indexPath.row]["announcement_name"] as? String
        cell.Description.text = allAnnouncements[indexPath.row]["paragraph_heading"] as? String
        let AnnouncementID = keys[indexPath.row]
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("userAnnouncementDetail").child(username).child(AnnouncementID).observeSingleEvent(of: .value) { (snap) in
                if snap.value is NSNull{
                    cell.alertImg.isHidden = false
                }else{
                    let snap = snap.value as! [String:Any]
                    self.readStatus = snap["readStatus"] as! Bool
                    if self.readStatus == true{
                        cell.alertImg.isHidden = true
                    }else{
                        cell.alertImg.isHidden = false
                    }
                }
            }
        }
        return cell
    }
    //MARK:TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let AnnouncementID = keys[indexPath.row]
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
            ref.child("userAnnouncementDetail").child(username).child(AnnouncementID).setValue(["readStatus":true]) { (error, dataRef) in
                if let error = error{
                    self.PresentAlert(message: error.localizedDescription, title: "TransLife")
                }
            }
        }
        self.tableVIEW.reloadData()
        let vc = storyboard?.instantiateViewController(withIdentifier: "AnnouncementDetailVC") as! AnnouncementDetailVC
        vc.announceDict = allAnnouncements[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
