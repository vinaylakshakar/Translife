//
//  CheerUpVC.swift
//  transLife
//
//  Created by Silstone Group on 14/02/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import SVProgressHUD

class CheerUpVC: UIViewController {

    var CategoriesWise = [String:[String:NSDictionary]]()
    var titleUrl = [String:NSDictionary]()
    var titleSection = [String]()
    var alltitle = [String]()
    var Titles = [String:[String]]()
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
    }
    override func viewWillAppear(_ animated: Bool) {
        getCheerUpdata()
    }
    // MARK: - GETTING CHEERUP
    
    func getCheerUpdata() {
            SVProgressHUD.show()
            ref.child("cheer_up").observeSingleEvent(of: .value, with: { (snap) in
                self.Titles.removeAll()
                self.titleUrl.removeAll()
                self.CategoriesWise.removeAll()
                self.titleSection.removeAll()
                if snap.value is NSNull{
                    SVProgressHUD.dismiss()
                    self.PresentAlert(message: "You need something to cheers, its coming soon.", title: "TransLife")
                }else{
                     let snapValue = snap.value as! Dictionary<String,AnyObject>
                for i in snapValue{
                    self.titleSection.append(i.key)
                    // print(i.value)
                    for n in i.value as! [String:AnyObject]{
                        self.alltitle.append(n.key)
                        self.Titles.updateValue(self.alltitle, forKey: i.key)
                        self.titleUrl.updateValue(n.value as! NSDictionary, forKey: n.key)
                        self.CategoriesWise.updateValue(self.titleUrl, forKey: i.key)
                    }
                    self.alltitle.removeAll()
                    self.titleUrl.removeAll()
                    
                }
                self.TableView.delegate = self
                self.TableView.dataSource = self
                self.TableView.reloadData()
                SVProgressHUD.dismiss()
                }
            })
            
        
    }
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension CheerUpVC:UITableViewDelegate,UITableViewDataSource{
    
    //MARK:TABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return CategoriesWise.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let val = titleSection[section] as String
        let rows = CategoriesWise[val]! as NSDictionary
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheerUpTVCell", for: indexPath) as! CheerUpTVCell
        let val = titleSection[indexPath.section] as String
        let rows = CategoriesWise[val]!
        let key = Titles[val]![indexPath.row]
        cell.descriptionLbl.text = rows[key]!["description"] as? String
        cell.HeadingLbl.text = key
        return cell
    }
    //MARK:TABLEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let VC = storyboard?.instantiateViewController(withIdentifier: "ResourcesDocsVC") as! ResourcesDocsVC
//
//        let val = titleSection[indexPath.section] as String
//        let rows = ResourcesCategoriesWise[val]!
//        let key = ResourcesTitle[val]![indexPath.row]
//        VC.urlString = rows[key]!["url"] as? String
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:
            tableView.bounds.size.width, height: 40))
        headerLabel.text = titleSection[section]
        headerLabel.font = UIFont(name:"SegoeUI-Bold", size: 35)
        headerLabel.textColor = hexStringToUIColor(hex:"#FFFFFF")
        headerLabel.sizeToFit()
        headerLabel.contentMode = .scaleToFill
        headerView.addSubview(headerLabel)
        
        return headerView
    }
}
