//
//  InsightsDetailVC.swift
//  transLife
//
//  Created by Silstone Group on 20/09/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import Firebase

class InsightsDetailVC: UIViewController {

    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var sleepLevelHeight: NSLayoutConstraint!
    @IBOutlet weak var energyLevelHeight: NSLayoutConstraint!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var MainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var feelingTtgcollectionview: TTGTagCollectionView!
    @IBOutlet weak var feelingTtgCvHeight: NSLayoutConstraint!
    @IBOutlet weak var reasonTtgcollectionview: TTGTagCollectionView!
    @IBOutlet weak var reasonTtgCvHeight: NSLayoutConstraint!
    @IBOutlet weak var notesTxtView: UITextView!
    var DataDict = [NSDictionary]()
    var date = ""
    var indexdata = Int()
    var feelingCvHeight = CGFloat()
    var reasonCvHeight = CGFloat()
    var notesHeight = CGFloat()
    var feelingTagViews: [UILabel] = []
    var reasonTagViews: [UILabel] = []
    var FeelingArr = [String]()
    var ReasonArr = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpData(index: indexdata)
    }
    func setUpData(index:Int) {
        FeelingArr.removeAll()
        ReasonArr.removeAll()
        feelingTagViews.removeAll()
        reasonTagViews.removeAll()
        dateLbl.text = date
        let arr = DataDict[index]
        notesTxtView.text = arr["Notes"] as? String
       // let time = arr["time"] as! String
        let dateAsString = arr["currentTimeStamp"] as? Double
        let date = Date(timeIntervalSince1970: dateAsString!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        let localDate = dateFormatter.string(from: date)
        timeLbl.text = "\(String(describing: localDate))"
//        var myStringArr = time.components(separatedBy: "at")
//        timeLbl.text = myStringArr[1]
        let sleeplevel = arr["sleepLevel"] as! String
        let energylevel = arr["sleepLevel"] as! String
        let sleep = CGFloat(Int(sleeplevel)!)
        let energy = CGFloat(Int(energylevel)!)
        sleepLevelHeight.constant = sleep/6 * 100
        energyLevelHeight.constant = energy/6 * 100
        let Mood = arr["mood"] as? String
        switch Mood {
        case "Amazing":moodImage.image = UIImage(named:"amazing_background")
        case "Very Good": moodImage.image = UIImage(named:"verygood_background")
        case "Good":moodImage.image = UIImage(named:"good_background")
        case "Okay":moodImage.image = UIImage(named:"okay_background")
        case "Not Good":moodImage.image = UIImage(named:"notgood_background")
        case "Bad":moodImage.image = UIImage(named:"bad_background")
        case "Awful":moodImage.image = UIImage(named:"awful_background")
        default:moodImage.image = UIImage(named:"okay")
        }
        FeelingArr = arr["Feelings"] as! [String]
        ReasonArr = arr["Reasons"] as! [String]
        notesHeight = self.notesTxtView.contentSize.height
        notesTxtView.isScrollEnabled = false
        //Configuring tags
        TagConfiguration()
    }
    // MARK: - Configure Tag
    func TagConfiguration()  {
        let config = TTGTextTagConfig()
        config.shadowColor = hexStringToUIColor(hex: "#000000")
       // config.shadowColor = (hexStringToUIColor(hex: "#000000").cgColor)
        config.shadowRadius = 6.0
//        config.shadowOpacity = CGPath(rect:  CGRect(x: 0, y:3, width: 0, height: 0), transform: nil)
        config.shadowOpacity = 0.16
        config.shadowOffset = CGSize(width: 0, height: 3)
        config.enableGradientBackground = true
        config.extraSpace = CGSize(width: 10, height: 10)
        //feeling tag cv
        feelingTtgcollectionview.alignment = .fillByExpandingWidthExceptLastLine
        feelingTtgcollectionview.horizontalSpacing = 10
        feelingTtgcollectionview.verticalSpacing = 10
        self.feelingTtgcollectionview.delegate = self
        self.feelingTtgcollectionview.dataSource = self
        feelingTtgcollectionview.reload()
        //reason tag cv
        reasonTtgcollectionview.alignment = .fillByExpandingWidthExceptLastLine
        reasonTtgcollectionview.horizontalSpacing = 10
        reasonTtgcollectionview.verticalSpacing = 10
        self.reasonTtgcollectionview.delegate = self
        self.reasonTtgcollectionview.dataSource = self
        reasonTtgcollectionview.reload()
    }
    // Actions
    @IBAction func leftArrowBtnAction(_ sender: Any) {
         indexdata = indexdata - 1
        if indexdata >= 0 && indexdata <= DataDict.count-1{
            setUpData(index: indexdata)
        }else{
            indexdata = 0
            PresentAlert(message:"You don't have more previous mood logs for this date.", title:"Translife")
        }
    }
    @IBAction func rightArrowBtnAction(_ sender: Any) {
        indexdata = indexdata + 1
        if indexdata >= 0 && indexdata <= DataDict.count-1{
            setUpData(index: indexdata)
        }else{
            indexdata = DataDict.count-1
            PresentAlert(message:"You don't have more next mood logs for this date.", title:"Translife")
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension InsightsDetailVC : TTGTagCollectionViewDelegate,TTGTagCollectionViewDataSource{
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
            if tagCollectionView == feelingTtgcollectionview{
                let size = (FeelingArr[Int(index)] as NSString).size(withAttributes:nil)
                let width = size.width + 40
                let height = size.height + 25
                return  CGSize(width: width, height: height)
            }else{
                let size = (ReasonArr[Int(index)] as NSString).size(withAttributes:nil)
                let width = size.width + 40
                let height = size.height + 25
                return  CGSize(width: width, height: height)
            }
    }
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        if tagCollectionView == feelingTtgcollectionview{
            return UInt(FeelingArr.count)
        }else{
            return UInt(ReasonArr.count)
        }
    }
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        if tagCollectionView == feelingTtgcollectionview{
            let taglabel = UILabel()
            taglabel.tag = Int(index)
            feelingTagViews.append(taglabel)
            taglabel.font = UIFont(name:"SegoeUI-Semibold", size: 15)
            taglabel.textColor = hexStringToUIColor(hex:"#3E3E3E")
            taglabel.textAlignment = .center
            taglabel.sizeToFit()
            taglabel.numberOfLines = 1
            taglabel.contentMode = .center
            taglabel.alpha = 1
            taglabel.lineBreakMode = .byTruncatingTail
            taglabel.adjustsFontSizeToFitWidth = true
            taglabel.backgroundColor = UIColor.white
            taglabel.text = FeelingArr[Int(index)]
            taglabel.CornerRadius(19)
            return feelingTagViews[Int(index)]
        }else{
            let taglabel = UILabel()
            taglabel.tag = Int(index)
            reasonTagViews.append(taglabel)
            taglabel.font = UIFont(name:"SegoeUI-Semibold", size: 15)
            taglabel.textColor = hexStringToUIColor(hex:"#3E3E3E")
            taglabel.textAlignment = .center
            taglabel.sizeToFit()
            taglabel.numberOfLines = 0
            taglabel.contentMode = .center
            taglabel.alpha = 1
            taglabel.lineBreakMode = .byTruncatingTail
            taglabel.adjustsFontSizeToFitWidth = true
            taglabel.backgroundColor = UIColor.white
            taglabel.text = ReasonArr[Int(index)]
            taglabel.CornerRadius(19)
            return reasonTagViews[Int(index)]
        }
    }
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, updateContentSize contentSize: CGSize) {
        
        if tagCollectionView == feelingTtgcollectionview{
            feelingCvHeight = contentSize.height
            feelingTtgCvHeight.constant = feelingCvHeight
            MainViewHeight.constant = 572 + reasonCvHeight + feelingCvHeight + notesHeight
        }else{
            reasonCvHeight = contentSize.height
            reasonTtgCvHeight.constant = reasonCvHeight
            MainViewHeight.constant = 572 + reasonCvHeight + feelingCvHeight + notesHeight
        }
    }
}
