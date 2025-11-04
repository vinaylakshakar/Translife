//
//  RatingController.swift
//
//
//  Created by mohamed al-ghamdi on 17/04/2018.
//  Copyright © 2018 mohamed al-ghamdi. All rights reserved.
//

import UIKit
import Firebase

class RatingController: UIStackView {
    var snapKey = String()
    var starsRating = 0
    var starsEmptyPicName = "star_unselected" // change it to your empty star picture name
    var starsFilledPicName = "star_selected" // change it to your filled star picture name
    override func draw(_ rect: CGRect) {
        let starButtons = self.subviews.filter{$0 is UIButton}
        var starTag = 1
        for button in starButtons {
            if let button = button as? UIButton{
                button.setBackgroundImage(UIImage(named: starsEmptyPicName), for: .normal)
                button.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
                button.tag = starTag
                starTag = starTag + 1
            }
        }
       setStarsRating(rating:starsRating)
    }
    func setStarsRating(rating:Int){
        self.starsRating = rating
        let stackSubViews = self.subviews.filter{$0 is UIButton}
        for subView in stackSubViews {
            if let button = subView as? UIButton{
                if button.tag > starsRating {
                    button.setBackgroundImage(UIImage(named: starsEmptyPicName), for: .normal)
                }else{
                    button.setBackgroundImage(UIImage(named: starsFilledPicName), for: .normal)
                }
            }
        }
    }
    @objc func pressed(sender: UIButton) {
        setStarsRating(rating: sender.tag)
        needRefreshforlocal = true
        if snapKey != ""{
            let currentuser = UserDefaults.standard.value(forKey: "username") as! String
            //MARK:AVERAGE Rating
            ref.child("Locals").child(snapKey).child("usersGivenRating").updateChildValues([currentuser : sender.tag]) { (error, snap) in
                ref.child("Locals").child(self.snapKey).observeSingleEvent(of: .value) { (snap) in
                    let value = snap.value as! [String:AnyObject]
                    let rating  = value["LocalRating"] as! Int
                    guard  let usersGivenRating = value["usersGivenRating"] as? NSDictionary else {return}
                   
                    if usersGivenRating.count == 1 {
              ref.child("Locals").child(self.snapKey).updateChildValues(["LocalRating":sender.tag])
                    }else{
                        let averageRating = (rating + sender.tag) / (usersGivenRating.count)
                        ref.child("Locals").child(self.snapKey).updateChildValues(["LocalRating":averageRating])
                    }
                }
            }
        }else{
            print("snapKey not found ::")
        }
    }
}
