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
        for button in buttonStackView.subviews {
            (button as! UIButton).layer.cornerRadius = 2.0
        }
    }
    
}
