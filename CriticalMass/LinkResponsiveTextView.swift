//
//  LinkResponsiveTextView.swift
//  CriticalMaps
//
//  Created by MAXIM TSVETKOV on 03.10.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class LinkResponsiveTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        delaysContentTouches = false
        // required for tap to pass through on to superview & for links to work
        isScrollEnabled = false
        isEditable = false
        isUserInteractionEnabled = true
        isSelectable = true
    }

    override func hitTest(_ point: CGPoint, with _: UIEvent?) -> UIView? {
        // location of the tap
        var location = point
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top

        // find the character that's been tapped
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < textStorage.length {
            // if the character is a link, handle the tap as UITextView normally would
            if textStorage.attribute(NSAttributedString.Key.link, at: characterIndex, effectiveRange: nil) != nil {
                return self
            }
        }

        // otherwise return nil so the tap goes on to the next receiver
        return nil
    }
}
