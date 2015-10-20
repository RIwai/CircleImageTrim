//
//  MainVIewController.swift
//  CircleImageTrim
//
//  Created by Ryota Iwai on 2015/10/16.
//  Copyright © 2015年 Ryota Iwai. All rights reserved.
//

import UIKit

class MainVIewController: UIViewController {
    
    // MARK: - Outlet properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    
    // MARK: Private property
    private var imagePicker: UIImagePickerController? = nil
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.clipsToBounds = true
        self.clearButton.enabled = false
        
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "seletImage"))
        self.imageView.userInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
    }
    
    // MARK: - Internal methods
    func seletImage() {
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        
        // Show camera roll
        self.imagePicker = UIImagePickerController()
        if let imagePicker = self.imagePicker {
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Action methods
    @IBAction func tapClearButton(sender: AnyObject) {
        self.imageView.image = nil
        self.clearButton.enabled = false
    }
    
    @IBAction func tapSetButton(sender: AnyObject) {
        self.seletImage()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate for UIImagePickerController
extension MainVIewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            picker.delegate = nil
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            return
        }
        
        guard let trimViewController: CircleImageTrimViewController = UIStoryboard(name: "CircleImageTrimViewController", bundle: nil).instantiateViewControllerWithIdentifier("CircleImageTrimViewController") as? CircleImageTrimViewController else {
            picker.delegate = nil
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            return
        }
        
        picker.navigationBarHidden = true
        trimViewController.originImage = selectedImage
        trimViewController.delegate = self
        picker.pushViewController(trimViewController, animated: true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.delegate = nil
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MainVIewController: CircleImageTrimViewControllerDelegate {
    
    func didFinish(trimViewController: CircleImageTrimViewController, trimImage: UIImage?) {
        self.imageView.image = trimImage
        self.clearButton.enabled = true
        self.imagePicker?.delegate = nil
        self.imagePicker?.dismissViewControllerAnimated(true, completion: nil)
    }
}

