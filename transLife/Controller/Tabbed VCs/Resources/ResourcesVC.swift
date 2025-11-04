//
//  ResourcesVC.swift
//  transLife
//
//  Created by Developer Silstone on 11/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

var needRefreshResource = true
class ResourcesVC: UIViewController {
    
    var tableViewData = [ExpandableCategories]()
    
    @IBOutlet weak var blurViewForBlockingUI: UIVisualEffectView!
    @IBOutlet weak var tableview: UITableView!
    let resourcesfiles = Resources()
    var cellHeightsDictionary: [AnyHashable : Any] = [:]
    var ResourcesCategoriesWise = [String:[String:AnyObject]]()
    var titleUrl = [String:AnyObject]() 
    var titleSection = [String]()
    var alltitle = [String]()
    var ResourcesTitle = [String:[String]]()
    var isBody = true
    var isMind = false
    var isHousing = false
    var isViolence = false
    var isLegal = false
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var searchBarheightCons: NSLayoutConstraint!
    
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarheightCons.constant = 0
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK:GET RESOURCES FILES
    func GetResourcesPdfFiles() {
        SVProgressHUD.show()
        resourcesfiles.GetResorcesFiles(view: self) { (snap) in
            self.tableViewData.removeAll()
            self.ResourcesTitle.removeAll()
            self.titleUrl.removeAll()
            self.ResourcesCategoriesWise.removeAll()
            self.titleSection.removeAll()
            if snap.value is NSNull{
                self.tableview.delegate = self
                self.tableview.dataSource = self
                self.tableview.reloadData()
                SVProgressHUD.dismiss()
                self.PresentAlert(message:"No Resources yet.", title: "TransLife")
            }else{
                let snapValue = snap.value as! [String:AnyObject]
                // print(snapValue)
                for i in snapValue{
                    self.titleSection.append(i.key)
                    for n in i.value as! [String:AnyObject]{
                        self.alltitle.append(n.key)
                        self.ResourcesTitle.updateValue(self.alltitle, forKey: i.key)
                        self.titleUrl.updateValue(n.value, forKey: n.key)
                        self.ResourcesCategoriesWise.updateValue(self.titleUrl , forKey: i.key)
                    }
                    self.tableViewData.append(ExpandableCategories(isExpanded: false, title: i.key, sectionData: self.titleUrl))
                    self.alltitle.removeAll()
                    self.titleUrl.removeAll()
                }
                //print(self.ResourcesCategoriesWise)
                self.tableview.delegate = self
                self.tableview.dataSource = self
                self.tableview.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        if ispendingMandSurvey == true{
            blurViewForBlockingUI.isHidden = false
        }else{
            blurViewForBlockingUI.isHidden = true
        }
        if needRefreshResource == true{
            GetResourcesPdfFiles()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem.imageInsets.bottom = -5
        self.tabBarItem.imageInsets.top = 5
        self.tabBarItem.image = UIImage(named: "nav_resources_unselected")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "nav_resources_selected")?.withRenderingMode(.alwaysOriginal)
    }
    
    //MARK:ACTIONS
    @IBAction func AddFileAction(_ sender: Any) {
        
        
    }
    @IBAction func searchBtnAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.searchBarheightCons.constant = 44
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
extension ResourcesVC:UITableViewDelegate,UITableViewDataSource{
    
    //MARK:TABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
        // return ResourcesCategoriesWise.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].isExpanded == true{
            return tableViewData[section].sectionData.count
        }else{
            return 0
        }
        //        let val = titleSection[section] as String
        //        let rows = ResourcesCategoriesWise[val]! as NSDictionary
        //        return rows.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourcesTVCell", for: indexPath) as! ResourcesTVCell
        let title = tableViewData[indexPath.section].title
        let key = ResourcesTitle[title]![indexPath.row]
        let val = titleSection[indexPath.section] as String
        let rows = ResourcesCategoriesWise[val]!
        cell.ResourcesDescription.text = rows[key]!["resource_description"] as? String
        cell.ResourceHeading.text = key
        return cell
    }
    
    //MARK:TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary[indexPath] = cell.frame.size.height
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = cellHeightsDictionary[indexPath] as? NSNumber
        if height != nil {
            return CGFloat(Double(truncating: height ?? 0.0))
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "ResourcesDocsVC") as! ResourcesDocsVC
        let val = titleSection[indexPath.section] as String
        let rows = ResourcesCategoriesWise[val]!
        let key = ResourcesTitle[val]![indexPath.row]
        VC.resourceDetail = rows[key]!["resource_detail"] as? String
        VC.resourcetitlestring = key
        VC.resourceDescstring = rows[key]!["resource_description"] as? String
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width:
            tableView.bounds.size.width, height: 40))
        headerView.backgroundColor = hexStringToUIColor(hex: "#25A551")
        headerView.alpha = 1
        headerView.tag = section
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = 0
        blurredEffectView.frame = headerView.bounds
        headerView.addSubview(blurredEffectView)
        let segmentedControl = UISegmentedControl(items: ["First Item", "Second Item"])
        segmentedControl.sizeToFit()
        segmentedControl.center = view.center
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = headerView.bounds
        
        vibrancyEffectView.contentView.addSubview(segmentedControl)
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:
            tableView.bounds.size.width, height: 33))
        headerLabel.text = tableViewData[section].title//titleSection[section]
        headerLabel.font = UIFont(name:"SegoeUI-Bold", size: 25)
        headerLabel.textColor = hexStringToUIColor(hex:"#FFFFFF")
        headerLabel.sizeToFit()
        headerLabel.contentMode = .scaleToFill
        headerView.addSubview(headerLabel)
        let icon = UIImageView(frame: CGRect(x:tableView.bounds.size.width - 40, y:15, width: 15, height: 15))
        if tableViewData[section].isExpanded == true{
            icon.image = UIImage(named:"drop_green")
        }else{
            icon.image = UIImage(named:"right-arrow")
        }
        icon.tag = section + 1000
        icon.tintColor = .white
        headerView.addSubview(icon)
        
        let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
        headerView.addGestureRecognizer(tapgesture)
        return headerView
    }
    @objc func sectionTapped(_ sender: UITapGestureRecognizer){
        let section = (sender.view?.tag)!
        if tableViewData[section].isExpanded == true{
            tableViewData[section].isExpanded = false
            let sections = IndexSet.init(integer: section)
            tableview.reloadSections(sections, with: .fade)
        }else{
            tableViewData[section].isExpanded = true
            let sections = IndexSet.init(integer: section)
            tableview.reloadSections(sections, with: .fade)
        }
    }
}
extension ResourcesVC:UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.4, animations: {
            self.searchBarheightCons.constant = 0
            self.view.endEditing(true)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
