//
//  AddEventsCV.swift
//  transLife
//
//  Created by Developer Silstone on 17/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import MapKit
import IQKeyboardManagerSwift

class AddEventsVC: UIViewController {
    
    @IBOutlet weak var mytableview: UITableView!
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    let locationManager = CLLocationManager()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    let searchController = UISearchController(searchResultsController: nil)
    var location = [String:CLLocationDegrees]()
    @IBOutlet weak var EventTitleTextField: UITextField!
    @IBOutlet weak var ContactTextField: UITextField!
    @IBOutlet weak var Address1TextField: UITextField!
    @IBOutlet weak var Address2TextField: UITextField!
    @IBOutlet weak var Address3TextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var TimePickerBottom: NSLayoutConstraint!
    @IBOutlet weak var DescriptionText: UITextView!
    @IBOutlet weak var MyTimePicker: UIDatePicker!
    @IBOutlet weak var EventImg: UIImageView!
    @IBOutlet weak var DateFieldLbl: UILabel!
    @IBOutlet weak var FromLbl: UILabel!
    @IBOutlet weak var ToLbl: UILabel!
    @IBOutlet weak var FromView: UIView!
    @IBOutlet weak var ToView: UIView!
    @IBOutlet weak var dateView: UIView!
    
    var fromTo = false
    let createEvents = Events()
    var dateDayString:String?
    var dateMonthString:String?
    var eventStamp = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TimePickerBottom.constant = -170
        
        //HideKeyboard()
          handleNotificationKeyboard()
        txtfieldPlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mytableview.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func address1txtEditingChanged(_ sender: Any) {
        
        if Address1TextField.text?.count == 0 {
            mytableview.isHidden = true
            // Address1TextField.resignFirstResponder()
        } else {
            searchText(Address1TextField.text)
        }
        
    }
    //MARK:- placeholder Attributes
    func txtfieldPlaceholder() {
        EventTitleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        Address1TextField.attributedPlaceholder = NSAttributedString(string: "Address Line 1", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        Address2TextField.attributedPlaceholder = NSAttributedString(string: "Address Line 2", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        Address3TextField.attributedPlaceholder = NSAttributedString(string: "Address Line 3", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        ContactTextField.attributedPlaceholder = NSAttributedString(string: "Phone", attributes: [
            .foregroundColor: hexStringToUIColor(hex: "#AFAFAF"),
            .font: UIFont(name:"SegoeUI-Semibold", size: 18) as Any
            ])
        
    }
    
    //MARK:-Handle Keyboard
    func handleNotificationKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(AddEventsVC.keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddEventsVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
            
            IQKeyboardManager.shared.keyboardDistanceFromTextField = self.view.frame.height - 60 - keyboardViewEndFrame.height
            //  scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 100, right: 0)
            
            //  scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
            IQKeyboardManager.shared.keyboardDistanceFromTextField = 20
            mytableview.isHidden = true
            // ScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - 100, right: 0)
            //  scrollView.contentOffset = CGPoint(x: 0, y: keyboardViewEndFrame.height - 150)
            
        }
        
    }
    func HideKeyboard() {
        let tap :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func DismissKeyboard() {
        UIView.animate(withDuration: 0.4, animations: {
            self.TimePickerBottom.constant = -170
            self.ToView.borderColorV = hexStringToUIColor(hex: "#D6D6D6")
            self.FromView.borderColorV = hexStringToUIColor(hex: "#D6D6D6")
            self.dateView.borderColorV = hexStringToUIColor(hex: "#D6D6D6")
            self.view.layoutIfNeeded()
        }, completion: nil)
        view.endEditing(true)
    }
    
    // MARK: - ACTIONS
    
    @IBAction func BackBtnAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:SETUP FOR TIME
    @IBAction func fromBtnAct(_ sender: Any) {
        fromTo = false
        MyTimePicker.datePickerMode = .time
        MyTimePicker.minimumDate = nil
        UIView.animate(withDuration: 0.4, animations: {
            self.view.endEditing(true)
            self.TimePickerBottom.constant = 0
            self.FromView.borderColorV = hexStringToUIColor(hex: "#003644")
            self.ToView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.dateView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.scrollView.contentOffset = CGPoint(x: 0, y: 700)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    @IBAction func ToBtnAct(_ sender: Any) {
        fromTo = true
        MyTimePicker.datePickerMode = .time
        MyTimePicker.minimumDate = nil
        UIView.animate(withDuration: 0.4, animations: {
            self.view.endEditing(true)
            self.TimePickerBottom.constant = 0
            self.ToView.borderColorV = hexStringToUIColor(hex: "#003644")
            self.FromView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.dateView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.scrollView.contentOffset = CGPoint(x: 0, y: 700)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func contacTextfldAct(_ sender: Any) {
    }
    //MARK:PICKER VALUE CHANGED
    @IBAction func GetTimeAction(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        if MyTimePicker.datePickerMode == .time{
            if fromTo == false{
                FromLbl.text = formatter.string(from: sender.date)
                FromLbl.textColor = hexStringToUIColor(hex: "#003644")
                FromLbl.font = UIFont(name:"SegoeUI-Regular", size: 18)
            }else{
                ToLbl.text = formatter.string(from: sender.date)
                ToLbl.textColor = hexStringToUIColor(hex: "#003644")
                ToLbl.font = UIFont(name:"SegoeUI-Regular", size: 18)
            }
        }else if MyTimePicker.datePickerMode == .date{
            MyTimePicker.minimumDate = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.dateFormat = "yyyy"
            let year: String = formatter.string(from: sender.date)
            formatter.dateFormat = "LLL"
            let month: String = formatter.string(from: sender.date)
            formatter.dateFormat = "dd"
            let day: String = formatter.string(from: sender.date)
            dateDayString = day
            dateMonthString = month
            DateFieldLbl.text = "\(month) \(day), \(year)"
            // DateFieldLbl.text = formatter.string(from: sender.date)
            DateFieldLbl.textColor = hexStringToUIColor(hex: "#003644")
            DateFieldLbl.font = UIFont(name:"SegoeUI-Regular", size: 18)
        }
    }
    
    @IBAction func DoneTabItem(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        if MyTimePicker.datePickerMode == .time{
            if fromTo == false{
                FromLbl.text = formatter.string(from: MyTimePicker.date)
                FromLbl.textColor = hexStringToUIColor(hex: "#003644")
                FromLbl.font = UIFont(name:"SegoeUI-Regular", size: 18)
            }else{
                ToLbl.text = formatter.string(from: MyTimePicker.date)
                ToLbl.textColor = hexStringToUIColor(hex: "#003644")
                ToLbl.font = UIFont(name:"SegoeUI-Regular", size: 18)
            }
        }else if MyTimePicker.datePickerMode == .date{
            MyTimePicker.minimumDate = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            let eventDate = MyTimePicker.date.timeIntervalSince1970
            eventStamp = Int(eventDate)
            formatter.dateFormat = "yyyy"
            let year: String = formatter.string(from: MyTimePicker.date)
            formatter.dateFormat = "LLL"
            let month: String = formatter.string(from: MyTimePicker.date)
            formatter.dateFormat = "dd"
            let day: String = formatter.string(from: MyTimePicker.date)
            DateFieldLbl.text = "\(month) \(day), \(year)"
            // DateFieldLbl.text = formatter.string(from: sender.date)
            DateFieldLbl.textColor = hexStringToUIColor(hex: "#003644")
            DateFieldLbl.font = UIFont(name:"SegoeUI-Regular", size: 18)
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.TimePickerBottom.constant = -170
            self.dateView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.ToView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.FromView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    @IBAction func eventTitleActionValidation(_ sender: Any) {
        checkMaxLength(textField:EventTitleTextField, maxLength: 97)
    }
    @IBAction func contactActionValidation(_ sender: Any) {
     checkMaxLength(textField: ContactTextField, maxLength: 13)
    }
    //MARK:CREATING EVENT (FIREBASE)
    @IBAction func DoneBtnAction(_ sender: Any) {
        guard let eventTitle = EventTitleTextField.text else{return}
        guard let Address1 = Address1TextField.text else{return}
        guard let Address2 = Address2TextField.text else{return}
        guard let Address3 = Address3TextField.text else{return}
        guard let Contact = ContactTextField.text else{return}
        guard let date = DateFieldLbl.text else{return}
        guard let FromTime = FromLbl.text else{return}
        guard let ToTime = ToLbl.text else{return}
        guard let DescriptionText = DescriptionText.text else{return}
//        if EventImg.image == UIImage(named: "image_placeholder"){
//            PresentAlert(message: "please choose an image.", title: "TransLife")        }
        if eventTitle == "" || Address1 == "" || Address2 == "" {
            PresentAlert(message: "please fill all fields.", title: "TransLife")
        }
        if date == "Select"{
            PresentAlert(message: "Date of The Event must be filled.", title: "TransLife")
        }
        if  FromTime == "From" || ToTime == "To"{
            PresentAlert(message: "Event Timing must be filled.", title: "TransLife")
        }
        let alertController = UIAlertController(title: "TransLife", message: "Make sure all fields filled correctly. Events are uneditable once submitted.", preferredStyle: .alert)
        alertController.setValue(NSAttributedString(string:"TransLife", attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
        
        // Create the actions
        let okAction = UIAlertAction(title: "submit", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let dict = ["EventTitle":eventTitle,"Address1":Address1,"Address2":Address2,"Address3":Address3,"Contact":Contact,"EventTimeFromTO":"\(FromTime) - \(ToTime)","DescriptionText":DescriptionText,"EventImageUrl":"could't get url","EventTimeStamp":self.eventStamp,"latitude":self.latitude,"longitude":self.longitude] as [String : AnyObject]

            self.createEvents.createEvent(Dict: dict, view: self, completionHandler: { (dataref) in
                if  let snapKey = dataref.key {
                    self.createEvents.saveImgToStorage(ImgId:snapKey, image: self.EventImg.image ?? #imageLiteral(resourceName: "app_icon"), view: self) { (metadata) in
                        let storageRef = Storage.storage().reference().child("EventImages/\(snapKey).png")
                        storageRef.downloadURL(completion: { (ImgUrl, error) in
                            if let error = error{
                                SVProgressHUD.dismiss()
                                self.PresentAlert(message: error.localizedDescription, title: "TransLife")
                            }else{
                                let imgUrl = ImgUrl?.absoluteString
                                ref.child("Events").child("\(snapKey)").updateChildValues(["EventImageUrl" : imgUrl ?? "did't get url"])
                                SVProgressHUD.dismiss()
                            }
                        })
                    }

                    
                }
            })
            
            needrefreshforEvents = true
            needToRefresh = true
            NSLog("OK Pressed")
        }
        let cancelAction = UIAlertAction(title: "Edit", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    //MARK:SETUP FOR DATE
    
    @IBAction func DateBtnPressed(_ sender: Any) {
        MyTimePicker.datePickerMode = .date
        UIView.animate(withDuration: 0.4, animations: {
            self.view.endEditing(true)
            self.dateView.borderColorV = hexStringToUIColor(hex: "#003644")
            self.FromView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.ToView.borderColorV = hexStringToUIColor(hex: "#AFAFAF")
            self.TimePickerBottom.constant = 0
            self.scrollView.contentOffset = CGPoint(x: 0, y: 600)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @IBAction func ImgBtnAct(_ sender: Any)
    {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            else{
                self.PresentAlert(message: "Camera not available.", title: "TransLife")
                
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action : UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    //MARK:PARSE ADDRESS FROM MKPLACEMARK
    func parseAddress(selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    // MARK: - Custom search Method
    func searchText(_ text: String?) {
        let searchRequest = MKLocalSearch.Request()
        let typedData = text
        if (typedData == "") {
        } else {
            searchRequest.naturalLanguageQuery = typedData
            // searchRequest.region = searchedRegion
            // Create the local search to perform the search
            let localSearch = MKLocalSearch(request: searchRequest)
            
            //[ProgressHUD show];
            localSearch.start(completionHandler: { response, error in
                if error == nil {
                    
                    //[ProgressHUD dismiss];
                    if let map = response?.mapItems {
                        self.matchingItems = map
                    }
                    
                    if self.matchingItems.count >= 1 {
                        self.mytableview.isHidden = false
                        self.mytableview.delegate = self
                        self.mytableview.dataSource = self
                        self.mytableview.reloadData()
                    } else {
                        self.mytableview.isHidden = true
                    }
                } else {
                    print("Search Request Error: \(error?.localizedDescription ?? "")")
                }
            })
        }
        
    }
    
}
extension AddEventsVC : CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        //  mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}
extension AddEventsVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressSearchTVCell", for: indexPath) as! addressSearchTVCell
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.addressTitle.text = selectedItem.name
        cell.addressSubTitle.text = parseAddress(selectedItem: selectedItem)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
extension AddEventsVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mytableview.isHidden = true
        let selectedItem = matchingItems[indexPath.row].placemark
        latitude = selectedItem.coordinate.latitude
        longitude = selectedItem.coordinate.longitude
//        location.updateValue(selectedItem.coordinate.latitude, forKey: "latitude")
//        location.updateValue(selectedItem.coordinate.longitude, forKey: "longitude")
        let address:[String] = selectedItem.title?.components(separatedBy:",") ?? [""]
        Address1TextField.text = selectedItem.name
        if address.count == 2{
            Address2TextField.text = "\(address[0]),\(address[1])"
        }else  if address.count == 3{
            Address2TextField.text = "\(address[0]),\(address[1])"
            Address3TextField.text = "\(address[2])"
        }else  if address.count >= 4{
            Address2TextField.text = "\(address[0]),\(address[1])"
            Address3TextField.text = "\(address[2]),\(address[3])"
        }
    }
}
extension AddEventsVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
   
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let orignalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = orignalImage
        }
        if let selectedImage = selectedImageFromPicker {
            self.EventImg.image = selectedImage
            self.EventImg.contentMode = .scaleToFill
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension AddEventsVC:UITextViewDelegate{
    //MARK:HANDLE TEXT VIEW
    func textViewDidBeginEditing(_ textView: UITextView) {
        if DescriptionText.text == "Use this space to describe events..."{
            DescriptionText.text = ""
        }
    }
}
extension AddEventsVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if EventTitleTextField.isEditing == true{
            Address1TextField.becomeFirstResponder()
        }else if Address1TextField.isEditing == true{
            Address2TextField.becomeFirstResponder()
        }else if Address2TextField.isEditing == true{
            Address3TextField.becomeFirstResponder()
        }else if Address3TextField.isEditing == true{
            ContactTextField.becomeFirstResponder()
        }else if ContactTextField.isEditing == true {
            ContactTextField.resignFirstResponder()
            self.dateView.borderColorV = hexStringToUIColor(hex: "#003644")
        }
        
        return true
    }

}
