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
    let configs: PublishSubject<[GameConfig]> = PublishSubject<[GameConfig]>()
    let error: PublishSubject<GameError> = PublishSubject<GameError>()
    let move: PublishSubject<(Int, Int, String)> = PublishSubject<(Int, Int, String)>()
    let title: BehaviorRelay<String> = BehaviorRelay(value: "Game is loading")
    let control: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let column: PublishSubject<Int> = PublishSubject<Int>()
    let disposeBag = DisposeBag()
    
    private var board: Board!
    private let service: ServiceProtocol!
    
    required init(with service: ServiceProtocol) {
        self.service = service
        
        bindObservers()
    }
    
    func bindObservers() {
        configs
            .subscribe(onNext: { [weak self] config in
                guard let _ws = self,
                    let _config = config.first else { return }
                
                self?.board = Board(with: _config)
                _ws.board.gameStatus.bind(to: _ws.title).disposed(by: _ws.disposeBag)
                _ws.board.control.bind(to: _ws.control).disposed(by: _ws.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    func resetGame() {
        isLoading.onNext(true)
        
        service.fetchData(from: Constants.URI.connectFour.rawValue) { [weak self] result in
            guard let _ws = self else { return }
            
            _ws.isLoading.onNext(false)
            _ws.column.onNext(Board.width)
            
            switch result {
            case .success(let data):
                let configs = _ws.decode(data)
                _ws.configs.onNext(configs)
            case .failure(let error):
                _ws.error.onNext(error)
            }
        }
    }
    
    func makeMove(at column: Int) {
        guard let row = board.makeMove(at: column) else { return }
        
        move.onNext((row, column, board.chipColor))
        board.togglePlayer()
    }
    
    func position(of rect: CGRect, `for` column: Int, _ row: Int) -> CGPoint {
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

