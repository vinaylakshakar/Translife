//
//  ResearchTVCell.swift
//  transLife
//
//  Created by Developer Silstone on 10/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class ResearchTVCell: UITableViewCell {

    @IBOutlet weak var MainCellView: UIView!
    @IBOutlet weak var ImgAlert: UIImageView!
    @IBOutlet weak var LblSurveyNo: UILabel!
    @IBOutlet weak var LblSurveyType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
         MainCellView.CornerRadius(5)
        MainCellView.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.16, offSet: CGSize(width: 0, height: 0), radius: 3, scale: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
