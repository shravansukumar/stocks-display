//
//  CakeSelectTimelineTableViewCell.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 21/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit

class CakeSelectTimelineTableViewCell: UITableViewCell {

    @IBOutlet var buttonStackView: UIStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setRounding()
    }
    
    private func setRounding() {
        for(index, button) in buttonStackView.subviews.enumerated() {
            if let thisButton = button as? UIButton {
                thisButton.layer.cornerRadius = 2.0
                thisButton.tag = index
                thisButton.addTarget(self, action: #selector(timelineButtonTapped(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc func timelineButtonTapped(_ sender: UIButton) {
        print("button tapped at index: \(sender.tag)")
        for button in buttonStackView.subviews as! [UIButton] {
            button.backgroundColor = .white
        }
        sender.backgroundColor = .red
    }
}
