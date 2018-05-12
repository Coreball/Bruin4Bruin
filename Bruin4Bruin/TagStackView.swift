//
//  TagViewController.swift
//  Bruin4Bruin
//
//  Created by Chayada Somrit on 5/7/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

@IBDesignable class TagStackView: UIStackView {

    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTags(tags: [" art ", "gaming", "literature", "music", "volunteering"])
        setUpHorizontalStack()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpTags(tags: [" art ", "gaming", "literature", "music", "volunteering"])
        setUpHorizontalStack()
    }
    
    public func setUpTags(tags: [String]) {
        for String in tags {
            setUpTag(tag: String)
        }
    }
    
    private func setUpHorizontalStack() {
        let stack = UIStackView()
        stack.axis = .horizontal
        addArrangedSubview(stack)
    }
    
    private func setUpTag(tag: String) {
        let button = UIButton()
        button.setTitle(tag, for: .normal)
        if button.state == .normal {
            button.setTitleColor(UIColor.blue, for: .normal)
            button.backgroundColor = UIColor.white
        } else if button.state == .highlighted {
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.backgroundColor = UIColor.blue
        }
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        //button.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        addArrangedSubview(button)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
