//
//  EventsListVC.swift
//  transLife
//
//  Created by Developer Silstone on 17/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

var needrefreshforEvents = true
class EventsListVC: UIViewController {

    //MARK: FOR TRANSITION ANIMATION
    fileprivate var selectedCell: UITableViewCell?
    
    @IBOutlet weak var myTableView: UITableView!
    let events = Events()
    var eventBottomViewColor = ["#02A452","#FF2D2C","#0EAFDB"]
    var getEvents = [NSDictionary]()
    var allEvents = [AnyObject]()
    var cellHeightsDictionary: [AnyHashable : Any] = [:]
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshingEventView(notification:)), name:NSNotification.Name(rawValue: "refreshingEventView"), object: nil)
        self.navigationController?.navigationBar.isHidden = true
     //  SVProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if needrefreshforEvents == true{
            GettingEvents()
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom:25, right: 0)
        self.myTableView.contentInset = insets
    }
    
    @objc func refreshingEventView(notification: NSNotification) {
        if needrefreshforEvents == true{
                   GettingEvents()
               }
               let insets = UIEdgeInsets(top: 0, left: 0, bottom:25, right: 0)
               self.myTableView.contentInset = insets
    }
    //MARK:GETTING EVENTS
    func GettingEvents() {
       
        SVProgressHUD.show()
        self.allEvents.removeAll()
        self.getEvents.removeAll()
        events.GetEvents(view: self) { (snap) in
            if snap.value is NSNull{
                self.myTableView.delegate = self
                self.myTableView.dataSource = self
                self.myTableView.reloadData()
                SVProgressHUD.dismiss()
                self.PresentAlert(message: "No Scheduled Events ", title: "TransLife")
            }else{
                let snapValue = snap.value as! [String:AnyObject]
                for i in snapValue{
                    let alldata = i.value as! NSDictionary
                    let timestamp = alldata["EventTimeStamp"] as? Double
                    let today = Date().timeIntervalSince1970
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-mm-dd"//Set time style
                    if today <= timestamp ?? -65000 + 65000 {
                        self.getEvents.append(alldata)
                    }
                }
                let sortedArr =  self.getEvents.sorted(by: { $0["EventTimeStamp"] as! Double > $1["EventTimeStamp"] as! Double })
                self.allEvents = sortedArr.reversed()
                
                DispatchQueue.main.async(execute: {
                    self.myTableView.delegate = self
                    self.myTableView.dataSource = self
                    self.myTableView.reloadData()
                })
                
                SVProgressHUD.dismiss()
            }
        }
    }
    //ACTIONS
    
    @IBAction func BackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func AddBtnAction(_ sender: Any) {
        PresentTo(FromVC: self, ToStoryboardID: "AddEventsVC")
   
    }

 

}
extension EventsListVC:UITableViewDataSource,UITableViewDelegate{
    //MARK:TABLEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsListTVCell", for: indexPath) as! EventsListTVCell
        let timestamp = allEvents[indexPath.row]["EventTimeStamp"] as! Double
        let date = Date(timeIntervalSince1970: timestamp )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        let eventmonth = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        cell.eventTitle.text = allEvents[indexPath.row]["EventTitle"] as? String
        cell.eventDate.text = day
        cell.eventMonth.text = eventmonth
        cell.eventTimeFromTO.text = allEvents[indexPath.row]["EventTimeFromTO"] as? String
        let urlStr = allEvents[indexPath.row]["EventImageUrl"] as! String
        let Imgurl = URL(string:urlStr )
      
        cell.EventImg.sd_setImage(with: Imgurl, placeholderImage: UIImage(named: "image_placeholder"), options: .continueInBackground, completed: nil)

        cell.EventDetailBottomView.backgroundColor = hexStringToUIColor(hex: eventBottomViewColor[indexPath.row % 3])
        return cell
    }
    //MARK:TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = cellHeightsDictionary[indexPath] as? NSNumber
        if height != nil {
            return CGFloat(Double(truncating: height ?? 0.0))
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "EventDetailsVC") as! EventDetailsVC
//        vc.EventDetail = allEvents[indexPath.row] as! NSDictionary
        self.selectedCell = self.myTableView.cellForRow(at: indexPath)
        
       // let vc = EventDetailsVC.instantiate()
        vc.EventDetail = allEvents[indexPath.row] as! NSDictionary
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = .fromBottom
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
      
    }
    
}
extension EventsListVC: Animatable {
    var containerView: UIView? {
        return self.myTableView
    }
    
    var childView: UIView? {
        return self.selectedCell
    }
}
