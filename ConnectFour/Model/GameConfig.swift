//
//  GameConfig.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/30/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import Foundation

struct GameConfig: Codable {
    let id: Int
    let color1: String
    let color2: String
    let name1: String
    let name2: String
}
