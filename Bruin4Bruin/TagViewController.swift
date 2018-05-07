//
//  TagViewController.swift
//  Bruin4Bruin
//
//  Created by Chayada Somrit on 5/7/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

@IBDesignable class TagViewController: UIStackView {

    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setupTags(tags: [String]) {
        for String in tags {
            setUpTag(tag: String)
        }
    }
    
    private func setUpTag(tag: String) {
        let button = UIButton()
        
        addArrangedSubview(button)
        //        button.setTitle(<#T##title: String?##String?#>, for: .normal)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
