//
//  SurveyViewCell.swift
//  Surveys
//
//  Created by Apple on 10/20/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

class SurveyViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    static let reuseIdentifier = "SurveyViewCell"
    
    var survey: Survey? {
        didSet {
            guard let survey = survey else { return }
            
            titleLabel.text = survey.title
            descLabel.text = survey.description
            indicator.color = ThemeManager.color.text
            
            if let coverImageUrl = survey.coverImageUrl, coverImageUrl.isValidURL {
                coverImageView.loadImageUsingCache(withUrl: "\(coverImageUrl)\(Configuration.HIGH_RESOLUTION_IMAGE_CONFIG)", resize: frame.size)
            } else {
                coverImageView.image = UIImage.imageWithColor(tintColor: ThemeManager.color.main)
            }
        }
    }
    
    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                indicator.isHidden = false
                indicator.startAnimating()
                coverImageView.image = UIImage.imageWithColor(tintColor: ThemeManager.color.background)
            } else {
                indicator.isHidden = true
                indicator.stopAnimating()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = ThemeManager.color.text
        descLabel.textColor = ThemeManager.color.text
        
        titleLabel.text = ""
        descLabel.text = ""
    }
    
    
}
