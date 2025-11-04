//
//  LocalTVCell.swift
//  transLife
//
//  Created by Developer Silstone on 12/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class LocalTVCell: UITableViewCell {

    @IBOutlet weak var ratingStackView: RatingController!
    @IBOutlet weak var localProfileImg: UIImageView!
    @IBOutlet weak var localOccupation: UILabel!
    @IBOutlet weak var localName: UILabel!
    @IBOutlet weak var BlurView: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        BlurView.CornerRadius(5)
    localProfileImg.CornerRadius(localProfileImg.frame.height/2)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

