//
//  GiphyDetailController.swift
//  eMoney Giphy
//
//  Created by Nikoloz Tatunashvili on 23.08.18.
//  Copyright © 2018 Nikoloz Tatunashvili. All rights reserved.
//

import UIKit
import FLAnimatedImage

class GiphyDetailController: UIViewController {
    @IBOutlet weak var imageView: FLAnimatedImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension GiphyDetailController {
    static func present(from: UIViewController, item: SearchResult.GifData) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detail = storyboard.instantiateViewController(withIdentifier: "GiphyDetailController") as? GiphyDetailController else {
            return
        }
        _ = detail.view
        detail.imageView?.loadGiphy(with: item.images.preview_gif.url, completion: {})
        detail.transitioningDelegate = from as? UIViewControllerTransitioningDelegate
        from.present(detail, animated: true, completion: nil)
    }
}
