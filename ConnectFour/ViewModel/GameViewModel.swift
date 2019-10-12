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
    private let configs: PublishSubject<[GameConfig]>   = PublishSubject<[GameConfig]>()
    
    let error: PublishSubject<GameError>                = PublishSubject<GameError>()
    let column: PublishSubject<Int>                     = PublishSubject<Int>()
    let move: PublishSubject<(Int, Int, String)>        = PublishSubject<(Int, Int, String)>()
    let title: BehaviorRelay<String>                    = BehaviorRelay(value: "Game is loading")
    let isLoading: BehaviorRelay<Bool>                  = BehaviorRelay(value: true)
    let control: BehaviorRelay<Bool>                    = BehaviorRelay(value: false)
    let disposeBag: DisposeBag                          = DisposeBag()
    
    private var game: GameProtocol!
    private let service: ServiceProtocol!
    
    required init(with service: ServiceProtocol) {
        self.service = service
        
        bindObservers()
    }
    
    func resetGame() {
        isLoading.accept(true)
        
        service.fetchData(from: Constants.URI.connectFour.rawValue) { [weak self] result in
            guard let _ws = self else { return }
            
            _ws.isLoading.accept(false)
            _ws.column.onNext(Game.width)
            
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
        guard let row = game.makeMove(at: column) else { return }
        
        move.onNext((row, column, game.currentChipColor))
        game.togglePlayer()
    }
    
    func position(of rect: CGRect, `for` column: Int, _ row: Int) -> CGPoint {
        let size = min(rect.width, rect.height / CGFloat(Game.height))
        
        let xOffset = rect.midX
        let yOffset = rect.maxY - size*(0.5 + CGFloat(row))
        
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    private func bindObservers() {
        configs
            .subscribe(onNext: { [weak self] config in
                guard let _ws = self,
                    let _config = config.first else { return }
                
                self?.game = Game(with: _config)
                
                _ws.game.gameStatus.bind(to: _ws.title).disposed(by: _ws.disposeBag)
                _ws.game.control.bind(to: _ws.control).disposed(by: _ws.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    private func decode(_ data: Data) -> [GameConfig] {
        do {
            return try JSONDecoder().decode([GameConfig].self, from: data)
        } catch _ {
            return []
        }
    }
}

