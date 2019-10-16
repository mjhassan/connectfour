//
//  Service.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/30/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift

class Service: ServiceProtocol {    
    private static let instance = Service()
    static var shared: ServiceProtocol {
        return instance
    }
    
    fileprivate let base_url: String!
    
    private let mockJSON: Data = """
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
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            callback(.success(self.mockJSON))
        }
        
        /*
        guard let url = URL(string: base_url+uri) else {
            callback(.failure(.badURLFormat))
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                callback(.failure(.error(error?.localizedDescription ?? "Unknown error occured")))
                return
            }
            
            guard let data = data else {
                callback(.failure(.noData))
                return
            }
            
            callback(.success(data))
        }.resume()
        */
    }
}
