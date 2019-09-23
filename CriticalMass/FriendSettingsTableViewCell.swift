//
//  FriendSettingsTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 23.09.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class FriendSettingsTableViewCell: UITableViewCell, IBConstructable, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    private var nameChanged: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        textField.delegate = self
    }

    public func configure(name: String, nameChanged: @escaping (String) -> Void) {
        textField.placeholder = name
        self.nameChanged = nameChanged
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        nameChanged?(textField.text ?? "")
    }
}
