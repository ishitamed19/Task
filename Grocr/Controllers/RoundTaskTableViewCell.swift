//
//  RoundTaskTableViewCell.swift
//  Grocr
//
//  Created by Ishita Mediratta on 09/07/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import UIKit

class RoundTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
