//
//  GameViewModel.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/30/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import CoreGraphics

class ViewModel: ViewModelProtocol {
    let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let configs: BehaviorRelay<[GameConfig]> = BehaviorRelay(value: [])
    let error: PublishSubject<GameError> = PublishSubject<GameError>()
    let title: PublishSubject<String> = PublishSubject<String>()
    
    private var board: Board!
    
    var column: Observable<Int> = {
        return Observable.just(Board.width)
    }()
    
    let disposeBag = DisposeBag()
    
    private let service: ServiceProtocol!
    
    required init(with service: ServiceProtocol) {
        self.service = service
        
        bindObservers()
    }
    
    func bindObservers() {
        board.gameStatus.bind(to: title).disposed(by: disposeBag)
    }
    
    func resetGame() {
        isLoading.onNext(true)
        
        service.fetchData(from: Constants.URI.connectFour.rawValue) { [weak self] result in
            guard let _ws = self else { return }
            
            _ws.isLoading.onNext(false)
            
            switch result {
            case .success(let data):
                _ws.configs.accept(_ws.decode(data))
            case .failure(let error):
                _ws.error.onNext(error)
            }
        }
    }
    
    func makeMove(in column: Int) {
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chipType, in: column)
//            _delegate?.addChip(in: column, row, colorHex: board.currentPlayer.colorHex)
            
            board.currentPlayer = board.opponent
//            _delegate?.updateUI("\(board.currentPlayer.name)'s Turn")
        }
    }
    
    func centerPosition(in rect: CGRect, `for` column: Int, _ row: Int) -> CGPoint {
        let size = min(rect.width, rect.height / CGFloat(Board.height))
        
        let xOffset = rect.midX
        let yOffset = rect.maxY - size*(0.5 + CGFloat(row))
        
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    private func decode(_ data: Data) -> [GameConfig] {
        do {
            return try JSONDecoder().decode([GameConfig].self, from: data)
        } catch _ {
            return []
        }
    }
}

