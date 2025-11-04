//
//  InsightTVCell.swift
//  transLife
//
//  Created by Developer Silstone on 19/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class InsightTVCell: UITableViewCell {

    var gradientLayer: CAGradientLayer!
    @IBOutlet weak var MoodLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var amPmLbl: UILabel!
    @IBOutlet weak var FeelingLbl1: UILabel!
    @IBOutlet weak var FeelingLbl2: UILabel!
    @IBOutlet weak var FeelingLbl3: UILabel!
    @IBOutlet weak var FeelingLbl4: UILabel!
    @IBOutlet weak var FeelingLbl5: UILabel!
    @IBOutlet weak var FeelingLbl6: UILabel!
    
    @IBOutlet weak var moodImg: UIImageView!
    @IBOutlet weak var BackView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.AddShadow()
        
        
    }
    //MARK:UPDATE UI
    func AddShadow() {
        FeelingLbl1.CornerRadius(9.5)
        FeelingLbl2.CornerRadius(FeelingLbl1.frame.height/2)
        FeelingLbl3.CornerRadius(FeelingLbl1.frame.height/2)
        FeelingLbl4.CornerRadius(FeelingLbl1.frame.height/2)
        FeelingLbl5.CornerRadius(FeelingLbl1.frame.height/2)
        FeelingLbl6.CornerRadius(FeelingLbl1.frame.height/2)
//        FeelingLbl1.dropShadowTransLife()
//        FeelingLbl2.dropShadowTransLife()
//        FeelingLbl3.dropShadowTransLife()
//        FeelingLbl4.dropShadowTransLife()
//        FeelingLbl5.dropShadowTransLife()
//        FeelingLbl6.dropShadowTransLife()
        BackView.CornerRadius(5)
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
