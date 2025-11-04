//
//  MoodLogSelectFeelingsVC.swift
//  transLife
//
//  Created by Developer Silstone on 11/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout
import TTGTagCollectionView

class MoodFeelingsListVC: UIViewController {
    
    @IBOutlet weak var TopTitle: UILabel!
    @IBOutlet weak var ttgcollectionview: TTGTagCollectionView!
    @IBOutlet weak var CollectionVIEW: UICollectionView!
    var feelingDict = [Int:String]()
    var tagViews: [UILabel] = []
    
    var isFeelingSelected = Bool()
    var neutralFeelingArr = ["","Calm","Cheerful","Confident","Content","Energized","Ecstatic","Enthusiastic","Excited","Grateful","Happy","Humorous","Inspired","Joyful","Lively","Loving","Motivated","Optimistic","Passionate","Peaceful","Playful","Proud","Relaxed","Relieved","Refreshed","Satisfied","Secure","Surprised","Thrilled","Afraid","Angry","Anxious","Confused","Depressed","Disappointed","Embarrassed","Empty","Frustrated","Furious","Guilty","Insecure","Jealous","Lonely","Numb","Sad","Stressed","Worried","Bored","Tired","Annoyed","Lethargic","Self-conscious","Victimized"]
    var PositiveFeelingsArr = ["","Calm","Cheerful","Confident","Content","Energized","Ecstatic","Enthusiastic","Excited","Grateful","Happy","Humorous","Inspired","Joyful","Lively","Loving","Motivated","Optimistic","Passionate","Peaceful","Playful","Proud","Relaxed","Relieved","Refreshed","Satisfied","Secure","Surprised","Thrilled"]
    var NegativeFeelingsArr = ["","Afraid","Angry","Anxious","Confused","Depressed","Disappointed","Embarrassed","Empty","Frustrated","Furious","Guilty","Insecure","Jealous","Lonely","Numb","Sad","Stressed","Worried","Bored","Tired","Annoyed","Lethargic","Self-conscious","Victimized"]
    var ReasonForMoodArr = ["","gender dysphoria","Immediate Family","LGBTQ friends","Straight friends","Extended family","Significant other","Sexual partner","Workplace","School","Church or faith community","Healthcare experience","Mental health professional","Transition related experien","Law enforcement","Finances","Housing","Mistreatment due to my sexuality","Mistreatment due to my race","Mistreatment due to my gender identity","Mistreatment due to my gender expression/appearance","Use of bathroom","Traveling","Use of gym/health club","Use of public transportation","Retail store","Restaurant","Hotel","Theater","Nature","Music","Belief/faith","TV","Art","Sports","Activities","Achieving goals","Memories","Book","Appearance (hair/makeup/nails)","Food"]
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        TagConfiguration()
//        let alignedFlowLayout = CollectionVIEW?.collectionViewLayout as? AlignedCollectionViewFlowLayout
//        alignedFlowLayout?.horizontalAlignment = .left
//        alignedFlowLayout?.verticalAlignment = .top
//        alignedFlowLayout?.minimumInteritemSpacing = 10
//        alignedFlowLayout?.minimumLineSpacing = 10
       // self.CollectionVIEW.reloadData()
        
    }
    // MARK: - Configure Tag
    func TagConfiguration()  {
         // ttgcollectionview.contentInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        let config = TTGTextTagConfig()
        config.extraSpace = CGSize(width: 10, height: 10)
        ttgcollectionview.alignment = .fillByExpandingWidthExceptLastLine
        ttgcollectionview.horizontalSpacing = 10
        ttgcollectionview.verticalSpacing = 10
        self.ttgcollectionview.delegate = self
        self.ttgcollectionview.dataSource = self
        ttgcollectionview.reload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         navigationController?.navigationBar.barStyle = .black
    }
    override func viewWillAppear(_ animated: Bool) {
        if isFeelingSelected {
            TopTitle.text = "Select Feelings"
        }else{
            TopTitle.text = "Select Reasons"
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator = scrollView.subviews.last as? UIImageView
        verticalIndicator?.backgroundColor = hexStringToUIColor(hex: "#B9A3D5")
    }
    //MARK:ACTIONS
    @IBAction func DoneBtnAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func BackBtnAct(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MoodFeelingsListVC:TTGTagCollectionViewDataSource,TTGTagCollectionViewDelegate{
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        if index == 0{
            return CGSize(width: 0, height: 0)
        }
        if isFeelingSelected == true{
            if moodfeeling == "negative"{
                let size = (NegativeFeelingsArr[Int(index)] as NSString).size(withAttributes: nil)
                let width = size.width + 40
                let height = size.height + 25
                return  CGSize(width: width, height: height)
            }else if moodfeeling == "positive" {
                let size = (PositiveFeelingsArr[Int(index)] as NSString).size(withAttributes: nil)
                let width = size.width + 40
                let height = size.height + 25
                return  CGSize(width: width, height: height)
            }else{
                let size = (neutralFeelingArr[Int(index)] as NSString).size(withAttributes: nil)
                let width = size.width + 40
                let height = size.height + 25
                return  CGSize(width: width, height: height)
            }
        }else{
            let size = (ReasonForMoodArr[Int(index)] as NSString).size(withAttributes:nil)
            let width = size.width + 40
            let height = size.height + 25
            return  CGSize(width: width, height: height)
        }
    }
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        if isFeelingSelected == true{
            if moodfeeling == "negative"{
                return UInt(NegativeFeelingsArr.count)
            }else if moodfeeling == "positive"{
                return UInt(PositiveFeelingsArr.count)
            }else{
                return UInt(neutralFeelingArr.count)
            }
        }else{
            return UInt(ReasonForMoodArr.count)
        }
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
      
        let taglabel = UILabel()
        taglabel.tag = Int(index)
        tagViews.append(taglabel)
        taglabel.font = UIFont(name:"SegoeUI-Semibold", size: 15)
        taglabel.textColor = UIColor.white
        taglabel.textAlignment = .center
        taglabel.sizeToFit()
        taglabel.numberOfLines = 0
        taglabel.contentMode = .center
        taglabel.alpha = 0.7
        taglabel.lineBreakMode = .byTruncatingTail
        taglabel.adjustsFontSizeToFitWidth = true
        

        taglabel.backgroundColor = hexStringToUIColor(hex: "#B9A3D5")
        if isFeelingSelected == true{
            if moodfeeling == "negative"{
                taglabel.text = NegativeFeelingsArr[Int(index)]
                taglabel.CornerRadius(19)
            }else if moodfeeling == "positive"{
                taglabel.text = PositiveFeelingsArr[Int(index)]
                taglabel.CornerRadius(19)
            }else{
                taglabel.text = neutralFeelingArr[Int(index)]
                taglabel.CornerRadius(19)
            }
            if selectedFeelArr.contains(taglabel.text ?? "nii"){
                taglabel.backgroundColor = hexStringToUIColor(hex: "#EF036F")
                taglabel.alpha = 1
            }
            
        }else{
            taglabel.text = ReasonForMoodArr[Int(index)]
            taglabel.CornerRadius(19)
            if selectedreasonArr.contains(taglabel.text ?? "nii"){
                taglabel.backgroundColor = hexStringToUIColor(hex: "#EF036F")
                taglabel.alpha = 1
            }
        }
        return tagViews[Int(index)]
    }
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
   
        let taglabel = view.viewWithTag(Int(index)) as! UILabel
       // let subview = view.viewWithTag(i)
        if taglabel.isKind(of: UILabel.self) == true{
            if taglabel.backgroundColor == hexStringToUIColor(hex: "#B9A3D5"){
                taglabel.backgroundColor = hexStringToUIColor(hex: "#EF036F")
                taglabel.alpha = 1
                if isFeelingSelected == true{
                    selectedFeelArr.append(taglabel.text ?? "niiil")
                }else{
                    selectedreasonArr.append(taglabel.text ?? "niiil")
                }
            }else{
                taglabel.backgroundColor = hexStringToUIColor(hex: "#B9A3D5")
                taglabel.alpha = 0.7
                if isFeelingSelected == true{
                    if selectedFeelArr.contains(taglabel.text ?? "nii"){
                        let Eleindex =  selectedFeelArr.firstIndex(of: taglabel.text ?? "dcs")
                        selectedFeelArr.remove(at: Eleindex ?? 0)
                    }
                }else{
                    if selectedreasonArr.contains(taglabel.text ?? "nii"){
                        let Eleindex =  selectedreasonArr.firstIndex(of: taglabel.text ?? "dcs")
                        selectedreasonArr.remove(at: Eleindex ?? 0)
                    }
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshingMoodView"), object: nil)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshingMoodView"), object: nil)
            print("Tag \(index) is not configured right")
        }
    }
    func expandSize(for view: UIView?, extraWidth: CGFloat, extraHeight: CGFloat) {
        var frame: CGRect? = view?.frame
        frame?.size.width += extraWidth
        frame?.size.height += extraHeight
        view?.frame = frame ?? CGRect.zero
    }
}

// commented because ttgtagcollection is used instead

//extension MoodFeelingsListVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//
//    //MARK: COLLECTIONVIEW DATASOURCE
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if isFeelingSelected == true{
//            if negativeFeeling == true{
//                return NegativeFeelingsArr.count
//            }else{
//                return PositiveFeelingsArr.count
//            }
//
//        }else{
//            return ReasonForMoodArr.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectFeelingCVCell", for: indexPath) as! SelectFeelingCVCell
//        cell.FeelingsLabel.backgroundColor = hexStringToUIColor(hex: "#B9A3D5")
//        if isFeelingSelected == true{
//            if negativeFeeling == true{
//                cell.FeelingsLabel.text = NegativeFeelingsArr[indexPath.item]
//            }else{
//                cell.FeelingsLabel.text = PositiveFeelingsArr[indexPath.item]
//            }
//            if selectedFeelArr.contains(cell.FeelingsLabel.text ?? "nii"){
//                cell.FeelingsLabel.backgroundColor = hexStringToUIColor(hex: "#EF036F")
//            }
//        }else{
//            cell.FeelingsLabel.text = ReasonForMoodArr[indexPath.item]
//            if selectedreasonArr.contains(cell.FeelingsLabel.text ?? "nii"){
//                cell.FeelingsLabel.backgroundColor = hexStringToUIColor(hex: "#EF036F")
//            }
//        }
//        return cell
//    }
//    //MARK: COLLECTIONVIEW LAYOUT DELEGATE
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if isFeelingSelected == true{
//            if negativeFeeling == true{
//                let size = (NegativeFeelingsArr[indexPath.item] as NSString).size(withAttributes: nil)
//                let width = size.width + 50
//                let height = size.height + 35
//                return  CGSize(width: width, height: height)
//            }else{
//                let size = (PositiveFeelingsArr[indexPath.item] as NSString).size(withAttributes: nil)
//                let width = size.width + 50
//                let height = size.height + 35
//                return  CGSize(width: width, height: height)
//            }
//
//        }else{
//            let size = (ReasonForMoodArr[indexPath.item] as NSString).size(withAttributes:nil)
//            let width = size.width + 80
//            let height = size.height + 35
//            return  CGSize(width: width, height: height)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    //MARK:COLLECTIONVIEW DELEGATE
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! SelectFeelingCVCell
//
//        if cell.FeelingsLabel.backgroundColor == hexStringToUIColor(hex: "#B9A3D5"){
//            cell.FeelingsLabel.backgroundColor = hexStringToUIColor(hex: "#EF036F")
//            if isFeelingSelected == true{
//                selectedFeelArr.append(cell.FeelingsLabel.text ?? "niiil")
//            }else{
//                selectedreasonArr.append(cell.FeelingsLabel.text ?? "niiil")
//            }
//        }else{
//            cell.FeelingsLabel.backgroundColor = hexStringToUIColor(hex: "#B9A3D5")
//            if isFeelingSelected == true{
//                if selectedFeelArr.contains(cell.FeelingsLabel.text ?? "nii"){
//                    let Eleindex =  selectedFeelArr.firstIndex(of: cell.FeelingsLabel.text ?? "dcs")
//                    selectedFeelArr.remove(at: Eleindex ?? 0)
//                }
//            }else{
//                if selectedreasonArr.contains(cell.FeelingsLabel.text ?? "nii"){
//                    let Eleindex =  selectedreasonArr.firstIndex(of: cell.FeelingsLabel.text ?? "dcs")
//                    selectedreasonArr.remove(at: Eleindex ?? 0)
//                }
//            }
//        }
//    }
//}

