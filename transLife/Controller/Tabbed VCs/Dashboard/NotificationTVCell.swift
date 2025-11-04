//
//  NotificationTVCell.swift
//  transLife
//
//  Created by Silstone Group on 29/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit

class NotificationTVCell: UITableViewCell {

    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var clickHereLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
