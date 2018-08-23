//
//  ViewController.swift
//  eMoney Giphy
//
//  Created by Nikoloz Tatunashvili on 22.08.18.
//  Copyright © 2018 Nikoloz Tatunashvili. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextField!
    
    fileprivate var dataSource: [SearchResult.GifData] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    fileprivate lazy var store: GiphyStore = {
        return GiphyStore(completion: { [weak self] (data, update) in
            self?.fetched(data: data, update: update)
        })
    }()
    
    fileprivate let transition = PopAnimator()
    fileprivate var selectedView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "GiphyItemCell", bundle: nil), forCellWithReuseIdentifier: "GiphyItemCell")
        store.search(query: "steve jobs")
    }

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        store.search(query: sender.text)
    }
    
    private func fetched(data: [SearchResult.GifData], update: Bool) {
        if update == true {
            self.collectionView?.performBatchUpdates({
                let oldCount = dataSource.count
                dataSource.append(contentsOf: data)
                let indexpaths = (oldCount..<dataSource.count).map({ IndexPath(row: $0, section: 0) })
                collectionView.insertItems(at: indexpaths)
            }, completion: nil)
            return
        }
        dataSource = data
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        store.search(query: nil)
        return true
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiphyItemCell", for: indexPath) as! GiphyItemCell
        cell.configure(with: dataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item + 10 == dataSource.count {
            store.nextPage()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedView = collectionView.cellForItem(at: indexPath)
        GiphyDetailController.present(from: self, item: dataSource[indexPath.item])
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let selectedView = selectedView  {
            transition.originFrame = selectedView.superview?.convert(selectedView.frame, to: nil) ?? .zero
        }
        
        transition.presenting = true
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
