//
//  CakeCommonView.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 22/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit

class CakeCommonView: UIView {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
}
