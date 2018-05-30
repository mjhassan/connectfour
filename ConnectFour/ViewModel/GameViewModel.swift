//
//  GameViewModel.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/30/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import Foundation
import CoreGraphics

class ViewModel {
    weak var _delegate: GameController?
    var board: Board!
    
    var column: Int = {
        return Board.width
    }()
    
    init(with delegate: GameController?) {
        _delegate = delegate
    }
    
    @objc func resetGame() {
        _delegate?.isLoading = true
        
        BlackistAPI.getConfig(onSuccess: { [weak self] config in
            self?._delegate?.isLoading = false
         
            self?.board = Board(with: config[0])
            
            DispatchQueue.main.async {
                self?._delegate?.resetChips()
                
                if let playerName = self?.board.currentPlayer.name {
                    self?._delegate?.updateUI("\(playerName)'s Turn")
                }
                self?._delegate?.updateControl(true)
            }
        }) { [weak self] error in
            self?._delegate?.isLoading = false
            
            DispatchQueue.main.async {
                self?._delegate?.showAlert(msg: error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    func makeMove(in column: Int) {
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chipType, in: column)
            _delegate?.addChip(in: column, row, colorHex: board.currentPlayer.colorHex)
            
            var title: String? = nil
            
            if board.isWin(for: board.currentPlayer) {
                title = "\(board.currentPlayer.name) Wins!"
            } else if board.isFull() {
                title = "Draw!"
            }
            
            if let title = title {
                _delegate?.updateUI(title)
                _delegate?.updateControl(false)
                
                return
            }
            
            board.currentPlayer = board.opponent
            _delegate?.updateUI("\(board.currentPlayer.name)'s Turn")
        }
    }
    
    func centerPosition(in rect: CGRect, `for` column: Int, _ row: Int) -> CGPoint {
        let size = min(rect.width, rect.height / CGFloat(Board.height))
        
        let xOffset = rect.midX
        let yOffset = rect.maxY - size*(0.5 + CGFloat(row))
        
        return CGPoint(x: xOffset, y: yOffset)
    }
}

