//
//  GroupSummaryTableViewCell.swift
//  memorize
//
//  Created by John goodstadt on 16/05/2019.
//  Copyright © 2019 John Goodstadt. All rights reserved.
//

import UIKit

class GroupSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryTitleLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 13.0, *) {
            titleLabel.textColor = UIColor.label
            summaryTitleLabel.textColor = UIColor.secondaryLabel
            label1.textColor = UIColor.secondaryLabel
            label2.textColor = UIColor.secondaryLabel
            label3.textColor = UIColor.secondaryLabel
        }
    }    
}
