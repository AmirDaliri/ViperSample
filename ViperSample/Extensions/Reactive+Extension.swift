//
//  Reactive+Extension.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/16/22.
//

import UIKit
import RxSwift

extension Reactive where Base: UIImageView {
    var isEmpty: Observable<Bool> {
        return observe(UIImage.self, "image").map{ $0 == nil }
    }
}
