//
//  DetailViewController.swift
//  MemeMe 2.0
//
//  Created by Sergio Martin on 6/2/19.
//  Copyright © 2019 Sergio Martin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage!
    
    // MARK: Detail View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = self.image
        self.tabBarController?.tabBar.isHidden = true
    }
}
