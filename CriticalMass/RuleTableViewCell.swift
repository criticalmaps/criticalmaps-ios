//
//  RuleTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import UIKit

class RuleTableViewCell: UITableViewCell, NibProviding {
    
    @objc
    dynamic var ruleTextColor: UIColor? {
        didSet { label.textColor = ruleTextColor }
    }

    @IBOutlet var label: UILabel!
}
