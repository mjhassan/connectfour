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
    
    lazy var rightBarButton = UIBarButtonItem(title: "Play Again!",
                                              style: .plain,
                                              target: self,
                                              action: #selector(GameController.resetBoard))
    
    var placedChips = [[UIView]]()
    private lazy var viewModel: ViewModelProtocol = {
        let _vm = ViewModel(with: BlackistAPI.shared)
        return _vm
    }()
    
    var isLoading = false {
        didSet {
            DispatchQueue.main.async {
                if oldValue {
                    SVProgressHUD.dismiss()
                } else {
                    SVProgressHUD.show()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.column.subscribe(onNext: { cl in
            self.placedChips.append([UIView]())
        })
        
        viewModel.resetGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

// public methods
extension GameController {
    func updateUI(_ title: String) {
        self.title = title
    }
    
    func updateControl(_ enable: Bool) {
        self.view.isUserInteractionEnabled = enable
        self.navigationItem.rightBarButtonItem = enable ? nil:rightBarButton
    }
    
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
