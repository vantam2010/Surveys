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
    @IBOutlet weak  var activityIndicatorView: UIActivityIndicatorView!
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
        activityIndicatorView.isHidden = true
        activityIndicatorView.color = ThemeManager.color.text
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = collectionView.frame.size
        
        collectionView.frame = .zero
        collectionView.backgroundColor = ThemeManager.color.background
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self.dataSource
        
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            guard let self = self else {return}
            self.collectionView.reloadData()
            
            if let numberOfPages = self.viewModel.dataSource?.data.value.count {
                if let pageControl = self.pageControl {
                    pageControl.numberOfPages = numberOfPages
                }
            }
            
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        viewModel.dataSource?.delegate = self
        
        viewModel.onErrorHandling = { [weak self] error in
            guard let self = self else {return}
            NotificationManager.shared.showError(Utils.getErrorMessage(error: error))
            
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        setupPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    private func setupPageControl() {
        pageControl = CustomImagePageControl()
        pageControl.tintColor = .clear
        pageControl.pageIndicatorTintColor = .clear
        pageControl.currentPageIndicatorTintColor = .clear
        pageControl.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        pageControl.currentPage = 1
        pageControl.numberOfPages = 0
        pageControl.frame = CGRect.init(x: view.frame.width - 50, y: (view.frame.height-collectionView.frame.height)/2, width: 50, height: collectionView.frame.height)
        pageControl.backgroundColor = .red
        view.addSubview(pageControl)
    }
    
    private func login() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        service.login(username: Configuration.USER_NAME, password: Configuration.PASSWORD) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicatorView.isHidden = true
                self?.activityIndicatorView.stopAnimating()
                
                if let value = result.value {
                    if let token = value.access_token, let type = value.token_type {
                        UserDefaults.standard.set(token, forKey: Configuration.OAUTH_ACCESS_TOKEN)
                        UserDefaults.standard.set(type, forKey: Configuration.OAUTH_TOKEN_TYPE)
                        UserDefaults.standard.synchronize()
                        
                        self?.viewModel.fetchData()
                    }
                } else if let error = result.error {
                    NotificationManager.shared.showError(Utils.getErrorMessage(error: error))
                }
            }
        }
    }
    
    private func fetchData() {
        if UserDefaults.standard.object(forKey: Configuration.OAUTH_ACCESS_TOKEN) == nil {
            login()
        } else {
            if viewModel.dataSource?.data.value.count == 0 {
                activityIndicatorView.isHidden = false
                activityIndicatorView.startAnimating()
            }
            
            viewModel.fetchData()
        }
    }
    
    @IBAction func refreshButtonTapped() {
        if viewModel.dataSource?.isLoading == false {
            viewModel.dataSource?.data.value.removeAll()
            viewModel.dataSource?.paging.page = 1
            fetchData()
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
