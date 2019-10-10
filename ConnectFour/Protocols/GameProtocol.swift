//
//  GameProtocol.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 10/10/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol GameProtocol {
    var currentPlayer: BehaviorRelay<Player>! { get }
    var gameStatus: BehaviorRelay<String> { get }
    var control: BehaviorRelay<Bool> { get }
    var disposeBag: DisposeBag { get }
    var currentChipColor: String { get }
    
    init(with config: GameConfig)
    
    func togglePlayer()
    func makeMove(at column: Int) -> Int?
}
