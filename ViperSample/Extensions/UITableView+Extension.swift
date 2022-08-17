//
//  UITableView+Extension.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/17/22.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell>(type: T.Type) {
        let className = String(describing: type.self)
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forCellReuseIdentifier: className)
    }
}
