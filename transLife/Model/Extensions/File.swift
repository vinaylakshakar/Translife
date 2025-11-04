//
//  File.swift
//  transLife
//
//  Created by Developer Silstone on 13/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD
import AVFoundation
// MARK:PROTOCOL CLASS

protocol LikertCellDelegate : class {
    func radioBtnStronglyAgree(_ sender: sliderTVCell)
    func radioBtnAgree(_ sender: sliderTVCell)
    func radioBtnStronglyDisagree(_ sender: sliderTVCell)
    func radioBtnDisagree(_ sender: sliderTVCell)
    func radioBtnNeutral(_ sender: sliderTVCell)
}

extension UIViewController {
    
    //MARK: ALERT POP UP
    func PresentAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setValue(NSAttributedString(string:title, attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Semibold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedTitle")
//         alertController.setValue(NSAttributedString(string:message, attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Regular", size: 16) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedMessage")
//        let myString  = "Alert Title"
//        var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
//        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:0,length:myString.characters.count))
//        alertController.setValue(myMutableString, forKey: "attributedTitle")
//        alertController.setValue(myMutableString, forKey: "attributedMessage")

        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       // OKAction.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIColor {
    struct MyMoodColor {
        static var Amazing: UIColor { return hexStringToUIColor(hex: "#FFEE00") }
        static var VeryGood: UIColor { return hexStringToUIColor(hex: "#FF5801") }
        static var Good: UIColor { return hexStringToUIColor(hex: "#FE003A") }
        static var Okay: UIColor { return hexStringToUIColor(hex: "#C501FF") }
        static var NotGood: UIColor { return hexStringToUIColor(hex: "#00FFEE") }
        static var Bad: UIColor { return hexStringToUIColor(hex: "#008DF9") }
        static var Awful: UIColor { return hexStringToUIColor(hex: "#4400CF") }
    }
}
extension String {
    struct MyMoodImage{
        static var Amazing: String { return "amazing_background" }
        static var VeryGood: String { return "verygood_background" }
        static var Good: String { return "good_background" }
        static var Okay: String { return "okay_background" }
        static var NotGood: String { return "notgood_background" }
        static var Bad: String { return "bad_background" }
        static var Awful: String {return "awful_background"}
    }
}
// For Gradient color
extension UIView{
        func setGradientBackground(colorTop:CGColor,colorBottom:CGColor){
            if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
                gradientLayer.colors = [colorTop, colorBottom]
            } else {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
            }
    }
}



//AVPLAYER is PLAying or not
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
//MARK: Validation Password
func isValidPassword(password: String) -> Bool {
    let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,16}"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    let result = passwordTest.evaluate(with: password)
    return result
}
//MARK: Validation Email
func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
func checkCharacterMinimumLength(textField: UITextField) -> Bool {
    if textField.text!.count < 3{
 
        return false
    }else{
       
        return true
    }
    
}


func checkMaxLength(textField: UITextField!, maxLength: Int) {
    if (textField.text!.count > maxLength) {
        textField.deleteBackward()
    }
}
func CheckIfStringContainSpace(string: String) -> Bool {
    return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
}

//MARK:STRING TO DATE
   public func StringToDate( dateString: String)-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        //according to date format your date string
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError()
        }
        
        return date
        
    }

//MARK:CORNER READIUS AND BORDER WIDTH
extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension UIView {
    public func CornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    

     func BorderWith(Width:CGFloat,color:UIColor) {
        layer.borderWidth = Width
        layer.borderColor = color.cgColor
    }
}
//MARK: NAVIGATION OF VIEWCONTROLLER
public func PushTo(FromVC:UIViewController,ToStoryboardID:String){
    let mstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: UIViewController = mstoryboard.instantiateViewController(withIdentifier: ToStoryboardID)
    FromVC.navigationController?.pushViewController(viewController, animated: true)
}
public func PresentTo(FromVC:UIViewController,ToStoryboardID:String){
    let mstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: UIViewController = mstoryboard.instantiateViewController(withIdentifier: ToStoryboardID)
    FromVC.present(viewController, animated: true, completion: nil)
}

  public  func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }


extension UIView {
    func dropShadowTransLife(){
        layer.shadowColor = hexStringToUIColor(hex: "#000000").cgColor
        layer.shadowOpacity = 0.20
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.shadowRadius = 2
        layer.masksToBounds = false
        
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = hexStringToUIColor(hex: "#000000").cgColor
        layer.shadowOpacity = 0.36
        layer.shadowOffset = CGSize(width:0, height:0)
        layer.shadowRadius = 3
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.33, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension UILabel {
    func addCharacterSpacing(kernValue: Double = 0.4) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
//MARK: DATE EXTENSION
extension Date {
    
    var timeAgoSinceNow: String {
        return getTimeAgoSinceNow()
    }
    
    private func getTimeAgoSinceNow() -> String {
        
        var interval = Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " year" : "\(interval)" + " years"
        }
        
        interval = Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " month" : "\(interval)" + " months"
        }
        
        interval = Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " day" : "\(interval)" + " days"
        }
        
        interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " hour" : "\(interval)" + " hours"
        }
        
        interval = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " minute" : "\(interval)" + " minutes"
        }
        
        return "a moment ago"
    }
}


extension UIView {

    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
