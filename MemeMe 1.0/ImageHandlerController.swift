//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Sergio Martin on 5/16/19.
//  Copyright © 2019 Sergio Martin. All rights reserved.
//

import UIKit

class ImageHandlerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: ImageHandlerController Outlets
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var pickImage: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var shareButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!

    // MARK: ImageHandlerController Properties
    enum buttonTypes: Int { case photoLibrary = 1, camera }
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        
        init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
            self.topText = topText;
            self.bottomText = bottomText;
            self.originalImage = originalImage;
            self.memedImage = memedImage;
        }
    }
    let textFieldsAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -4.5,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    let textFieldsDelegate = TextFieldsDelegate();
        
    // MARK: ImageHandlerController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: ImageHandlerController Methods
    func setupUI() -> Void {
        // delegates
        self.topText.delegate = self.textFieldsDelegate
        self.bottomText.delegate = self.textFieldsDelegate
        // ui
        self.topText.defaultTextAttributes = textFieldsAttributes
        self.bottomText.defaultTextAttributes = textFieldsAttributes
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(self.shareMeme))
        shareButton.isEnabled = false;

        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(eraseImage))
        navigationBarItem.setLeftBarButtonItems([shareButton], animated: true)
        navigationBarItem.setRightBarButtonItems([cancelButton], animated: true)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // MARK: ImageHandlerController UIImagePickerControllerDelegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: {
            if (self.imageView.image != nil) {
                self.shareButton.isEnabled = true
            }
        })
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
    
    @objc func shareMeme() {
        if (imageView.image == nil) {
            // safety net for share button state
            let alert = UIAlertController(title: "Oops!", message: "Memes are supossed to have an image :(", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }

        // hide elements in the screen to take snapshot
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        toolbar.isHidden = true
        
        // generate snapshot of the screen and save memed image
        // I don't quite understand why we need this strucuture unless this is later going to be saved in local storage
        let meme = Meme(
            topText: topText.text!,
            bottomText: bottomText.text!,
            originalImage: imageView.image!,
            memedImage: generateMemedImage()
        )

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        toolbar.isHidden = false
        
        
        let avController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: [])
        present(avController, animated: true)
    }
    
    @objc func eraseImage() {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imageView.image = nil
        shareButton.isEnabled = false
    }
}

