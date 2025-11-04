//
//  StackChartBarCVCell.swift
//  transLife
//
//  Created by Silstone Group on 04/02/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit

class StackChartBarCVCell: UICollectionViewCell {
    
  
    @IBOutlet weak var redColorAwfulHeight: NSLayoutConstraint!
    @IBOutlet weak var purpleColorBadHeight: NSLayoutConstraint!
     @IBOutlet weak var BlueColorNotGoodHeight: NSLayoutConstraint!
     @IBOutlet weak var skyblueColorOkayHeight: NSLayoutConstraint!
     @IBOutlet weak var greenColorGoodHeight: NSLayoutConstraint!
     @IBOutlet weak var orangeColorVeryGoodHeight: NSLayoutConstraint!
     @IBOutlet weak var yellowColorAmazingHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewContainedStacks: UIView!
}



class StackChartBarDateMonthCVCell: UICollectionViewCell {
    
    @IBOutlet weak var dateOrMonthLbl: UILabel!
}
