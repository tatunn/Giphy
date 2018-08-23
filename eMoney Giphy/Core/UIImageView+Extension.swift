//
//  UIImageView+Extension.swift
//  eMoney Giphy
//
//  Created by Nikoloz Tatunashvili on 23.08.18.
//  Copyright © 2018 Nikoloz Tatunashvili. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

extension FLAnimatedImageView {
    func loadGiphy(with url: URL, completion: @escaping () -> ()) {
        SDWebImageCodersManager.sharedInstance().addCoder(SDWebImageGIFCoder.shared())
        self.sd_setImage(with: url) { (i: UIImage?, e: Error?, s: SDImageCacheType, u: URL?) in
            completion()
            if let image = i, s == SDImageCacheType.none {
                self.alpha = 0
                UIView.transition(with: self, duration: 0.3,
                                  options: .transitionCrossDissolve, animations: {
                                    self.image = image
                                    self.alpha = 1
                }, completion: nil)
            }
            else {
                self.alpha = 1
            }
        }
    }
}
