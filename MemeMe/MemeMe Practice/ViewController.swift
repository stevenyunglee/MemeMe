//
//  ViewController.swift
//  MemeMe Practice
//
//  Created by Steve Lee on 3/3/18.
//  Copyright © 2018 Steve Lee. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var bottomToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -2.0,]

        func configureTextField(textField: UITextField, withText: String) {
            let textField = textField
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = NSTextAlignment.center
            textField.delegate = self
            let withText = withText
            textField.text = withText
        }
        
        configureTextField(textField: topTextField, withText: "TOP")
        configureTextField(textField: bottomTextField, withText: "BOTTOM")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= (getKeyboardHeight(notification) - 44)
        }
        bottomToolbar.isHidden = true
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
        bottomToolbar.isHidden = false
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Pick an image from pickerController
    // "image" is assigned the picked photo in the info dictionary. imagePickerView's image is set as "image"

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil) // Dissmiss explicitly
    }
    
    // Tapping on cancel from pickerController

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) // Dissmiss explicitely
    }

    // Album button's IBAction
    
    @IBAction func pickImage(_ sender: Any) {
        chooseSourceType(sourceType: .photoLibrary)
    }
    
    // Camera button's IBAction

    @IBAction func takePhoto(_ sender: Any) {
        chooseSourceType(sourceType: .camera)
    }
    
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
//        imagePickerView.image = nil
//        topTextField.text = "TOP"
//        bottomTextField.text = "BOTTOM"
//        shareButton.isEnabled = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        share()
    }
    
    func navBarAndToolBarHidden(hidden: Bool) {
        if hidden {
            bottomToolbar.isHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            bottomToolbar.isHidden = false
        }
    }
    
    func generateMemedImage() -> UIImage {
        // Render view to an image
        navBarAndToolBarHidden(hidden: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        navBarAndToolBarHidden(hidden: false)
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        
        let memedImage = generateMemedImage()
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func share() {
        
        guard imagePickerView.image != nil else {
            return
        }
        
        let memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            self.save()
            print("YO")
            return
        }
        
        self.present(activityController, animated: true, completion: nil)

    }

}
