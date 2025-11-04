//
//  SurveyTVCell.swift
//  transLife
//
//  Created by Silstone Group on 17/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit

class SurveyTVCell: UITableViewCell {

    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var RadioImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        RadioImg.image = selected ? UIImage(named: "radio_button_selected") : UIImage(named: "radio_button_unselected")
        
    }

}
class MultipleSelectionTvCell:UITableViewCell{
    @IBOutlet weak var questionLbl: UILabel!
    
    @IBOutlet weak var selectAnswerLabel: UILabel!
    @IBOutlet weak var selectAnswerBtn: UIButton!
    
    @IBOutlet weak var viewFordropdown: UIView!
    
    @IBOutlet weak var healthcarelistLabel: UILabel!
}

class TwoOptionTvCell:UITableViewCell{
    @IBOutlet weak var QuestionLbl: UILabel!
    @IBOutlet weak var radioImgNoBtn: UIButton!
    @IBOutlet weak var radioImgYesBtn: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let image = selected ? UIImage(named: "radio_button_selected") : UIImage(named: "radio_button_unselected")
        //RadioImgBtn.setBackgroundImage(image, for: .normal)
        
    }

    
}
class sliderTVCell:UITableViewCell{
    
    @IBOutlet weak var quesLbl: UILabel!
    
    @IBOutlet weak var radioBtnStronglyAgree: UIButton!
     @IBOutlet weak var radioBtnAgree: UIButton!
     @IBOutlet weak var radioBtnNeutral: UIButton!
     @IBOutlet weak var radioBtnDisagree: UIButton!
     @IBOutlet weak var radioBtnStronglyDisagree: UIButton!
    @IBOutlet weak var MySlider: UISlider!
    
    weak var delegate: LikertCellDelegate?
    
    @IBAction func radioBtnAgreeTapped(_ sender: UIButton) {
        self.radioBtnStronglyAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnAgree.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
        self.radioBtnNeutral.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnStronglyDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        delegate?.radioBtnAgree(self)
    }
    
    @IBAction func radioBtnStronglyAgreeTapped(_ sender: UIButton) {
        self.radioBtnStronglyAgree.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
        self.radioBtnAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnNeutral.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnStronglyDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        delegate?.radioBtnStronglyAgree(self)
    }
    @IBAction func radioBtnNeutralTapped(_ sender: UIButton) {
        self.radioBtnStronglyAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnNeutral.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
        self.radioBtnDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnStronglyDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        
        delegate?.radioBtnNeutral(self)
    }
    
    @IBAction func radioBtnDisagree(_ sender: UIButton) {
        self.radioBtnStronglyAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnNeutral.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnDisagree.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
        self.radioBtnStronglyDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        delegate?.radioBtnDisagree(self)
    }
    @IBAction func radioBtnStronglyDisagreeTapped(_ sender: UIButton) {
        self.radioBtnStronglyAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnAgree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnNeutral.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnDisagree.setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
        self.radioBtnStronglyDisagree.setBackgroundImage(UIImage(named: "radio_button_selected"), for: .normal)
        delegate?.radioBtnStronglyDisagree(self)
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
