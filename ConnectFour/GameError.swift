//
//  GameError.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 10/5/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

enum GameError: Error {
    case badURLFormat, network, noData, error(String)
}
