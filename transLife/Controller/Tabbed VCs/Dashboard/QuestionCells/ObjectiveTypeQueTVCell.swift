//
//  ObjectiveTypeQueTVCell.swift
//  transLife
//
//  Created by Silstone Group on 09/01/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit


class ObjectiveTypeQueTVCell: UITableViewCell {

   
    
    @IBOutlet weak var OptionTextLbl: UILabel!
    @IBOutlet weak var RadioImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        RadioImg.image = selected ? #imageLiteral(resourceName: "radio_button_selected_blue") : #imageLiteral(resourceName: "radio_button_unselected")
    }

   
    
}
