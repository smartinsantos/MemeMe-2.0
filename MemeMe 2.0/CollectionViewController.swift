//
//  CollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Sergio Martin on 6/2/19.
//  Copyright © 2019 Sergio Martin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    @IBOutlet weak var navigationBarItem: UINavigationItem!
    var addButton: UIBarButtonItem!
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // load data from delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        
        collectionView?.reloadData()
    }
    
    func configureView() {
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.launcheMemeEditor))
        navigationBarItem.setRightBarButtonItems([addButton], animated: true)
    }

    @objc func launcheMemeEditor() {
        let ihController = self.storyboard!.instantiateViewController(withIdentifier: "ImageHandlerController") as! ImageHandlerController
        
        self.present(ihController, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionMemeCell", for: indexPath) as! CollectionViewCell
    
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        detailController.image = meme.memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
