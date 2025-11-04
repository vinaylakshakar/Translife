//
//  SelectFeelingCVCell.swift
//  transLife
//
//  Created by Developer Silstone on 11/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class SelectFeelingCVCell: UICollectionViewCell {
    
    @IBOutlet weak var FeelingsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        FeelingsLabel.layer.cornerRadius = FeelingsLabel.frame.height/2
        FeelingsLabel.clipsToBounds = true
        
    }
    
}
class MoodAddFeelingsCell:UICollectionViewCell{
    @IBOutlet weak var FeelingsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        FeelingsLabel.layer.cornerRadius = 19
        FeelingsLabel.clipsToBounds = true
    }
}
class MoodAddReasonsCell:UICollectionViewCell{
    @IBOutlet weak var reasonsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        reasonsLabel.layer.cornerRadius = 19
        reasonsLabel.clipsToBounds = true
    }
}
