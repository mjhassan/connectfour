//
//  ViewController.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 5/29/18.
//  Copyright © 2018 Jahid Hassan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class GameController: UIViewController {

    @IBOutlet var columnButtons: [UIButton]!
    
    private lazy var rightBarButton = UIBarButtonItem(title: "Play Again!",
                                              style: .plain,
                                              target: self,
                                              action: #selector(GameController.resetBoard))
    
    private var placedChips = [[UIView]]()
    private lazy var viewModel: ViewModelProtocol = {
        let _vm = ViewModel(with: BlackistAPI.shared)
        return _vm
    }()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.column.subscribe(onNext: { cl in
            self.placedChips.append([UIView]())
        })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.resetGame()
    }
    
    // IBAction
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        viewModel.makeMove(in:column)
    }
    
    // private methods
    @objc private func resetBoard() {
        viewModel.resetGame()
    }
    
    private func bindObserver() {
        viewModel.title.bind(to: self.rx.title).disposed(by: viewModel.disposeBag)
        //// bind on a subscription
        //self.view.isUserInteractionEnabled = enable
        //self.navigationItem.rightBarButtonItem = enable ? nil:rightBarButton
        
    }
}

// public methods
extension GameController {
    
    func resetChips() {
        for idx in 0..<placedChips.count {
            for chip in placedChips[idx] {
                chip.removeFromSuperview()
            }
            
            placedChips[idx].removeAll(keepingCapacity: true)
        }
    }
    
    func addChip(in column: Int, _ row: Int, colorHex: String) {
        let button = columnButtons[column]
        
        if placedChips[column].count < row+1 {
            let newChip = Chip(in: button.frame, color: UIColor(hexString: colorHex))
            newChip.center = viewModel.centerPosition(in: button.frame, for: column, row)
            view.addSubview(newChip)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            }, completion: nil)
            
            placedChips[column].append(newChip)
        }
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "ERROR!", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            self?.viewModel.resetGame()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
