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
import CoreGraphics

protocol ViewModelProtocol {
    var isLoading: BehaviorSubject<Bool> { get }
    var configs: PublishSubject<[GameConfig]> { get }
    var error: PublishSubject<GameError> { get }
    var move: PublishSubject<(Int, Int, String)> { get }
    var disposeBag: DisposeBag { get }
    var title: BehaviorRelay<String> { get }
    var control: BehaviorRelay<Bool> { get }
    var column: PublishSubject<Int> { get }
    
    init(with service: ServiceProtocol)
    func resetGame()
    func makeMove(at column: Int)
    func position(of rect: CGRect, `for` column: Int, _ row: Int) -> CGPoint
}
