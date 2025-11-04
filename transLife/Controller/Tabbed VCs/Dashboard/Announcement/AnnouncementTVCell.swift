//
//  AnnouncementTVCell.swift
//  transLife
//
//  Created by Developer Silstone on 18/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class AnnouncementTVCell: UITableViewCell {

    
    @IBOutlet weak var alertImg: UIImageView!
     @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var AnnouncementName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
