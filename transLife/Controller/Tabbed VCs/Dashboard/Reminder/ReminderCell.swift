//
//  DateCell.swift
//  ctb
//
//  Created by Silstone Group on 28/06/19.
//  Copyright © 2019 Silstone Group. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var reminderDate: UILabel!
    @IBOutlet weak var reminderTime: UILabel!
    @IBOutlet weak var reminderTextView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()

//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
