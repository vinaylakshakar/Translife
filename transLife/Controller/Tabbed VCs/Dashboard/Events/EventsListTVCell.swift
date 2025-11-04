//
//  EventsListTVCell.swift
//  transLife
//
//  Created by Developer Silstone on 17/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit

class EventsListTVCell: UITableViewCell {

    @IBOutlet weak var EventDetailBottomView: UIView!
    @IBOutlet weak var EventImg: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventMonth: UILabel!
    @IBOutlet weak var eventTimeFromTO: UILabel!
    @IBOutlet weak var EventsView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        EventsView.CornerRadius(5)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
      //  contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
