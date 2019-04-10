//
//  ChatNavigationButton.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 4/10/19.
//

import UIKit

class ChatNavigationButton: CustomButton {
    
    let unreadLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "Chat")!, for: .normal)
        tintColor = .navigationOverlayForeground
        adjustsImageWhenHighlighted = false
        highlightedTintColor = UIColor.navigationOverlayForeground.withAlphaComponent(0.4)
        configureUnreadBubble()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUnreadBubble() {
        unreadLabel.frame.size = CGSize(width: 16, height: 16)
        unreadLabel.frame.origin = CGPoint(x: 30, y: 8)
        unreadLabel.backgroundColor = .red
        unreadLabel.textColor = .white
        unreadLabel.font = UIFont.systemFont(ofSize: 11, weight: .heavy)
        unreadLabel.layer.cornerRadius = unreadLabel.frame.size.width/2
        unreadLabel.layer.masksToBounds = true
        unreadLabel.textAlignment = .center
        
        unreadLabel.text = "3"
    
        addSubview(unreadLabel)
    }
}
