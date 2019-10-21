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
    
    public static let reuseIdentifier = "SurveyViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = .white
        descLabel.textColor = .white
    }
    
    public var survey: Survey? {
        didSet {
            guard let survey = survey else { return }
            
            titleLabel.text = survey.title
            descLabel.text = survey.description
            
            if let cover_image_url = survey.cover_image_url, cover_image_url.isValidURL {
                coverImageView.loadImageUsingCache(withUrl: "\(cover_image_url)\(Configuration.HIGH_RESOLUTION_IMAGE_CONFIG)", resize: self.frame.size)
            } else {
                coverImageView.image = UIImage.imageWithColor(tintColor: .black)
            }
        }
    }
    
}
