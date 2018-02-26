//
//  CakeSelectTimelineTableViewCell.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 21/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit

class CakeSelectTimelineTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet var buttonStackView: UIStackView!
    
    // MARK: - Constants
    let color = UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupButtons()
    }
    
    // MARK: - Private Methods
    private func setupButtons() {
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
            sender.titleLabel?.textColor = .black
        }
        sender.backgroundColor = color
        sender.titleLabel?.textColor = .white
    }
}
