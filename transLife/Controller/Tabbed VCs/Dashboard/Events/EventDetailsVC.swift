//
//  EventDetailsVC.swift
//  transLife
//
//  Created by Developer Silstone on 17/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation
import MapKit

class EventDetailsVC: UIViewController {
    
    @IBOutlet weak var commonView: UIView!
    
    @IBOutlet weak var phoneIconHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewLeading: NSLayoutConstraint!
    @IBOutlet weak var mainViewtop: NSLayoutConstraint!
    @IBOutlet weak var mainViewtrailing: NSLayoutConstraint!
    @IBOutlet weak var descriptionOfEvent: UITextView!
    @IBOutlet weak var Address1Lbl: UILabel!
    @IBOutlet weak var Address2Lbl: UILabel!
    @IBOutlet weak var Address3Lbl: UILabel!
    @IBOutlet weak var EventImg: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventMonth: UILabel!
    @IBOutlet weak var eventTimeFromTO: UILabel!
    var Eventlocation = ""
    var address1 = ""
    var address2 = ""
    var address3 = ""
    var eventLat = CLLocationDegrees()
    var eventLong = CLLocationDegrees()
    
    @IBOutlet weak var contactNo: UITextView!
    
    @IBOutlet weak var viewForEventHeading: UIView!
    @IBOutlet weak var ViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    var EventDetail = NSDictionary()
    
    @IBOutlet weak var scrollview: UIScrollView!
    //MARK:LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setUpEventDetails() {
        needrefreshforEvents = false
        guard let add1 = EventDetail["Address1"] else{return}
        guard let add2 = EventDetail["Address2"] else{return}
        guard let add3 = EventDetail["Address3"] else{return}
        eventLat = EventDetail["latitude"] as? Double ?? 0
        eventLong = EventDetail["longitude"] as? Double ?? 0
        address1 = add1 as! String
        address2 = add2 as! String
        address3 = add3 as! String
        let timestamp = EventDetail["EventTimeStamp"] as! Double
        let date = Date(timeIntervalSince1970: timestamp )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        let eventmonth = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        eventDate.text = day
        eventMonth.text = eventmonth
        eventTitle.text = EventDetail["EventTitle"] as? String
        eventTimeFromTO.text = EventDetail["EventTimeFromTO"] as? String
        descriptionOfEvent.text = EventDetail["DescriptionText"] as? String
        Address1Lbl.text = add1 as? String
        Address2Lbl.text = add2 as? String//EventDetail["Address2"] as? String
        Address3Lbl.text = add3 as? String//EventDetail["Address3"] as? String
        let contact = EventDetail["Contact"] as? String
        contactNo.text = contact
        if contact == ""{
            phoneIconHeight.constant = 0
        }else{
            phoneIconHeight.constant = 47
        }
        let urlStr = EventDetail["EventImageUrl"] as! String
        let Imgurl = URL(string:urlStr )
        EventImg.sd_setImage(with:Imgurl , placeholderImage: #imageLiteral(resourceName: "image_placeholder"))
        
        Eventlocation = "\(address1),\(address2)"
        let height = self.descriptionOfEvent.contentSize.height
        self.ViewHeight.constant = 900 + height
        //  textViewHeight.constant = height
        descriptionOfEvent.isScrollEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpEventDetails()
        
    }
    
    // MARK: - ACTION
    
    @IBAction func BackBtnAct(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = .fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popViewController(animated: false)
    }
    @IBAction func getDirectionBtnAct(_ sender: Any) {
        //        coordinates(forAddress: Eventlocation) {
        //            (location) in
        //            guard let location = location else {
        //                // Handle error here.
        //                return
        //            }
        //MARK: FOR GOOGLE MAP
        //            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
        //                UIApplication.shared.open(NSURL(string: "comgooglemaps://?saddr=&daddr=\(Float(location.latitude)),\(Float(location.longitude))&directionsmode=driving")! as URL)
        //                //openURL(NSURL(string:
        //                   // "comgooglemaps://?saddr=&daddr=\(self.Eventlocation)&directionsmode=driving")! as URL)
        //
        //            }else{
        //                NSLog("Can't use comgooglemaps://");
        //            }
        //          }
        // }
        //MARK: FOR APPLE MAPKIT
        let coordinate = CLLocationCoordinate2DMake(self.eventLat,self.eventLong)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = self.Eventlocation
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
        
    }
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                self.PresentAlert(message:"invalid address", title: "TransLife")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
}
//extension EventDetailsVC: Animatable {
//    var containerView: UIView? {
//        return self.view
//    }
//
//    var childView: UIView? {
//        return self.commonView
//    }
//
//    func presentingView(
//        sizeAnimator: UIViewPropertyAnimator,
//        positionAnimator: UIViewPropertyAnimator,
//        fromFrame: CGRect,
//        toFrame: CGRect
//        ) {
//        // Make the common view the same size as the initial frame
//        self.ViewHeight.constant = fromFrame.height
//
//        // Show the close button
//       // self.closeButton.alpha = 1
//
//        // Make the view look like a card
//     //   self.asCard(true)
//
//        // Redraw the view to update the previous changes
//        self.view.layoutIfNeeded()
//
//        // Animate the common view to a height of 500 points
//        self.ViewHeight.constant = 500
//        sizeAnimator.addAnimations {
//            self.view.layoutIfNeeded()
//        }
//
//        // Animate the view to not look like a card
//        positionAnimator.addAnimations {
//         //   self.asCard(false)
//        }
//    }
//
//    func dismissingView(
//        sizeAnimator: UIViewPropertyAnimator,
//        positionAnimator: UIViewPropertyAnimator,
//        fromFrame: CGRect,
//        toFrame: CGRect
//        ) {
//        // If the user has scrolled down in the content, force the common view to go to the top of the screen.
//        self.mainViewtop.isActive = true
//
//        // If the top card is completely off screen, we move it to be JUST off screen.
//        // This makes for a cleaner looking animation.
//        if scrollview.contentOffset.y > commonView.frame.height {
//            self.mainViewtop.constant = -commonView.frame.height
//            self.view.layoutIfNeeded()
//
//            // Still want to animate the common view getting pinned to the top of the view
//            self.mainViewtop.constant = 0
//        }
//
//        // Animate the height of the common view to be the same size as the TO frame.
//        // Also animate hiding the close button
//        self.ViewHeight.constant = toFrame.height
//        sizeAnimator.addAnimations {
//          //  self.closeButton.alpha = 0
//            self.view.layoutIfNeeded()
//        }
//
//        // Animate the view to look like a card
//        positionAnimator.addAnimations {
//            //self.asCard(true)
//
//        }
//    }
//}
