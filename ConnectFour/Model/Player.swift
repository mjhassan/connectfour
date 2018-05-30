//
//  Player.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/30/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import Foundation

class Player: NSObject {
    var chipType: ChipType
    var colorHex: String
    var name: String
    var id: Int
    
    init(chipType: ChipType, config: GameConfig) {
        self.chipType = chipType
        self.id = config.id
        
        if chipType == .cross {
            colorHex = config.color1
            name = config.name1
        } else {
            colorHex = config.color2
            name = config.name2
        }
        
        super.init()
    }
}

