//
//  UITableViewController+FooterSize.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 10.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension UITableViewController {
    func sizeFooterToFit() {
        guard let footerView = tableView.tableFooterView else {
            return
        }
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let footerFrame = footerView.frame
        if height != footerFrame.size.height {
            footerView.frame.size.height = height
            tableView.tableFooterView = footerView
        }
    }
}
