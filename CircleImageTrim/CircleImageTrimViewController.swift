//
//  CircleImageTrimViewController.swift
//  CircleImageTrim
//
//  Created by Ryota Iwai on 2015/10/19.
//  Copyright © 2015年 Ryota Iwai. All rights reserved.
//

import UIKit

// MARK: - CircleImageTrimViewControllerDelegate Protocol
protocol CircleImageTrimViewControllerDelegate: class {
    func didFinish(trimViewController: CircleImageTrimViewController, trimImage: UIImage?)
}

// MARK: - CircleImageTrimViewController
class CircleImageTrimViewController: UIViewController {
    
    // MARK: - Outlet properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var maskView: CircleHollowView!
    @IBOutlet weak var headerView: UIView!
    
    // MARK:- Internal properties
    var originImage: UIImage?
    weak var delegate: CircleImageTrimViewControllerDelegate?
    
    // MARK:- Private properties
    private var prevStatusBarStyle: UIStatusBarStyle = .Default
    private var contentsView: UIView?
    private var imageView: UIImageView?
    
    // MARK:- Override method
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.prevStatusBarStyle = UIApplication.sharedApplication().statusBarStyle
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(self.prevStatusBarStyle, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.view.frame.width != UIScreen.mainScreen().bounds.width {
            return
        }
        if self.imageView == nil {
            self.setupImgeView()
        }
    }
    
    // MARK:- Private method
    private func setupImgeView() {
        guard let originImage = self.originImage else { return }
        
        var contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.contentsView = UIView(frame: CGRect(origin: CGPointZero, size: contentSize))
        self.contentsView?.backgroundColor = UIColor.clearColor()
        self.scrollView.addSubview(self.contentsView!)
        
        var imageViewOrigin = CGPointZero
        let ratio = self.view.frame.width / originImage.size.width
        let imageViewSize = CGSize(width: self.view.frame.width, height: originImage.size.height * ratio)
        if imageViewSize.height > contentSize.height {
            contentSize.height = imageViewSize.height
            self.contentsView?.frame.size = contentSize
        } else {
            imageViewOrigin.y = (contentSize.height - imageViewSize.height) / 2
        }
        self.scrollView.contentSize = contentSize
        let insetSizeHeight = (imageViewSize.height * 3) < contentSize.height ? imageViewSize.height : ((imageViewSize.height * 3) - contentSize.height) / 2
        self.scrollView.contentInset = UIEdgeInsetsMake(insetSizeHeight, contentSize.width / 2, insetSizeHeight, contentSize.width / 2)
        
        self.imageView = UIImageView(frame: CGRect(origin: imageViewOrigin, size: imageViewSize))
        self.imageView?.backgroundColor = UIColor.clearColor()
        self.imageView?.contentMode = .ScaleAspectFit
        self.imageView?.image = self.originImage
        
        self.contentsView?.addSubview(self.imageView!)
        
        self.scrollView.minimumZoomScale = 0.2
        self.scrollView.maximumZoomScale = 20
        self.scrollView.zoomScale = 1
    }
    
    private func trimRect() -> CGRect {
        guard let imageView = self.imageView else { return CGRectZero }
        guard let originImage = self.originImage else { return CGRectZero }

        let trimRect = imageView.convertRect(CGRect(
            x: self.maskView.ovalRect.minX + self.scrollView.frame.minX,
            y: self.maskView.ovalRect.minY + self.scrollView.frame.minY,
            width: self.maskView.ovalRect.width,
            height: self.maskView.ovalRect.height), fromView: self.view)
        
        let factor = (originImage.size.width / imageView.bounds.size.width)
        
        return CGRect(
            x: floor(trimRect.minX * factor),
            y: floor(trimRect.minY * factor),
            width: floor(trimRect.width * factor),
            height: floor(trimRect.height * factor))
    }
    
    // MARK:- Action method
    @IBAction func tapCancelButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tapFinishButton(sender: AnyObject) {
        var trimImage: UIImage? = nil
        if let originImage = self.originImage {
            trimImage = originImage.trimImage(trimRect: self.trimRect())
        }
        
        self.delegate?.didFinish(self, trimImage: trimImage)
    }
}


// MARK:- UIScrollViewDelegate
extension CircleImageTrimViewController: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.contentsView
    }
}