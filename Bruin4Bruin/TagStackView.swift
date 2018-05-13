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
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func loadWithID(for index: Int) {
        let hobbies = ["art and crafts", "cooking", "dance", "fishing", "gardening", "gaming", "hiking", "literature", "music", "pop culture", "skiing", "traveling", "volunteering"]
        let sports = ["badminton", "baseball", "basketball", "cheer", "cross country", "field hockey", "football", "golf", "gymnastics", "ice hockey", "lacrosse", "poms", "soccer", "softball", "swim and dive", "tennis", "track and field", "volleyball", "wrestling"]
        let electives = ["art", "band", "choir", "comp sci", "debate", "orchestra", "senate", "theater"]
        let match = ["underclassmen", "upperclassmen"]
        if index == 0 {
            setUpTags(tags: hobbies)
        } else if index == 1 {
            setUpTags(tags: sports)
        } else if index == 2 {
            setUpTags(tags: electives)
        } else {
            setUpTags(tags: match)
        }
    }
    
    private func setUpTags(tags: [String]) {
        var isLastElement = false
        var count = 0
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        addArrangedSubview(stack)
        while isLastElement == false {
            for String in tags {
                let tag = String
                let button = UIButton()
                button.setTitle(tag, for: .normal)
                if button.state == .normal {
                    button.setTitleColor(UIColor.blue, for: .normal)
                    button.backgroundColor = UIColor.white
                } else if button.state == .selected {
                    button.setTitleColor(UIColor.white, for: .selected)
                    button.backgroundColor = UIColor.blue
                }
                button.layer.cornerRadius = 8
                button.clipsToBounds = true
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                stack.addArrangedSubview(button)
                count += 1
                if count == 3 {
                    stack = UIStackView()
                    stack.axis = .horizontal
                    stack.spacing = 10
                    addArrangedSubview(stack)
                    count = 0
                }
                if String == tags[tags.endIndex - 1] {
                    isLastElement = true
                }
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
