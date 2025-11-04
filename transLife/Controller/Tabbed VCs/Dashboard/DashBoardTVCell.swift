//
//  DashBoardTVCell.swift
//  transLife
//
//  Created by Developer Silstone on 10/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class DashboardTVCell: UITableViewCell {

    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    @IBOutlet weak var textLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
class AnouncementsCell: UITableViewCell {
    
    @IBOutlet weak var BackgroundImg: UIImageView!
    
    @IBOutlet weak var BlurForLockCell: UIVisualEffectView!
    @IBOutlet weak var alertImg: UIImageView!
    @IBOutlet weak var newEventsLabel: UILabel!
    @IBOutlet weak var HeadlineLabel: UILabel!
    @IBOutlet weak var ClickhereLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
class MoodLogCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

class QuestionOfTheDayCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

class EventsCell: UITableViewCell {
    
    @IBOutlet weak var noeventslbl: UILabel!
    @IBOutlet weak var firstEventDateLbl: UILabel!
    @IBOutlet weak var firstEventMonthLbl: UILabel!
    @IBOutlet weak var SecondEventDateLbl: UILabel!
    @IBOutlet weak var SecondEventMonthLbl: UILabel!
    @IBOutlet weak var thirdEventDateLbl: UILabel!
    @IBOutlet weak var thirdEventMonthLbl: UILabel!
    @IBOutlet weak var CountremainingEventsLbl: UILabel!
    @IBOutlet weak var firstEventDateView: UIView!
    @IBOutlet weak var secondEventDateView: UIView!
    @IBOutlet weak var thirdEventDateView: UIView!
    @IBOutlet weak var CountremainingEventsDateView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
class SurveysCell: UITableViewCell {
    @IBOutlet weak var ProgressBAR: UIProgressView!
    
    @IBOutlet weak var alertImg: UIImageView!
    @IBOutlet weak var PendingSurveyStatusText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ProgressBAR.layer.cornerRadius = 5
        ProgressBAR.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}



