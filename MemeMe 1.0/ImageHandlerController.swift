//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Sergio Martin on 5/16/19.
//  Copyright © 2019 Sergio Martin. All rights reserved.
//

import UIKit

class ImageHandlerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pickImage: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("this is the info: \(info)")
        
        if let image = info
    }
    
    @IBAction func pickAnImage(_ sender:Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
    
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
}

