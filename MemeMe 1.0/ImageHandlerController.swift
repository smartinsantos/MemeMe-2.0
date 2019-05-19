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
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!

    enum buttonTypes: Int { case photoLibrary = 1, camera }
    
    // MARK: ImageHandlerController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // MARK: ImageHandlerController UIImagePickerControllerDelegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: ImageHandlerController Actions
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        switch sender.tag {
        case buttonTypes.photoLibrary.rawValue:
            imagePickerController.sourceType = .photoLibrary
            break;
        case buttonTypes.camera.rawValue:
            imagePickerController.sourceType = .camera
            break;
        default:
            return
        }
        
        present(imagePickerController, animated: true, completion: nil)
    }
}

