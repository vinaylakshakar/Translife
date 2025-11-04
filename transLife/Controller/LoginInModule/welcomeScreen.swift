//
//  ViewController.swift
//  transLife
//
//  Created by Developer Silstone on 30/11/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class welcomeScreen: UIViewController,UIScrollViewDelegate {

    
    @IBOutlet weak var topConstlogo: NSLayoutConstraint!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var welcomeTxtLbl: UILabel!
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var slidingText = ["TransLife is an app that will help you keep track of your moods and feelings through journaling. It will also help you connect with your community, provide you with valuable information and local resources.","Allows you to record your mood throughout the day, and track health activities (sleep, energy, etc.) to identify patterns in your moods.","You aren’t alone in this. Share stories, advice and more with peer support community.","Seeing your progress over time can help you make connections and recognize patterns. No judgement, just insight.","Finding access to trans-friendly healthcare and other services can be challenging. We designed a guided search to make this process easier.","Know the important health issues transgender people face, and get tips for taking charge of your health.","Help researchers to gain more in-depth understanding of the lived experiences of transgender people in order to design better suicide prevention tools for transgender youth."]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                topConstlogo.constant = 0
                welcomeTxtLbl.font = UIFont(name: "MuseoSans-500", size: 24)
            case 1334:
                print("iPhone 6/6S/7/8")
                topConstlogo.constant = 40
                welcomeTxtLbl.font = UIFont(name: "MuseoSans-500", size: 28)
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                topConstlogo.constant = 62
                welcomeTxtLbl.font = UIFont(name: "MuseoSans-500", size: 32)
            case 2436:
                print("iPhone X, XS")
                topConstlogo.constant = 62
                welcomeTxtLbl.font = UIFont(name: "MuseoSans-500", size: 32)
            case 2688:
                print("iPhone XS Max")
                topConstlogo.constant = 62
                welcomeTxtLbl.font = UIFont(name: "MuseoSans-500", size: 32)
            case 1792:
                print("iPhone XR")
                topConstlogo.constant = 62
                welcomeTxtLbl.font = UIFont(name: "MuseoSans-500", size: 32)
            default:
                print("Unknown")
            }
        }
        pagecontrol.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    override func viewDidLayoutSubviews() {
           pagecontrol.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
       // let x = CGFloat(pagecontrol.currentPage) * scrollview.frame.size.width
       // scrollview.setContentOffset(CGPoint(x:x, y:0), animated: true)
        let index = pagecontrol.currentPage
        let myIndexPath = IndexPath(row:index, section: 0)
        if index == 1{
            welcomeTxtLbl.text = "Mood"
        }else if index == 2{
            welcomeTxtLbl.text = "Peer Support Community"
        }else if index == 3{
            welcomeTxtLbl.text = "Progress"
        }else if index == 4{
            welcomeTxtLbl.text = "Local resources"
        }else if index == 5{
            welcomeTxtLbl.text = "Information"
        }else if index == 6{
            welcomeTxtLbl.text = "Research"
        }else{
            welcomeTxtLbl.text = "Welcome!"
        }
        collectionview.scrollToItem(at: myIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pagecontrol.currentPage = Int(pageNumber)
        if Int(pageNumber) == 1{
            welcomeTxtLbl.text = "Mood"
        }else if Int(pageNumber) == 2{
            welcomeTxtLbl.text = "Peer Support Community"
        }else if Int(pageNumber) == 3{
            welcomeTxtLbl.text = "Progress"
        }else if Int(pageNumber) == 4{
            welcomeTxtLbl.text = "Local resources"
        }else if Int(pageNumber) == 5{
            welcomeTxtLbl.text = "Information"
        }else if Int(pageNumber) == 6{
            welcomeTxtLbl.text = "Research"
        }else{
            welcomeTxtLbl.text = "Welcome!"
        }
    }
   //MARK:ACTIONS
    @IBAction func SignInTapped(_ sender: Any) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "termsandcondition"), object: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        vc.SignIn = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func RegisterNowTapped(_ sender: Any) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "termsandcondition"), object: nil)
  let vc = storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        vc.SignIn = false
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension welcomeScreen:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slidingText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slidingCvCell", for: indexPath) as! slidingCvCell
        cell.slidinglbl.text = slidingText[indexPath.item]
        cell.slidinglbl.addCharacterSpacing()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width
       return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        }

}
