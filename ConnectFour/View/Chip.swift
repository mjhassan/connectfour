//
//  Chip.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/30/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import UIKit

class Chip: UIView {
    init(in superRect: CGRect, color: UIColor) {
        let size = min(superRect.width, superRect.height/CGFloat(Game.height))
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        super.init(frame: rect)
        
        self.frame = rect
        self.isUserInteractionEnabled = false
        self.backgroundColor = color
        self.layer.cornerRadius = size / 2
        self.transform = CGAffineTransform(translationX: 0, y: -Screen.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

