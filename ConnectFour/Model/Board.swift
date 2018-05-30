//
//  Board.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/30/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import Foundation

enum ChipType: Int {
    case none = 0
    case cross
    case circle
}

class Board: NSObject {
    static var width = 7
    static var height = 6
    
    var currentPlayer: Player!
    
    var slots = [ChipType]()
    
    var allPlayers: [Player]!
    
    var opponent: Player {
        if currentPlayer?.chipType == .cross {
            return self.allPlayers[1]
        } else {
            return self.allPlayers[0]
        }
    }
    
    init(with config: GameConfig) {
        for _ in 0..<Board.width*Board.height {
            slots.append(.none)
        }
        
        allPlayers = [
            Player(chipType: .cross, config: config),
            Player(chipType: .circle, config: config)
        ]
        
        currentPlayer = allPlayers[0]
    }
    
    func chip(in column: Int, row: Int) -> ChipType {
        return slots[row + column * Board.height]
    }
    
    func set(chip: ChipType, in column: Int, _ row: Int) {
        slots[row + column * Board.height] = chip
    }
    
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0..<Board.height {
            if chip(in: column, row: row) == .none {
                return row
            }
        }
        
        return nil
    }
    
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    func add(chip: ChipType, in column: Int) {
        if let row = nextEmptySlot(in: column) {
            set(chip: chip, in: column, row)
        }
    }
    
    func isFull() -> Bool {
        for column in 0..<Board.width {
            if canMove(in: column) {
                return false
            }
        }
        
        return true
    }
    
    func isWin(for player: Player) -> Bool {
        let chip = player.chipType
        
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
    
    func squareMatch(initialChip: ChipType, row: Int, column: Int, moveX: Int, moveY: Int) -> Bool {
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
            chip(in: column, row: row) == initialChip,
            chip(in: column + moveX, row: row+moveY) == initialChip,
            chip(in: column + (moveX*2), row: row+(moveY*2)) == initialChip,
            chip(in: column + (moveX*3), row: row+(moveY*3)) == initialChip
            else {
                return false
        }
        
        return true
    }
}

