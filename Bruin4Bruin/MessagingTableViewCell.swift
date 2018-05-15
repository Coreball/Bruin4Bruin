//
//  MessagingTableViewCell.swift
//  Bruin4Bruin
//
//  Created by Changyuan Lin on 5/11/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

class MessagingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLeft() {
        message.textAlignment = .left
        timestamp.textAlignment = .left
    }
    
    func setRight() {
        message.textAlignment = .right
        timestamp.textAlignment = .right
    }

}
