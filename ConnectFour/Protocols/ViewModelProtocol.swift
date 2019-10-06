//
//  ViewModelProtocol.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 10/5/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol ViewModelProtocol {
    var isLoading: BehaviorSubject<Bool> { get }
    var configs: BehaviorRelay<[GameConfig]> { get }
    var error: PublishSubject<GameError> { get }
    var column: Observable<Int> { get }
    var disposeBag: DisposeBag { get }
    var title: PublishSubject<String> { get }
    
    init(with service: ServiceProtocol)
    func resetGame()
}
