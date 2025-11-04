//
//  LocalListVC.swift
//  transLife
//
//  Created by Developer Silstone on 11/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//
import Foundation
import UIKit
import SVProgressHUD

var needRefreshforlocal = true
class LocalListVC: UIViewController {
    
    let local = Local()
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var searchBarheightCons: NSLayoutConstraint!
    
    @IBOutlet weak var blurViewForBlockingUI: UIVisualEffectView!
    @IBOutlet weak var TableView: UITableView!
    var getLocals = [NSDictionary]()
    var allLocals = [NSDictionary]()
    var localNames = ["atring1","btring2","ctring3","dtring4","atring2","ftrnng2","gtring3","htring4"]
    var filteredData = [NSDictionary]()
    var shouldShowSearchResults = false
    
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(refreshingLocalView(notification:)), name:NSNotification.Name(rawValue: "refreshingLocalView"), object: nil)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        if needRefreshforlocal == true{
            SVProgressHUD.show()
        }else{
        }
        if SearchBar.text == ""{
            self.searchBarheightCons.constant = 0
        }else{
            self.searchBarheightCons.constant = 44
        }
        if ispendingMandSurvey == true{
            blurViewForBlockingUI.isHidden = false
        }else{
            blurViewForBlockingUI.isHidden = true
        }
        
    }
    @objc func refreshingLocalView(notification: NSNotification) {
         self.setNeedsStatusBarAppearanceUpdate()
               if needRefreshforlocal == true{
                   SVProgressHUD.show()
               }else{
               }
               if SearchBar.text == ""{
                   self.searchBarheightCons.constant = 0
               }else{
                   self.searchBarheightCons.constant = 44
               }
               if ispendingMandSurvey == true{
                   blurViewForBlockingUI.isHidden = false
               }else{
                   blurViewForBlockingUI.isHidden = true
               }
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        if needRefreshforlocal == true{
            getAllLocals()
        }else{
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem.imageInsets.bottom = -5
        self.tabBarItem.imageInsets.top = 5
        
        self.tabBarItem.image = UIImage(named: "nav_local_unselected")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "nav_local_selected")?.withRenderingMode(.alwaysOriginal)
    }
    
    //MARK:GET ALL LOCALS
    func getAllLocals() {
        SVProgressHUD.show()
        self.TableView.isUserInteractionEnabled  = false
        self.getLocals.removeAll()
        self.allLocals.removeAll()
        self.filteredData.removeAll()
        local.GetLocalData(view: self) { (snap) in
            if snap.value is NSNull{
                self.TableView.delegate = self
                self.TableView.dataSource = self
                self.TableView.reloadData()
                SVProgressHUD.dismiss()
                self.PresentAlert(message: "Add service providers.", title: "TransLife")
            }else{
                let snapValue = snap.value as! [String:AnyObject]
                for i in snapValue {
                    let data = i.value
                    self.getLocals.append(data as! NSDictionary)
                }
                let sortedArr =  self.getLocals.sorted(by: { $0["currentTimeStamp"] as! Double > $1["currentTimeStamp"] as! Double })
                self.allLocals = sortedArr
                self.filteredData = self.allLocals
                self.TableView.delegate = self
                self.TableView.dataSource = self
                self.TableView.reloadData()
                self.SearchBar.delegate = self
                SVProgressHUD.dismiss()
                self.TableView.isUserInteractionEnabled  = true
            }
        }
    }
    //MARK:ACTIONS
    @IBAction func SearchBtnTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.searchBarheightCons.constant = 44
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @IBAction func AddBtnTapped(_ sender: Any) {
        if ispendingMandSurvey == true{
            
        }else{
            PresentTo(FromVC: self, ToStoryboardID: "AddLocalVC")
        }
        
    }
    //MARK: HIDE KEYBOARD ON TAP
    func HideKeyboard() {
        let tap :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
}
extension LocalListVC:UITableViewDelegate,UITableViewDataSource{
    
    //MARK: TABLEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  filteredData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocalTVCell", for: indexPath) as! LocalTVCell
        
        let data = filteredData[indexPath.row]
        cell.localName.text = data["name"] as? String
        cell.localOccupation.text = filteredData[indexPath.row]["occupation"] as? String
        if let starcount = (filteredData[indexPath.row]["LocalRating"] as? Int) {
            cell.ratingStackView.setStarsRating(rating:starcount )
        }else{
            cell.ratingStackView.setStarsRating(rating:0)
        }
        let urlStr = filteredData[indexPath.row]["ProfileImageUrl"] as! String
        let Imgurl = URL(string:urlStr )
        cell.localProfileImg.sd_setImage(with: Imgurl, placeholderImage: UIImage(named: "image_placeholder"), options: .continueInBackground, completed: nil)
        return cell
    }
    //MARK:TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LocalDetailVC") as! LocalDetailVC
        vc.localDetail = filteredData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
}
extension LocalListVC:UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        SearchBar.text = ""
        filteredData = allLocals
        TableView.reloadData()
        UIView.animate(withDuration: 0.4, animations: {
            self.searchBarheightCons.constant = 0
            self.view.endEditing(true)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            TableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        TableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        shouldShowSearchResults = true
        
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[C] %@", searchText)
        filteredData = (allLocals as NSArray).filtered(using: searchPredicate) as! [NSDictionary]
        
        TableView.reloadData()
    }
    
}
