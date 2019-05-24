//
//  ImageHandlerController.swift
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
    var meme: Meme!

    // MARK: ImageHandlerController Properties
    
    enum buttonTypes: Int { case photoLibrary = 1, camera }
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
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: ImageHandlerController Methods
    
    func configureView() -> Void {
        configureViewForMeme(hide: true)
        configureTextField(topText, with: "TOP")
        configureTextField(bottomText, with: "BOTTOM")
        
        shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(self.shareMeme))
        shareButton.isEnabled = false;

        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(resetView))
        navigationBarItem.setLeftBarButtonItems([shareButton], animated: true)
        navigationBarItem.setRightBarButtonItems([cancelButton], animated: true)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    func configureTextField(_ textField: UITextField, with defaultText: String) {
        textField.delegate = textFieldsDelegate
        textField.defaultTextAttributes = textFieldsAttributes
        textField.text = defaultText
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
        if bottomText.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func configureViewForMeme(hide: Bool) {
        // hide/show elements on screen for snapshot
        self.navigationController?.setNavigationBarHidden(hide, animated: false)
        toolbar.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage {
        configureViewForMeme(hide: true)
    
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureViewForMeme(hide: false)
        
        return memedImage
    }
    
    func saveMeme() {
        self.meme = Meme(
            topText: topText.text!,
            bottomText: bottomText.text!,
            originalImage: imageView.image!,
            memedImage: generateMemedImage()
        )
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
        
        // generate snapshot of the screen and save memed image
        let generatedMeme = generateMemedImage()
        
        let avController = UIActivityViewController(activityItems: [generatedMeme], applicationActivities: [])
        avController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                self.saveMeme()
            }
        }

        present(avController, animated: true)
    }
    
    @objc func resetView() {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imageView.image = nil
        shareButton.isEnabled = false
    }
}

