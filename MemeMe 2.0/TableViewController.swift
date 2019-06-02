//
//  TableViewController.swift
//  MemeMe 2.0
//
//  Created by Sergio Martin on 6/2/19.
//  Copyright © 2019 Sergio Martin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    var addButton: UIBarButtonItem!
    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // load data from delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes

        // reload data into table view
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.reloadData()
    }
    
    func configureView() {
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.launcheMemeEditor))
        navigationBarItem.setRightBarButtonItems([addButton], animated: true)
    }
    
    @objc func launcheMemeEditor() {
        let ihController = self.storyboard!.instantiateViewController(withIdentifier: "ImageHandlerController") as! ImageHandlerController

        self.present(ihController, animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableMemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        detailController.image = meme.memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
