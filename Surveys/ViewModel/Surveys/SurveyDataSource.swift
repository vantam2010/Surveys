//
//  SurveyDataSource.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

class GenericDataSource<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}

class SurveyDataSource: GenericDataSource<Survey> {
    
    private lazy var indicator: CustomImagePageControl = {
        let con = CustomImagePageControl()
        con.tintColor = .clear
        con.pageIndicatorTintColor = .clear
        con.currentPageIndicatorTintColor = .clear
        con.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        con.currentPage = 0
        con.numberOfPages = 20
        return con
    }()
    
}

// MARK: - Extensions
extension SurveyDataSource: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveyViewCell", for: indexPath) as? SurveyViewCell {
            if let survey = data.value.getElement(indexPath.row) {
                cell.survey = survey
            }
            
            if indexPath.row%2 == 0 {
                cell.backgroundColor = .black
            } else {
                cell.backgroundColor = .gray
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if viewModel.shouldLoadMore(indexPath) {
//            viewModel.loadMore()
//        }
    }
}

extension SurveyDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.y
        let height = scrollView.bounds.size.height
        let currentPage = Int(ceil(offsetX/height))
        indicator.currentPage = currentPage
    }
}
