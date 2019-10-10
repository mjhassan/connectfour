//
//  Board.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/30/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

enum ChipType: Int {
    case none = 0
    case cross
    case circle
}

class Board {
    static var width = 7
    static var height = 6
    
    let currentPlayer: BehaviorRelay<Player>!
    let gameStatus: BehaviorRelay<String> = BehaviorRelay(value: "")
    let control: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let disposeBag = DisposeBag()
    
    private let slots: BehaviorRelay<[ChipType]>
    private let allPlayers: [Player]
    
    var chipColor: String {
        return currentPlayer.value.colorHex
    }
    
    init(with config: GameConfig) {
        allPlayers = [
            Player(chipType: .cross, config: config),
            Player(chipType: .circle, config: config)
        ]
        
        slots = BehaviorRelay(value: Array(repeating: .none, count: Board.width*Board.height))
        currentPlayer = BehaviorRelay(value: allPlayers[0])
        
        bindObservars()
    }
    
    private func bindObservars() {
        slots.subscribe(onNext: { [weak self] slots in
            guard let _ws = self else { return }
            
            var gameOver = false
            if _ws.isCurrentPlayerWon() {
                _ws.gameStatus.accept("\(_ws.currentPlayer.value.name) Wins!")
                gameOver = true
            }
            else {
                var foundEmptySlot = false
                for column in 0..<Board.width {
                    if _ws.nextEmptySlot(in: column) != nil {
                        foundEmptySlot = true
                    }
                }
                
                if !foundEmptySlot {
                    _ws.gameStatus.accept("Draw!")
                    gameOver = true
                }
            }
            
            _ws.control.accept(!gameOver)
        })
            .disposed(by: disposeBag)
        
        currentPlayer.subscribe(onNext: { [weak self] player in
            // sanity check of game over situation
            guard self?.control.value == true else { return }
            
            self?.gameStatus.accept("\(player.name)'s Turn")
        }).disposed(by: disposeBag)
    }
    
    private func chip(at column: Int, row: Int) -> ChipType {
        return slots.value[row + column * Board.height]
    }
    
    private func nextEmptySlot(in column: Int) -> Int? {
        for row in 0..<Board.height {
            if chip(at: column, row: row) == .none {
                return row
            }
        }
        
        return nil
    }
    
    private func squareMatch(initialChip: ChipType, row: Int, column: Int, moveX: Int, moveY: Int) -> Bool {
        // check for move valididty
        guard
            row + (moveY*3) >= 0,
            row + (moveY*3) < Board.height,
            column + (moveX*3) >= 0,
            column + (moveX*3) < Board.width
            else {
                return false
        }
        
        // check for color consistency
        guard
            chip(at: column, row: row) == initialChip,
            chip(at: column + moveX, row: row+moveY) == initialChip,
            chip(at: column + (moveX*2), row: row+(moveY*2)) == initialChip,
            chip(at: column + (moveX*3), row: row+(moveY*3)) == initialChip
            else {
                return false
        }
        
        return true
    }
    
    func togglePlayer() {
        if currentPlayer.value.chipType == .cross {
            currentPlayer.accept(allPlayers[1])
        } else {
            currentPlayer.accept(allPlayers[0])
        }
    }
    
    func makeMove(at column: Int) -> Int? {
        guard let row = nextEmptySlot(in: column) else { return nil }
        
        var value = slots.value
        value[row + column * Board.height] = currentPlayer.value.chipType
        slots.accept(value)
        
        return row
    }
    
    func isCurrentPlayerWon() ->  Bool {
        let chip = currentPlayer.value.chipType
        
        for row in 0..<Board.height {
            for column in 0..<Board.width {
                
                // detect win; horizontally, vertically, diagonally up and down
                if squareMatch(initialChip: chip, row: row, column: column, moveX: 1, moveY: 0)
                || squareMatch(initialChip: chip, row: row, column: column, moveX: 0, moveY: 1)
                || squareMatch(initialChip: chip, row: row, column: column, moveX: 1, moveY: 1)
                || squareMatch(initialChip: chip, row: row, column: column, moveX: 1, moveY: -1) {
                    return true
                }
                
            }
        }
        
        return false
    }
}

