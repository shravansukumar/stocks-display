//
//  Utility.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 20/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var lowerCaseFirst: String {
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
        return result
    }
}

extension UIView {
    class func getNibName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    class func getCellIdentifier() -> String {
        return getNibName().lowerCaseFirst
    }
    
    @discardableResult func loadViewFromNib() -> UIView {
        let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let views = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        setNeedsUpdateConstraints()
        
        return view
    }
}

extension UITableView {
    func registerNib(viewClass: UIView.Type) {
        let nib = UINib(nibName: viewClass.getNibName(), bundle: nil)
        register(nib, forCellReuseIdentifier: viewClass.getCellIdentifier())
    }
    func dequeueReusableCell<T: UITableViewCell>(tableViewCellClass: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: tableViewCellClass.getCellIdentifier()) as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(tableViewCellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: tableViewCellClass.getCellIdentifier(), for: indexPath) as! T
    }
}
