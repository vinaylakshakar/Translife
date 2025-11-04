//
//  MoodLogNotesVC.swift
//  transLife
//
//  Created by Developer Silstone on 19/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD

class MoodLogNotesVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var SubmitBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var ViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TextViewHeight: NSLayoutConstraint!
     let locationManager = CLLocationManager()
    var UserMoodLog = MoodLog()
    weak var delegate: locationStartAndStopDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HideKeyboard()
        // handleNotificationKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        if isLocationOn == true{
             getCurrentLocation()
        }else{
            StopGettingCurrentLocation()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    //MARK:-GETTING LOCATION
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        //self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    //MARK:-STOP GETTING LOCATION
    func StopGettingCurrentLocation() {
        // Ask for Authorisation from the User.
        //self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        PresentAlert(message: "please allow access to current location for transLife in settings.", title: "TransLife")
    }
    //MARK:-LOCATION MANAGER DELEGATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        locationManager.stopMonitoringSignificantLocationChanges()
        // let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
        guard let lat =  currentLocation?.coordinate.latitude else{return}
        guard let long =  currentLocation?.coordinate.longitude else{return}//manager.location?.coordinate else { return }
        print("locations = \(lat) \(long)")
        let location = ["latitude":lat,"longitude":long]
        MoodLogData.updateValue(location, forKey: "CurrentLocation")
        
        locationManager.stopUpdatingLocation()
    }
    

    //MARK:-Handle Keyboard
    func handleNotificationKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(MoodLogNotesVC.keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MoodLogNotesVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
            ScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 10, right: 0)
            print(keyboardViewEndFrame)
            print(ScrollView.contentInset.bottom)
            ScrollView.scrollIndicatorInsets = ScrollView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        //  ScrollView.contentOffset = .zero
        
    }
    
    func HideKeyboard() {
        let tap :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:ACTIONS
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SubmitBtnAct(_ sender: Any) {
        SVProgressHUD.show()
        let currentDateTime = Date()
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        // get the date time String from the date object
        let time = formatter.string(from: currentDateTime)
        MoodLogData.updateValue(time, forKey: "time")
        MoodLogData.updateValue(TextView.text, forKey: "Notes")
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        UserDefaults.standard.set(true, forKey: "userhasloggedmood")
        UserDefaults.standard.set(currentTimestamp, forKey: "lastmoodloggedstamp")
        UserDefaults.standard.set(MoodLogData["mood"], forKey: "mood")
       // userDefaultHaveMoodData = true
        MoodLogData.updateValue(currentTimestamp, forKey: "currentTimeStamp")
        UserMoodLog.SaveMoodLogWith(Dict: MoodLogData, view: self) { (error, dataRef) in
            if let error = error {
                self.PresentAlert(message: error.localizedDescription, title: "TransLife")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginView = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            UIApplication.shared.keyWindow?.rootViewController = loginView
            let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
            tabBarController.selectedIndex = 0
        }
    }
}
extension MoodLogNotesVC:UITextViewDelegate{
    //MARK:HANDLE TEXT VIEW
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Use this space to log your thoughts or events...."{
            TextView.text = ""
        }
    }
    
    
}

