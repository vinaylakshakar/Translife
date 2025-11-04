//
//  LocalDetailVC.swift
//  transLife
//
//  Created by Developer Silstone on 13/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocalDetailVC: UIViewController {
    
    @IBOutlet weak var mapview: MKMapView!
    var mapView: MKMapView?
    let locationManager = CLLocationManager()
    var localDetail = NSDictionary()
    @IBOutlet weak var ratingStackView: RatingController!
    @IBOutlet weak var occupationLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var address1Lbl: UILabel!
    @IBOutlet weak var address2Lbl: UILabel!
    @IBOutlet weak var address3Lbl: UILabel!
    @IBOutlet weak var contact: UITextView!
    @IBOutlet weak var phoneIconHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionText: UITextView!
    // @IBOutlet weak var descriptionText: UILabel!
    var LocalLocation = ""
    var address1 = ""
    var address2 = ""
    var address3 = ""
    var Lat = CLLocationDegrees()
    var Long = CLLocationDegrees()
    var installedNavigationApps : [String] = ["Apple Maps"] // Apple Maps is always installed
    
    //MARK:LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.CornerRadius(profileImg.frame.height/2)
        
    }
    
    func setUpLocalDetails() {
        needRefreshforlocal = false
        guard let add1 = localDetail["Address1"] else{return}
        guard let add2 = localDetail["Address2"] else{return}
        guard let add3 = localDetail["Address3"] else{return}
        Lat = localDetail["latitude"] as? Double ?? 0
        Long = localDetail["longitude"] as? Double ?? 0
        let snapkey = localDetail["snapKey"] 
        ratingStackView.snapKey = snapkey as? String ?? ""
        address1 = add1 as! String
        address2 = add2 as! String
        address3 = add3 as! String
        nameLbl.text = localDetail["name"] as? String
        occupationLbl.text = localDetail["occupation"] as? String
        descriptionText.text = localDetail["DescriptionText"] as? String
        address1Lbl.text = add1 as? String
        address2Lbl.text = add2 as? String
        address3Lbl.text = add3 as? String
        let contactNo = localDetail["Contact"] as? String
        contact.text = contactNo
        if contactNo == ""{
            phoneIconHeight.constant = 0
        }else{
            phoneIconHeight.constant = 47
        }
        if let starcount = (localDetail["LocalRating"] as? Int){
            ratingStackView.setStarsRating(rating:starcount)
        }
        let urlStr = localDetail["ProfileImageUrl"] as! String
        let Imgurl = URL(string:urlStr )
        profileImg.sd_setImage(with:Imgurl , placeholderImage: #imageLiteral(resourceName: "image_placeholder"))
        // descriptionText.isScrollEnabled = true
        let height = self.descriptionText.contentSize.height
        ViewHeight.constant = 900 + height
        // textViewHeight.constant = height
        LocalLocation = "\(address1),\(address2)"
        let annotation = MKPointAnnotation()
        annotation.title = LocalLocation
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.Lat, longitude:self.Long)
        mapview.addAnnotation(annotation)
        mapview.selectAnnotation(annotation, animated: true)
        print(descriptionText.frame)
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpLocalDetails()
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            self.installedNavigationApps.append("comgooglemaps://")
        } else {
            // do nothing
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    //MARK:ACTIONS
    
    
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func getDirectionBtnAct(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select navigation app", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Google maps", style: .default, handler: { (action : UIAlertAction) in
            //            self.coordinates(forAddress: self.LocalLocation) {
            //                        (location) in
            //                        guard let location = location else {
            //                            // Handle error here.
            //                            return
            //                        }
            //MARK: FOR GOOGLE MAP
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
            {
                UIApplication.shared.openURL(NSURL(string:
                    "comgooglemaps://?saddr=&daddr=\(self.Lat),\(self.Long)&directionsmode=driving")! as URL)
            } else
            {
                NSLog("Can't use com.google.maps://");
            }
            //         }
        }))
        actionSheet.addAction(UIAlertAction(title: "Apple maps", style: .default, handler: { (action : UIAlertAction) in
            //MARK: FOR APPLE MAPKIT
            let coordinate = CLLocationCoordinate2DMake(self.Lat,self.Long)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = self.LocalLocation
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                self.PresentAlert(message: "invalid address" , title: "TransLife")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    func dropPinZoomIn(placemark: MKPlacemark){
        
        mapview.removeAnnotations(mapview.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapview.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapview.setRegion(region, animated: true)
    }
    
    
}
extension LocalDetailVC : CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.Lat, longitude: self.Long), span: span)
        mapview?.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}
extension LocalDetailVC:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "location_local")
            annotationView.canShowCallout = true
            
            return annotationView
        }
    }
}

