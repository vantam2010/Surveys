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
    var paging: Paging = Paging.init(page: 1, per_page: 10, max_item: 20)
    var isLoading = false
    var delegate: SurveyDataSourceDelegate?
}

protocol SurveyDataSourceDelegate {
    func loadMore()
    func changeCurrentPage(_ index: Int)
}

class SurveyDataSource: GenericDataSource<Survey> {}

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
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if data.value.count - 1 == indexPath.row {
            if let delegate = delegate {
                delegate.loadMore()
            }
        }
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
        if let delegate = delegate {
            delegate.changeCurrentPage(currentPage)
        }
    }
}
