//
//  FakeService.swift
//  ConnectFourTests
//
//  Created by Jahid Hassan on 10/16/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
@testable import ConnectFour

class FakeService: ServiceProtocol {
    
    enum FakeURI {
           case badURLFormat, network, noData, error, data
           
           var string: String {
               switch self {
               case .badURLFormat:
                return "bad url format"
               case .network:
                   return "network error"
               case .noData:
                   return "no data"
               case .error:
                   return "error"
               case .data:
                    return "connectFour/configuration/"
               }
           }
       }
    
    static var shared: ServiceProtocol {
        return FakeService(base: Constants.base_url)
    }
    
    fileprivate let base_url: String!
    
    let mockJSON: Data = """
        [
            {
                "id": 1234,
                "color1": "#FF0000",
                "color2": "#00FF00",
                "name1": "John",
                "name2": "Jane"
            }
        ]
    """.data(using: .utf8)!
    
    required init(base: String) {
        self.base_url = base
    }
    
    func fetchData(from uri: String, callback: @escaping (Result<Data, GameError>) -> Void) {
        switch uri {
        case FakeURI.badURLFormat.string:
            callback(.failure(.badURLFormat))
        case FakeURI.network.string:
            callback(.failure(.network))
        case FakeURI.noData.string:
            callback(.failure(.noData))
        case FakeURI.error.string:
            callback(.failure(.error("Custom error")))
        case FakeURI.data.string:
            callback(.success(mockJSON))
        default:
            fatalError(uri)
        }
    }
}
