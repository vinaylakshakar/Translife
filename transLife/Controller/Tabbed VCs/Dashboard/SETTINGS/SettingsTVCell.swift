//
//  SettingsTVCell.swift
//  transLife
//
//  Created by Developer Silstone on 21/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class SettingsTVCell: UITableViewCell {

    @IBOutlet weak var settingTypeLbl: UILabel!
    
    @IBOutlet weak var SwitchBtn: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
