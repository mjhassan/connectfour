//
//  SVProgressHUD+Rx.swift
//  ConnectFour
//
//  Created by Jahid Hassan on 10/10/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

extension Reactive where Base: SVProgressHUD {

    /// Bindable sink for `show()`, `hide()` methods.
    public static var isAnimating: Binder<Bool> {
        return Binder(UIApplication.shared) { _, visible in
            visible ? SVProgressHUD.show():SVProgressHUD.dismiss()
        }
    }

}
