//
//  BaselineSurveyTVCell.swift
//  transLife
//
//  Created by Developer Silstone on 06/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class BaselineSurveyTVCell: UITableViewCell {

    @IBOutlet weak var quesText: UILabel!
  @IBOutlet weak var answerIsYesBtn: UIButton!
    @IBOutlet weak var answerIsNoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
class BaslineSurveyPartOneTVCell : UITableViewCell{
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
