//
//  PrettyButton.swift
//  Bruin4Bruin
//
//  Created by Changyuan Lin on 5/14/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

@IBDesignable class PrettyButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makePretty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makePretty()
    }
    
    private func makePretty() {
        
        // Standard stuff
        setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        self.tintColor = .white
        
        // Special stuff
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.75
        self.layer.cornerRadius = 6
        
    }

}
