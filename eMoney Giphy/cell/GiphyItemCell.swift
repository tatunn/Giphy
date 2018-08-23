//
//  GiphyItemCell.swift
//  eMoney Giphy
//
//  Created by Nikoloz Tatunashvili on 23.08.18.
//  Copyright © 2018 Nikoloz Tatunashvili. All rights reserved.
//

import UIKit
import FLAnimatedImage

class GiphyItemCell: UICollectionViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: FLAnimatedImageView!
    
    func configure(with item: SearchResult.GifData) {
        indicator.startAnimating()
        imageView.loadGiphy(with: item.images.preview_gif.url) { [weak self] in
            self?.indicator.stopAnimating()
        }
    }
}

