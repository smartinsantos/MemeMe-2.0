//
//  TableViewController.swift
//  MemeMe 2.0
//
//  Created by Sergio Martin on 6/2/19.
//  Copyright © 2019 Sergio Martin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    var addButton: UIBarButtonItem!
    // MARK: TableViewController: memes init
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addMeme))
        navigationBarItem.setRightBarButtonItems([addButton], animated: true)
    }
    
    @objc func addMeme() {

        let ihController = self.storyboard!.instantiateViewController(withIdentifier: "ImageHandlerController") as! ImageHandlerController

        self.present(ihController, animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableMemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
}
