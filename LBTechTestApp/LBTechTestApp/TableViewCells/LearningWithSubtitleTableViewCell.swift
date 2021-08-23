//
//  AccountTableViewCell.swift
//  memorize
//
//  Created by John goodstadt on 28/03/2018.
//  Copyright © 2018 John Goodstadt. All rights reserved.
//

import UIKit

class LearningWithSubtitleTableViewCell: UITableViewCell {
   
    @IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 13.0, *) {
            titleLabel.textColor = UIColor.label
			subtitleLabel.textColor = UIColor.secondaryLabel
        }
        
    }
}
