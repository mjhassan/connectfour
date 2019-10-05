//
//  ServiceProtocol.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 10/5/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    static var shared: ServiceProtocol { get }
    
    init(base: String)
    
    func fetchData(from uri: String, callback:@escaping (Result<Data, GameError>) -> Void)
}

extension ServiceProtocol {
    init() { self.init(base: Constants.base_url) }
}
