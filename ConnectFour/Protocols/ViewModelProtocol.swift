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
    var error: PublishSubject<GameError> { get }
    var move: PublishSubject<(Int, Int, String)> { get }
    var column: PublishSubject<Int> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var title: BehaviorRelay<String> { get }
    var control: BehaviorRelay<Bool> { get }
    var disposeBag: DisposeBag { get }
    
    init(with service: ServiceProtocol)
    
    func resetGame()
    func makeMove(at column: Int)
    func position(of rect: CGRect, `for` column: Int, _ row: Int) -> CGPoint
}
