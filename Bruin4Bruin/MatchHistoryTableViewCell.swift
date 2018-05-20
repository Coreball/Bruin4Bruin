//
//  MatchHistoryTableViewCell.swift
//  Bruin4Bruin
//
//  Created by Changyuan Lin on 5/19/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

class MatchHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var partnerName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
