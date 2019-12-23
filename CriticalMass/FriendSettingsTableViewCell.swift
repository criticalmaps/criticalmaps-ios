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
    @IBOutlet var titleLabel: UILabel!

    private var nameChanged: ((String) -> Void)?

    @objc
    dynamic var titleLabelColor: UIColor? {
        willSet {
            titleLabel.textColor = newValue
        }
    }

    @objc
    dynamic var textFieldColor: UIColor? {
        willSet {
            textField.textColor = newValue
        }
    }

    @objc
    dynamic var placeholderColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()

        textField.delegate = self
    }

    public func configure(name: String, nameChanged: @escaping (String) -> Void) {
        textField.attributedPlaceholder = NSAttributedString(string: name,
                                                             attributes: [.foregroundColor: UIColor.settingsPlaceholderColor])
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
