//
//  BlackistAPI.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/30/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import Foundation

let BlackistAPI = _BlackistAPI()

class _BlackistAPI {
    fileprivate static let base_url = "https://private-75c7a5-blinkist.apiary-mock.com/connectFour/configuration"
    
    func getConfig(onSuccess: (([GameConfig])->Void)?, onError: ((Error?)->Void)?) {
        guard let url = URL(string: _BlackistAPI.base_url) else {
            onError?(NSError(domain: "Bad url format.", code: -1000, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                onError?(error)
            }
            
            guard let data = data else {
                onError?(NSError(domain: "Empty or null data response.", code: 400, userInfo: nil))
                return
            }
            
            do {
                let configData = try JSONDecoder().decode([GameConfig].self, from: data)
                print("\(configData)")
                onSuccess?(configData)
            } catch let error {
                onError?(error)
            }
            }.resume()
    }
}
