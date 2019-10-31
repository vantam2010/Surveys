//
//  CustomImagePageControl.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

class CustomImagePageControl: UIPageControl {
    
    @IBInspectable var activeImage: UIImage? = UIImage(named: "dot")
    @IBInspectable var inactiveImage: UIImage? = UIImage(named: "circleOutline")
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pageIndicatorTintColor = .clear
        currentPageIndicatorTintColor = .clear
        clipsToBounds = false
    }
    
    private func updateDots() {
        
        for (index, subview) in subviews.enumerated() {
            let imageView: UIImageView
            
            if let existingImageview = getImageView(forSubview: subview) {
                imageView = existingImageview
            } else {
                imageView = UIImageView(image: inactiveImage)
                
                imageView.center = subview.center
                subview.addSubview(imageView)
                subview.clipsToBounds = false
            }
            
            imageView.image = currentPage == index ? activeImage : inactiveImage
        }
    }
    
    private func getImageView(forSubview view: UIView) -> UIImageView? {
        var dot:UIImageView?
        
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        
        return dot
    }
}
