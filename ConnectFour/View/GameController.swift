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
        
        bindObserver()
        resetBoard()
    }
    
    // IBAction
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        viewModel.makeMove(at: column)
    }
    
    // private methods
    @objc private func resetBoard() {
        navigationItem.rightBarButtonItem = nil
        viewModel.resetGame()
    }
    
    private func bindObserver() {
        viewModel.title.bind(to: self.rx.title).disposed(by: viewModel.disposeBag)
        viewModel.isLoading.bind(to: SVProgressHUD.rx.isAnimating).disposed(by: viewModel.disposeBag)
        
        viewModel.column
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] cl in
                guard let _ws = self else { return }
                
                if _ws.placedChips.isEmpty {
                    for _ in 0..<cl {
                        self?.placedChips.append([UIView]())
                    }
                    
                    return
                }
                
                for idx in 0..<_ws.placedChips.count {
                    for chip in _ws.placedChips[idx] {
                        chip.removeFromSuperview()
                    }
                    
                    _ws.placedChips[idx].removeAll(keepingCapacity: true)
                }
            }).disposed(by: viewModel.disposeBag)
        
        viewModel.control
            .observeOn(MainScheduler.instance)
            .bind(to: view.rx.isUserInteractionEnabled)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.error
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "ERROR!",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "Try Again", style: .default) { _ in
                    self?.resetBoard()
                }
                
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: viewModel.disposeBag)
        
        viewModel.move
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] row, column, colorHex in
                guard let _ws = self,
                    _ws.placedChips[column].count < row+1 else { return }
                
                let button = _ws.columnButtons[column]
                let newChip = Chip(in: button.frame, color: UIColor(hexString: colorHex))
                newChip.center = _ws.viewModel.position(of: button.frame, for: column, row)
                _ws.view.addSubview(newChip)
                    
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    newChip.transform = CGAffineTransform.identity
                }, completion: nil)
                
                _ws.placedChips[column].append(newChip)
            }).disposed(by: viewModel.disposeBag)
        
        viewModel.control
            .skip(1)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] enable in
                guard enable == false,
                    let _ws = self else { return }
                
                let alert = UIAlertController(title: _ws.viewModel.title.value,
                                              message: nil,
                                              preferredStyle: .alert)
                let tryAction = UIAlertAction(title: "Play Again", style: .default) { _ in
                    _ws.resetBoard()
                }
                alert.addAction(tryAction)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                    _ws.navigationItem.rightBarButtonItem = self?.rightBarButton
                }
                alert.addAction(okAction)
                
                _ws.present(alert, animated: true, completion: nil)
            }).disposed(by: viewModel.disposeBag)
    }
}
