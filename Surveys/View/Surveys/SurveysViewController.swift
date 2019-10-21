//
//  SurveysViewController.swift
//  Surveys
//
//  Created by Apple on 10/20/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

class SurveysViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak  var layout: UICollectionViewFlowLayout!
    var pageControl: CustomImagePageControl!
    
    let dataSource = SurveyDataSource()
    var service : LoginService!
    
    lazy var viewModel : SurveyListViewModel = {
        let viewModel = SurveyListViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Surveys"
        
        service = LoginService.shared
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = collectionView.frame.size
        
        collectionView.frame = .zero
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self.dataSource
        
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.collectionView.reloadData()
            if let numberOfPages = self?.viewModel.dataSource?.data.value.count {
                if let pageControl = self?.pageControl {
                    pageControl.numberOfPages = numberOfPages
                }
            }
        }
        
        viewModel.dataSource?.delegate = self
        
        viewModel.onErrorHandling = { error in
            print(error)
        }
        
        setupPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.frame = .zero
        if UserDefaults.standard.object(forKey: Configuration.OAUTH_ACCESS_TOKEN) == nil {
            login()
        } else {
            viewModel.fetchData()
        }
    }
    
    private func setupPageControl() {
        pageControl = CustomImagePageControl()
        pageControl.tintColor = .clear
        pageControl.pageIndicatorTintColor = .clear
        pageControl.currentPageIndicatorTintColor = .clear
        pageControl.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        pageControl.currentPage = 1
        pageControl.numberOfPages = 10
        pageControl.frame = CGRect.init(x: view.frame.width - 50, y: (view.frame.height-collectionView.frame.height)/2, width: 50, height: collectionView.frame.height)
        pageControl.backgroundColor = .red
        view.addSubview(pageControl)
    }
    
    private func login() {
        service.login(username: Configuration.USER_NAME, password: Configuration.PASSWORD) { [weak self] result in
            DispatchQueue.main.async {
                if let value = result.value {
                    if let token = value.access_token, let type = value.token_type {
                        UserDefaults.standard.set(token, forKey: Configuration.OAUTH_ACCESS_TOKEN)
                        UserDefaults.standard.set(type, forKey: Configuration.OAUTH_TOKEN_TYPE)
                        UserDefaults.standard.synchronize()
                        
                        self?.viewModel.fetchData()
                    }
                } else if let error = result.error {
                    print(error)
                }
            }
        }
    }
}

extension SurveysViewController: SurveyDataSourceDelegate {
    func loadMore() {
        viewModel.fetchData()
    }
    
    func changeCurrentPage(_ index: Int) {
        pageControl.currentPage = index
    }
}
